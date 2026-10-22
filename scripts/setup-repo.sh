#!/usr/bin/env bash
# Applies the standard project configuration to a GitHub repository:
#   - labels
#   - merge settings (delete branch on merge, no rebase merge)
#   - branch protection rules on `main`
#
# Usage:
#   ./scripts/setup-repo.sh <owner/repo> [--squash-only] [--approvals N]
#
# Examples:
#   ./scripts/setup-repo.sh my-org/my-project
#   ./scripts/setup-repo.sh my-org/my-project --squash-only
#   ./scripts/setup-repo.sh my-org/solo-project --approvals 0
#
# Requirements: GitHub CLI (`gh`), authenticated with admin rights on the repo,
# and the `main` branch must already exist (push at least one commit first).

set -euo pipefail

REPO="${1:-}"
BRANCH="main"
SQUASH_ONLY=false
APPROVALS=1

if [[ -z "$REPO" ]]; then
  echo "Usage: $0 <owner/repo> [--squash-only] [--approvals N]"
  exit 1
fi
shift

while [[ $# -gt 0 ]]; do
  case "$1" in
    --squash-only) SQUASH_ONLY=true ;;
    --approvals)   APPROVALS="${2:?--approvals needs a number}"; shift ;;
    *) echo "Unknown option: $1"; exit 1 ;;
  esac
  shift
done

command -v gh >/dev/null 2>&1 || { echo "Error: GitHub CLI (gh) is not installed."; exit 1; }
gh auth status >/dev/null 2>&1 || { echo "Error: not authenticated. Run: gh auth login"; exit 1; }
gh api "repos/$REPO/branches/$BRANCH" >/dev/null 2>&1 || {
  echo "Error: branch '$BRANCH' not found in $REPO. Push an initial commit first."
  exit 1
}

echo "==> Configuring $REPO"

# ---------- Labels ----------
echo "-> Labels"
label() {
  gh label create "$1" --repo "$REPO" --color "$2" --description "$3" --force >/dev/null
  echo "   ok: $1"
}
label "feature"        "a2eeef" "New feature"
label "bug"            "d73a4a" "Something is not working"
label "refactor"       "cfd3d7" "Code improvement without changing behavior"
label "docs"           "0075ca" "Documentation"
label "tests"          "bfd4f2" "Tests"
label "needs-approval" "fbca04" "Proposed issue waiting for PM approval"

# ---------- Merge settings ----------
echo "-> Merge settings"
if $SQUASH_ONLY; then MERGE_COMMIT=false; else MERGE_COMMIT=true; fi
gh api -X PATCH "repos/$REPO" \
  -F delete_branch_on_merge=true \
  -F allow_squash_merge=true \
  -F allow_merge_commit="$MERGE_COMMIT" \
  -F allow_rebase_merge=false >/dev/null
echo "   ok: delete branch on merge, squash=true, merge commit=$MERGE_COMMIT, rebase=false"

# ---------- Branch protection ----------
echo "-> Branch protection on '$BRANCH'"
gh api -X PUT "repos/$REPO/branches/$BRANCH/protection" --input - >/dev/null <<JSON
{
  "required_status_checks": { "strict": true, "contexts": [] },
  "enforce_admins": true,
  "required_pull_request_reviews": {
    "dismiss_stale_reviews": true,
    "require_code_owner_reviews": false,
    "required_approving_review_count": $APPROVALS
  },
  "restrictions": null,
  "required_conversation_resolution": true,
  "allow_force_pushes": false,
  "allow_deletions": false
}
JSON
echo "   ok: PR required, $APPROVALS approval(s), stale approvals dismissed,"
echo "       conversations resolved, branch up to date, no force push, admins included"

echo "==> Done: https://github.com/$REPO/settings/branches"