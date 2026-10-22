# Project Workflow Handbook (GitHub)

## Objective

This handbook defines the **official workflow** that all project members must follow when working on GitHub. It ensures:

* Organized work and traceability
* Code quality
* Efficient and transparent collaboration
* Clear history for future reference

The official flow is:

> **Issue → Branch → Commit → Pull Request (Code Review) → Merge**

**GitHub Projects** is used to manage all work (backlog, in progress, in review, done), ensuring full visibility of progress.

---

## Workflow Overview

1. **Issue** – defines what needs to be done
2. **Branch** – isolated environment to work on the Issue
3. **Commit** – smallest unit of code change
4. **Pull Request (PR)** – proposal to integrate changes
5. **Code Review** – manual review for quality, patterns and compliance
6. **Merge** – final integration into `main`

---

## Issues

An **Issue** is a task or problem to be solved: a bug, a new feature, a refactor, documentation or tests.

### Responsibilities

* Issues are created by the **Project Manager (PM)** of each project
* Any member may propose an Issue for a specific case using the **Proposal** template; it **must be approved by the PM** before any work starts
* Assign labels (`bug`, `feature`, `refactor`, etc.)
* Define acceptance criteria or expected results
* Associate with milestones or epics when applicable

### Best Practices

* An Issue has **a single objective**
* Avoid very large Issues: split into subtasks if needed
* Reference relevant resources (documentation, designs, etc.)

---

## Branches

A **Branch** is an isolated copy of the code, allowing work on the Issue without affecting `main`.

### Rules

* Each Issue has its own Branch
* Branches are created from `main` (the only long-lived branch)
* Naming pattern:

```
<type>/<issue-id>-<short-description>
```

Examples:

* `feature/23-login-with-jwt`
* `bug/45-fix-null-pointer`
* `refactor/12-service-cleanup`

### Responsibilities

* Keep the branch up to date with `main` to avoid conflicts
* Never commit directly to `main`

---

## Commits

A **commit** is a logical and cohesive unit of code change.

### Best Practices

* Small and frequent commits
* Each commit represents **a specific change**
* Code should compile and pass tests (if any)
* Avoid generic or overly large commits

### Commit Messages (Simplified Conventional Commits)

```
<type>: short description
```

Types: `feat`, `fix`, `refactor`, `docs`, `test`, `chore`

Examples:

* `feat: add JWT authentication`
* `fix: correct user save error`

Reference the Issue number when possible.

---

## Pull Request (PR)

A **PR** is the proposal to merge the Issue branch into `main`.

### When to Create a PR

* When the Issue is complete
* Or when early feedback is needed (open it as a **Draft PR**)

### Mandatory Rules

* A PR is **always linked to an Issue** (`Closes #n`)
* A PR targets `main`
* A PR without review **cannot be merged**

### Author Responsibilities

* Fill in the PR template completely
* Explain the changes clearly
* Keep commits organized
* Respond to Code Review comments

---

## Code Review

**Code Review** is the manual review of code by another team member before merging. There are no automated gates: the reviewer is responsible for verifying quality and patterns.

### Objective

* Ensure code quality and consistency with project patterns
* Detect bugs and design issues
* Improve readability and maintainability
* Share knowledge among team members

### Rules

* At least **one approval** is required
* The reviewer goes through the **reviewer checklist** in the PR template
* Comments are clear and respectful
* The PR author reviews and responds to every comment
* Suggestions for improvement are welcome

---

## Merge

**Merge** is the final integration of approved changes into `main`.

### Rules

* Merge only after approval **and** after the reviewer checklist is complete
* Resolve conflicts before merging
* Recommended strategies:
  * **Squash and merge:** clean history
  * **Merge commit:** preserve detailed history
* Never merge without review

### Post-Merge

* Close the Issue (automatic with `Closes #n`)
* Move the card in the Project to **Done**
* Delete the Issue branch

---

## Branch Protection

`main` is protected in every repository:

* Pull request required before merging
* At least 1 approving review
* Stale approvals dismissed when new commits are pushed
* All conversations resolved before merging
* Branch must be up to date with `main`
* No direct pushes and no force pushes
* Rules apply to administrators too

---

## Golden Rules

* No Issue → no code
* One Issue → one Branch
* Clear, small, frequent commits
* PR required before merge
* Code Review mandatory
* Never commit directly to `main`
* Post-merge: close Issue, move card, delete branch

---

## Final Considerations

This workflow is **mandatory for all project members**. Follow the flow, document your changes, and keep the repository healthy.
