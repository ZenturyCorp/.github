# .github

Base repository of the organization. It holds the **workflow**, the **issue and PR templates** and the **setup script** that every project follows.

It works in two ways:

1. **Organization defaults:** repositories without their own templates inherit the files at the root of this repository.
2. **Template repository:** new projects are created from it and start with the same scripts.

## Contents

```
.
├── README.md
├── CONTRIBUTING.md              # official workflow (Issue → Branch → Commit → PR → Review → Merge)
├── PULL_REQUEST_TEMPLATE.md     # PR template with author and reviewer checklists
├── ISSUE_TEMPLATE/
│   ├── config.yml               # blank issues disabled
│   ├── feature.md
│   ├── bug.md
│   ├── refactor.md
│   └── proposal.md              # for non-PM members; requires PM approval
└── scripts/
    └── setup-repo.sh            # labels, merge settings and branch protection
```

Issue templates, the PR template and `CONTRIBUTING.md` are inherited by every repository of the organization as defaults, so new projects don't need their own copies.

## Create a new project

```bash
gh repo create <org>/<project> --template <org>/.github --private --clone
cd <project>
# replace this README with the project's own, push the first commit to main, then:
./scripts/setup-repo.sh <org>/<project>
```

> A template copies files only. **Branch protection, labels and repository settings are not copied**, so run the setup script in every new repository.

## Setup script

```bash
./scripts/setup-repo.sh <owner/repo> [--squash-only] [--approvals N]
```

| Option | Effect |
|---|---|
| `--squash-only` | Disables merge commits (squash merge only) |
| `--approvals N` | Required approvals (default `1`; use `0` for solo repos) |

It applies:

**Labels:** `feature`, `bug`, `refactor`, `docs`, `tests`, `needs-approval`

**Merge settings:** branches deleted after merge, rebase merge disabled

**Protection on `main`:**
- Pull request required, no direct pushes
- At least 1 approving review
- Stale approvals dismissed on new commits
- All conversations resolved before merging
- Branch up to date with `main`
- No force pushes, no deletion
- Rules apply to administrators too

### Requirements
- [GitHub CLI](https://cli.github.com/) installed and authenticated (`gh auth login`) with admin rights on the repository
- `main` must exist (at least one commit pushed)
- Branch protection on **private** repositories requires a paid GitHub plan. On the free plan it only works on public repositories.

### Apply to every repository of the organization

```bash
gh repo list <org> --no-archived --json nameWithOwner -q '.[].nameWithOwner' \
  | grep -v '/\.github$' \
  | xargs -I{} ./scripts/setup-repo.sh {}
```

## One-time organization setup

1. Create the repository `.github` in the organization (**public**, so the defaults apply to every repo).
2. Enable **Settings → Template repository** on it.
3. Push the contents of this repository to `main`.
4. Apply the rules to this repo too: `./scripts/setup-repo.sh <org>/.github`

## Workflow

Read [CONTRIBUTING.md](CONTRIBUTING.md). It is mandatory for all members.