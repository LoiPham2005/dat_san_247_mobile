# 🚀 Ultimate dat_san_247_mobile

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-3.35.7+-02569B?logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-3.8.1+-0175C2?logo=dart&logoColor=white)
![Architecture](https://img.shields.io/badge/Clean-Architecture-green)
![State](https://img.shields.io/badge/State-BLoC%20%7C%20Riverpod-purple)
![License](https://img.shields.io/badge/License-MIT-blue.svg)

**A production-ready, feature-rich Flutter template optimized for scalability, performance, and developer experience.**

[Getting Started](#-getting-started) • [Documentation](#-documentation) • [Features](#-features) • [Structure](#-project-structure)

</div>

---

## 🌟 Features

This template provides a robust foundation for building large-scale Flutter applications.

- **🏗️ Clean Architecture**: Strict separation of concerns (Domain, Data, Presentation) for testability and scalability.
- **💉 Dependency Injection**: Powered by `get_it` and `injectable` for loose coupling.
- **🌐 Environment Management**: Native Flavors (Dev, Stg, Prod) combined with `envied` for secure config.
- **🧱 Mason Templates**: Pre-built bricks to generate features, blocs, and logic in seconds.
- **📺 Advanced Ads Module**: Complete generic implementation for AdMob (Banner, Interstitial, Native, Reward, AppOpen).
- **🔄 State Management**: Pre-configured support for BLoC (default), Riverpod, or GetX.
- **🔌 Robust Networking**: Dio client with smart interceptors, logging, and error handling.
- **🌍 Localization (i18n)**: Native `.arb` file support with type-safe generation.
- **🎨 Modern UI/UX**: `ScreenUtil` for responsiveness, centralized Theme system, and Asset management.
- **🤖 Developer Experience**: Integrated FVM, VS Code Tasks, and Launch Configurations.

---

## 🛠️ Tech Stack

| Category | Technology | Description |
|----------|------------|-------------|
| **Core** | Flutter, Dart | Latest stable versions |
| **Architecture** | Clean Architecture | Domain-driven design |
| **DI** | `get_it`, `injectable` | Service locator & generation |
| **State** | `flutter_bloc` | Predictable state management |
| **Navigation** | `go_router` | Declarative routing with deep links |
| **Network** | `dio`, `retrofit` | Http client & API generation |
| **Storage** | `hive`, `secure_storage` | Local DB & Encrypted storage |
| **Ads** | `google_mobile_ads` | Monetization wrapper |
| **Utils** | `logger`, `freezed` | Logging & Immutable classes |

---

## 🚀 Getting Started

### Prerequisites
- [FVM](https://fvm.app/) (Flutter Version Manager)
- [Mason](https://pub.dev/packages/mason_cli) (Template Generator)

### Installation

1. **Clone & Install Dependencies**
   ```bash
   git clone https://github.com/your-username/flutter_base_template.git
   cd flutter_base_template
   fvm install
   fvm flutter pub get
   ```

2. **Generate Code**
   ```bash
   fvm dart run build_runner build -d
   ```

3. **Run the App**
   ```bash
   # Development
   fvm flutter run --flavor dev -t lib/main_dev.dart
   ```

> **Tip**: If using VS Code, simply press `F5` to start debugging. We have pre-configured launch.json!

---

## 📂 Project Structure

```
lib/
├── core/                  # Core modules (Network, Storage, Ads, Theme, Utils)
│   ├── ads/               # 📺 Complete Ads module (Config, Service, Widgets)
│   ├── config/            # App Config & Environments
│   ├── di/                # Dependency Injection Setup
│   └── ...
├── features/              # Feature-based organization
│   ├── auth/              # Example Feature
│   │   ├── data/          # Repositories & DTOs
│   │   ├── domain/        # Entities & UseCases
│   │   └── presentation/  # BLoC, Pages, Widgets
│   └── home/
├── shared/                # Shared Widgets & Constants
└── main_dev.dart          # Entry points
```

---

## 📚 Documentation

Detailed documentation is available in the `docs/` directory:

- [**🛠️ Setup Guide**](docs/SETUP.md) - Environment setup, Keystores, and Tools.
- [**🏗️ Architecture**](docs/ARCHITECTURE.md) - Deep dive into Clean Architecture & DI.
- [**💻 Development Workflow**](docs/DEVELOPMENT.md) - Commands, Mason, L10n, Testing.
- [**📺 Ads Integration**](docs/ads.md) - How to configure and use the Ads module.
- [**🧩 Ecosystem**](docs/ECOSYSTEM.md) - API, Storage, Theme, Navigation details.

---

## 🤖 Automation with Makefile

Để đơn giản hóa việc chạy các lệnh dài, dự án đã cấu hình sẵn **Makefile**. Bạn có thể dùng `make <command>` để thực thi nhanh:

| Lệnh | Mô tả |
|------|-------|
| `make get` | Cài đặt dependencies (pub get) |
| `make gen` | Chạy build_runner (tạo code tự động) |
| `make l10n` | Cập nhật đa ngôn ngữ (l10n) |
| `make full-gen` | Reset sạch dự án và build lại toàn bộ |
| `make run-dev` | Chạy app ở chế độ DEV (Debug) |
| `make apk-prod` | Build APK môi trường Production |
| `make icons` | Tạo lại App Icon từ cấu hình |

---

## 📂 Common Commands

| Action | Command |
|--------|---------|
| **Run Dev** | `fvm flutter run --flavor dev -t lib/main_dev.dart` |
| **Build APK** | `fvm flutter build apk --flavor prod -t lib/main_prod.dart` |
| **Build Runner** | `fvm dart run build_runner build -d` |
| **Localization** | `fvm flutter gen-l10n` |
| **Analyze** | `fvm flutter analyze` |

---

<div align="center">

**Made with ❤️ by [Your Name]**

⭐ Star this repo if you find it useful!

</div>
