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

## Buildstack Backend Setup

The app can run with either mock data (default) or your Buildstack backend.

The backend integration is enabled when these `--dart-define` values are provided:

- `BUILDSTACK_PROJECT_KEY`
- `BUILDSTACK_API_KEY`
- `BUILDSTACK_BASE_URL` (optional, defaults to `https://stack.builddeck.io`)
- `BUILDSTACK_OWNER_ID` (optional, defaults to `wardrobe-local-owner`)
- `CURRENT_USER_EMAIL` (optional, must be `yatishkotlin@gmail.com` to view debug panel)
- `APP_RELEASE_CHANNEL` (optional, defaults to `prod`; set to `main`, `preview`, or `staging` for admin panel)

Example:

```bash
flutter run \
	--dart-define=BUILDSTACK_PROJECT_KEY=your_project_key \
	--dart-define=BUILDSTACK_API_KEY=your_api_key \
	--dart-define=BUILDSTACK_BASE_URL=https://stack.builddeck.io \
	--dart-define=BUILDSTACK_OWNER_ID=your_owner_id \
	--dart-define=CURRENT_USER_EMAIL=yatishkotlin@gmail.com \
	--dart-define=APP_RELEASE_CHANNEL=main
```

If `BUILDSTACK_PROJECT_KEY` or `BUILDSTACK_API_KEY` are missing, the app automatically falls back to mock data.

Admin Debug Panel visibility:

- Works only in debug builds.
- Works only when `APP_RELEASE_CHANNEL` is `main`, `preview`, or `staging`.
- Requires a long-press on the profile header.
- Opens only when `CURRENT_USER_EMAIL` is `yatishkotlin@gmail.com`.

Security note: do not commit API keys to source control.
