# 🎯 VSCode Tasks & Keybindings - FVM Edition

Tất cả tasks đã được cập nhật để sử dụng **FVM (Flutter Version Management)**.

---

## 📋 **Danh sách Shortcuts**

### 🚀 **Main Actions (Thường dùng nhất)**

| Shortcut | Task | Mô tả |
|----------|------|-------|
| `Ctrl+Shift+B` | 🚀 Build APK (Universal) | Build APK với environment selector |
| `Ctrl+Shift+R` | ⚡ Build Runner (One-time) | Chạy build_runner một lần |
| `Ctrl+Shift+W` | 👁️ Build Runner (Watch) | Chạy build_runner ở chế độ watch |
| `Ctrl+Shift+C` | 🧹 Clean & Get | Clean và pub get |
| `Ctrl+Shift+G` | 🧹 Clean & Gen All | Clean + Pub Get + Gen l10n + Build Runner |

---

### 🏗️ **Quick Builds - APK**

| Shortcut | Task | Mô tả |
|----------|------|-------|
| `Ctrl+Shift+1` | 📦 Build APK (Dev) | Build APK Dev |
| `Ctrl+Shift+2` | 📦 Build APK (Stg) | Build APK Staging |
| `Ctrl+Shift+3` | 📦 Build APK (Prod) | Build APK Production (obfuscated) |

---

### 🏬 **Quick Builds - AAB (App Bundle)**

| Shortcut | Task | Mô tả |
|----------|------|-------|
| `Ctrl+Shift+A` | 🏬 Build AAB (Universal) | Build AAB với environment selector |
| `Ctrl+Alt+1` | 🏬 Build AAB (Dev) | Build AAB Dev |
| `Ctrl+Alt+2` | 🏬 Build AAB (Stg) | Build AAB Staging |
| `Ctrl+Alt+3` | 🏬 Build AAB (Prod) | Build AAB Production (obfuscated) |

---

### 🍎 **iOS Builds**

| Shortcut | Task | Mô tả |
|----------|------|-------|
| `Ctrl+Shift+I` | 🍎 Build iOS (Universal) | Build iOS với environment selector |
| `Ctrl+Shift+P` | 📦 Build IPA (Universal) | Build IPA với environment selector |

---

### 📦 **Pub Commands**

| Shortcut | Task | Mô tả |
|----------|------|-------|
| `Ctrl+Alt+G` | 📦 Pub Get | Flutter pub get |
| `Ctrl+Alt+U` | ⬆️ Pub Upgrade | Flutter pub upgrade |
| `Ctrl+Alt+O` | 🔍 Pub Outdated | Xem packages outdated |
| `Ctrl+Alt+Shift+U` | ⬆️ Pub Upgrade (Major) | Upgrade major versions |

---

### 🎯 **Code Generation**

| Shortcut | Task | Mô tả |
|----------|------|-------|
| `Ctrl+Alt+B` | 🎯 Build Runner (Current File) | Build runner cho file hiện tại |
| `Ctrl+Alt+L` | 🌐 Generate l10n | Generate localization |
| `Ctrl+Alt+S` | 🌐 Sync l10n (arb) | Sync ARB files |

---

### 🔧 **Flutter Commands**

| Shortcut | Task | Mô tả |
|----------|------|-------|
| `Ctrl+Alt+D` | 🔧 Flutter Doctor | Flutter doctor -v |
| `Ctrl+Alt+A` | 📊 Flutter Analyze | Flutter analyze |
| `Ctrl+Alt+F` | ✨ Dart Format | Format toàn bộ code |
| `Ctrl+Alt+T` | 🧪 Flutter Test | Chạy tests |
| `Ctrl+Alt+Shift+T` | 🧪 Flutter Test (Coverage) | Chạy tests với coverage |

---

### 🐛 **Debug Runs**

| Shortcut | Task | Mô tả |
|----------|------|-------|
| `Ctrl+Alt+Shift+1` | 🐛 Run Debug (Dev) | Run Dev với hot reload |
| `Ctrl+Alt+Shift+2` | 🐛 Run Debug (Stg) | Run Staging với hot reload |
| `Ctrl+Alt+Shift+3` | 🐛 Run Debug (Prod) | Run Production với hot reload |

---

### 🔧 **FVM Management**

| Shortcut | Task | Mô tả |
|----------|------|-------|
| `Ctrl+Alt+Shift+L` | 📋 FVM List | Liệt kê Flutter versions đã cài |
| `Ctrl+Alt+Shift+R` | 🌐 FVM Releases | Liệt kê tất cả Flutter releases |
| `Ctrl+Alt+Shift+G` | 🔍 FVM Global | Xem Flutter version global |
| `Ctrl+Alt+Shift+D` | 🔧 FVM Doctor | FVM Flutter doctor |

---

### 🧱 **Mason & Flavorizr**

| Shortcut | Task | Mô tả |
|----------|------|-------|
| `Ctrl+Alt+M` | 🧱 Mason: Generate Feature | Generate feature với Mason |
| `Ctrl+Alt+Shift+F` | 🍭 Flutter Flavorizr | Chạy Flavorizr |

---

## 🎮 **Default VSCode Debug Shortcuts**

| Shortcut | Action |
|----------|--------|
| `F5` | Start Debugging |
| `Ctrl+Shift+F5` | Hot Restart |
| `Shift+F5` | Stop Debugging |
| `Ctrl+F5` | Run Without Debugging |
| `Ctrl+Shift+D` | Show Debug Panel |

---

## 📝 **Lưu ý**

1. **Tất cả tasks đều sử dụng FVM** - Đảm bảo bạn đã cài FVM và đã chạy `fvm use <version>`
2. **Environment selector** - Một số tasks sẽ hiện popup để chọn environment (dev/stg/prod)
3. **Build Runner Watch** - Chạy background, nhớ stop khi không dùng
4. **Obfuscation** - Chỉ áp dụng cho Production builds

---

## 🚀 **Quick Start**

```bash
# Cài FVM (nếu chưa có)
dart pub global activate fvm

# Set Flutter version cho project
fvm use 3.24.5

# Verify
fvm flutter --version

# Chạy task đầu tiên
Ctrl+Shift+G  # Clean & Gen All
```

---

## 📚 **Tài liệu tham khảo**

- [FVM Documentation](https://fvm.app/)
- [VSCode Tasks](https://code.visualstudio.com/docs/editor/tasks)
- [VSCode Keybindings](https://code.visualstudio.com/docs/getstarted/keybindings)
