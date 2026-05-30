#!/usr/bin/env bash
set -euo pipefail

# Usage: ./scripts/prod_merge_dry_run.sh <source-branch>
# Example: ./scripts/prod_merge_dry_run.sh main

SOURCE_BRANCH="${1:-}"

if [[ -z "$SOURCE_BRANCH" ]]; then
  echo "Usage: $0 <source-branch>"
  exit 1
fi

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "Error: not inside a git repository"
  exit 1
fi

cleanup() {
  if [[ -n "${WORKTREE_PATH:-}" ]]; then
    git worktree remove --force "$WORKTREE_PATH" >/dev/null 2>&1 || true
  fi
}
trap cleanup EXIT

echo "Fetching latest branches from origin..."
git fetch origin

if ! git show-ref --verify --quiet "refs/remotes/origin/$SOURCE_BRANCH"; then
  echo "Error: origin/$SOURCE_BRANCH does not exist"
  exit 1
fi

WORKTREE_PATH="$(mktemp -d -t prod-merge-dry-run-XXXXXX)"
echo "Creating temporary worktree at $WORKTREE_PATH"
git worktree add -f "$WORKTREE_PATH" origin/prod >/dev/null

pushd "$WORKTREE_PATH" >/dev/null

echo "Starting dry-run merge: $SOURCE_BRANCH -> prod"
if git merge --no-commit --no-ff "origin/$SOURCE_BRANCH"; then
  echo "Dry run successful: no merge conflicts detected."
  echo "Merge was not committed."
else
  echo "Dry run failed: merge conflicts detected."
  exit 1
fi

git merge --abort >/dev/null 2>&1 || true
popd >/dev/null
