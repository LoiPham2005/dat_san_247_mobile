# Project Setup

## Prerequisites
- Install FVM: https://fvm.app/docs/getting_started/installation

## Setup
```bash
# Clone project
git clone <repo-url>
cd project-name

# Install Flutter version (FVM tự động đọc từ .fvm/fvm_config.json)
fvm install

# Get dependencies
fvm flutter pub get

# Run build_runner
fvm flutter pub run build_runner build --delete-conflicting-outputs

# Run app
fvm flutter run
```

## VS Code
- Open project → VS Code tự động detect Flutter SDK từ `.vscode/settings.json`
- Reload window nếu cần: `Ctrl + Shift + P` → `Developer: Reload Window`