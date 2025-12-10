# FVM Setup Instructions

This project uses **FVM (Flutter Version Manager)** to ensure all team members use the same Flutter version.

## First Time Setup

### 1. Install FVM
```bash
dart pub global activate fvm
```

### 2. Install the project's Flutter version
```bash
fvm install
```

### 3. Configure Git hooks (important!)
```bash
git config core.hooksPath .githooks
```

This ensures you can't accidentally commit using the wrong Flutter version.

## Daily Usage

**Always use `fvm` prefix for Flutter commands:**

```bash
# ❌ Don't use:
flutter run
flutter pub get

# ✅ Use instead:
fvm flutter run
fvm flutter pub get
fvm dart pub get
```

## VS Code Setup (Optional but Recommended)

The project includes `.vscode/settings.json` that automatically uses the FVM Flutter SDK. Just reload VS Code after running `fvm install`.

## Troubleshooting

**If you see "wrong Flutter version" errors:**
1. Run `fvm install` again
2. Restart your terminal/IDE
3. Make sure you're using `fvm flutter` not just `flutter`

**Check which Flutter you're using:**
```bash
fvm flutter --version
```

Should show the version specified in `.fvmrc`.
