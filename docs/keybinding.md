# ⌨️ Keyboard Shortcuts Cheatsheet

Tham khảo nhanh các phím tắt để build, run, codegen dự án (chỉ dùng Flavors + Entrypoint).

---

## 🚀 MAIN ACTIONS (Most Used)

| Phím tắt      | Chức năng | VS Code / IDE |
|---------------|----------|---------------|
| `Ctrl+Shift+B` | 🚀 Universal Build (select env + target) | VS Code Tasks |
| `Ctrl+Shift+R` | ⚡ Build Runner (one-time) | VS Code Tasks |
| `Ctrl+Shift+W` | 👁️ Build Runner (watch mode) | VS Code Tasks |
| `Ctrl+Shift+C` | 🧹 Clean & Get | VS Code Tasks |

---

## 🏗️ QUICK BUILDS (Fast)

| Phím tắt      | Chức năng | VS Code Tasks |
|---------------|----------|---------------|
| `Ctrl+Shift+D` | 📦 Build APK (Dev) | `📦 Build APK (Dev)` |
| `Ctrl+Shift+S` | 📦 Build APK (Stg) | `📦 Build APK (Stg)` |
| `Ctrl+Shift+P` | 📦 Build APK (Prod) | `📦 Build APK (Prod)` |
| `Ctrl+Shift+A` | 🏬 Build AAB (Prod) | `🏬 Build AAB (Prod)` |

---

## 📦 PUB COMMANDS (Dependencies)

| Phím tắt      | Chức năng | VS Code Tasks |
|---------------|----------|---------------|
| `Ctrl+Alt+G`  | 📦 Pub Get | `📦 Pub Get` |
| `Ctrl+Alt+U`  | ⬆️ Pub Upgrade | `⬆️ Pub Upgrade` |
| `Ctrl+Alt+O`  | 🔍 Pub Outdated | `🔍 Pub Outdated` |

---

## 🎯 CODE GENERATION (Codegen)

| Phím tắt      | Chức năng | VS Code Tasks |
|---------------|----------|---------------|
| `Ctrl+Alt+B`  | 🎯 Build Runner (current file) | `🎯 Build Runner (Current File)` |
| `Ctrl+Alt+L`  | 🌐 Generate l10n (i18n) | `🌐 Generate l10n` |

---

## 🐛 DEBUG (Built-in Flutter)

| Phím tắt       | Chức năng | Ghi chú |
|----------------|----------|---------|
| `F5`           | ▶️ Start Debug | Chạy debug |
| `Ctrl+Shift+F5`| 🔄 Hot Restart | Restart app hoàn toàn |
| `Ctrl+F5`      | ▶️ Run Without Debug | Chạy release mode |
| `Shift+F5`     | ⏹️ Stop Debug | Dừng debug |

---

## 📋 VISUAL REFERENCE

```
┌─────────────────────────────────────────────────────────────────┐
│ ⌨️ FLUTTER DEVELOPMENT SHORTCUTS (Flavors Only)                 │
├─────────────────────────────────────────────────────────────────┤
│                                                                   │
│ 🚀 MAIN ACTIONS (Most Used)                                     │
│  ├─ Ctrl+Shift+B  → 🚀 Universal Build (select env/target)     │
│  ├─ Ctrl+Shift+R  → ⚡ Build Runner (one-time)                 │
│  ├─ Ctrl+Shift+W  → 👁️ Build Runner (watch)                   │
│  └─ Ctrl+Shift+C  → 🧹 Clean & Get                             │
│                                                                   │
│ 🏗️ QUICK BUILDS                                                 │
│  ├─ Ctrl+Shift+D  → 📦 Build APK (Dev)                         │
│  ├─ Ctrl+Shift+S  → 📦 Build APK (Stg)                         │
│  ├─ Ctrl+Shift+P  → 📦 Build APK (Prod)                        │
│  └─ Ctrl+Shift+A  → 🏬 Build AAB (Prod)                        │
│                                                                   │
│ 📦 PUB COMMANDS                                                  │
│  ├─ Ctrl+Alt+G   → 📦 Pub Get                                   │
│  ├─ Ctrl+Alt+U   → ⬆️ Pub Upgrade                               │
│  └─ Ctrl+Alt+O   → 🔍 Pub Outdated                              │
│                                                                   │
│ 🎯 CODE GENERATION                                               │
│  ├─ Ctrl+Alt+B   → 🎯 Build Runner (current file)              │
│  └─ Ctrl+Alt+L   → 🌐 Generate l10n                             │
│                                                                   │
│ 🐛 DEBUG (Built-in)                                             │
│  ├─ F5            → ▶️ Start Debug                              │
│  ├─ Ctrl+Shift+F5 → 🔄 Hot Restart                             │
│  ├─ Ctrl+F5       → ▶️ Run (No Debug)                          │
│  └─ Shift+F5      → ⏹️ Stop Debug                              │
│                                                                   │
└─────────────────────────────────────────────────────────────────┘
```

