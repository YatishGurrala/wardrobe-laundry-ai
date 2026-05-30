# wardrobe_laundry_ai

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Branch Strategy

- `prod`: production branch
- `main`: preview/staging branch
- `dev`: development branch

## Mandatory Dry Run Before `prod` Merge

Before merging any branch into `prod`, run:

```bash
./scripts/prod_merge_dry_run.sh <source-branch>
```

Example:

```bash
./scripts/prod_merge_dry_run.sh main
```

If the dry run reports conflicts, resolve them before opening or merging a PR into `prod`.

Pull requests targeting `prod` are also checked automatically by GitHub Actions via `.github/workflows/prod-dry-run.yml`.