---

## 🔧 Cách Setup (VS Code)

### 1. Tasks đã được cấu hình trong `.vscode/tasks.json`

Xem file: [`.vscode/tasks.json`](.vscode/tasks.json)

### 2. Keybindings đã được cấu hình trong `.vscode/keybindings.json`

Xem file: [`.vscode/keybindings.json`](.vscode/keybindings.json)

### 3. Launch configs đã được cấu hình trong `.vscode/launch.json`

Xem file: [`.vscode/launch.json`](.vscode/launch.json)

---

## 📝 How to Run Tasks

### Via Keyboard Shortcut

```
Ctrl+Shift+B → 🚀 Universal Build → Chọn env (dev/stg/prod) → Chọn target (apk/appbundle/ios)
```

### Via Command Palette

```
Ctrl+Shift+P → Tasks: Run Task → Chọn task → Enter
```

### Via Terminal

```
Ctrl+` (backtick) → Chạy command thủ công
```

---

## 🎯 Typical Usage

### Development Workflow

```bash
# 1. Start build runner watch
Ctrl+Shift+W  # Build Runner (Watch)

# 2. In another terminal, run app
F5            # Start Debug (or chọn 🧑‍💻 Development từ launch config)

# 3. When you change .arb files
Ctrl+Alt+L    # Generate l10n

# 4. Before commit
Ctrl+Shift+R  # Build Runner (one-time, to finalize)
```

### Build for Release

```bash
# 1. Clean
Ctrl+Shift+C  # Clean & Get

# 2. Code gen
Ctrl+Shift+R  # Build Runner (one-time)

# 3. i18n
Ctrl+Alt+L    # Generate l10n

# 4. Build APK
Ctrl+Shift+D  # Build APK (Dev) - for testing
Ctrl+Shift+S  # Build APK (Stg) - for staging
Ctrl+Shift+P  # Build APK (Prod) - for production

# 5. Or build AAB (for Google Play)
Ctrl+Shift+A  # Build AAB (Prod)
```

---

## 🔗 Related Docs

- 📖 [build_flavor.md](build_flavor.md)
- 📖 [ENVIRONMENT_SETUP.md](ENVIRONMENT_SETUP.md)
- 🏗️ [architecture.md](architecture.md)
- ⚙️ [.vscode/tasks.json](.vscode/tasks.json)
- ⚙️ [.vscode/keybindings.json](.vscode/keybindings.json)
- ⚙️ [.vscode/launch.json](.vscode/launch.json)

---

## ⚡ Quick Tips

- 🎯 **Dùng Ctrl+Shift+B** cho universal build (tương tác chọn env & target)
- 🚀 **Dùng Ctrl+Shift+D/S/P** cho quick builds (không cần chọn lại)
- 👁️ **Luôn mở Build Runner (Watch)** khi dev (auto-generate on save)
- 🐛 **Nhấn F5** để debug, **Ctrl+F5** để run release
- 📝 **Ctrl+Alt+L** sau khi edit `.arb` files để update i18n

---
