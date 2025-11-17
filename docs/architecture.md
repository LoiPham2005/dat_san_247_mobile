# 🏗️ Project Architecture (Feature-First & Clean Architecture)

Dự án này tuân theo **Clean Architecture** kết hợp với **Feature-First Structure** để đảm bảo code dễ mở rộng, maintain, test và scale cho team lớn.

---

## 📁 Directory Structure

```
lib/
├── core/                   # Core/shared utilities, services, config, DI, theme, network, etc.
│   ├── config/             # App config, environment, startup, observer
│   ├── constants/          # API, app, asset constants
│   ├── di/                 # Dependency injection (get_it, injectable)
│   ├── errors/             # Error/result/failure classes
│   ├── extensions/         # Dart/Flutter extensions
│   ├── l10n/               # Localization (arb, generated, service)
│   ├── network/            # Dio client, interceptors, API client
│   ├── routes/             # App routes
│   ├── services/           # Global services (auth, file, notification, etc.)
│   ├── state_management/   # Base classes for BLoC, Cubit, GetX, Riverpod, Provider
│   ├── storage/            # SharedPreferences, SecureStorage, keys
│   ├── theme/              # App theme, colors, text styles
│   └── utils/              # Logger, validators, device info, etc.
│
├── features/               # Feature modules (auth, home, category, ...)
│   └── <feature>/          # Mỗi tính năng là 1 folder riêng
│       ├── data/           # Data Layer (models, datasources, repositories impl)
│       ├── domain/         # Domain Layer (entities, repositories abstract, usecases)
│       └── presentation/   # Presentation Layer (bloc/cubit/getx, pages, widgets, providers, riverpod)
│
└── shared/                 # Shared UI components, models, widgets
    ├── models/
    └── widgets/
```

---

## 🧩 Layer Responsibilities

### 1. Presentation Layer (`features/*/presentation`)
- **Nhiệm vụ:** UI, nhận input, điều hướng, trigger UseCase.
- **Thành phần:** Pages, Widgets, State Management (BLoC/Cubit/GetX/Provider/Riverpod).
- **Quy tắc:** Chỉ gọi UseCase từ Domain, KHÔNG gọi trực tiếp Data Layer.

### 2. Domain Layer (`features/*/domain`)
- **Nhiệm vụ:** Business logic thuần, không phụ thuộc framework.
- **Thành phần:**
  - **Entities:** Đối tượng nghiệp vụ (User, Product, ...)
  - **Repositories (abstract):** Interface định nghĩa contract data
  - **UseCases:** Từng hành động nghiệp vụ (LoginUseCase, GetProductUseCase, ...)
- **Quy tắc:** Không import bất kỳ code nào từ Data/Presentation.

### 3. Data Layer (`features/*/data`)
- **Nhiệm vụ:** Cung cấp data cho Domain Layer.
- **Thành phần:**
  - **Models:** DTO, mapping JSON ↔ Entity
  - **Repositories (impl):** Triển khai interface từ Domain, quyết định lấy data từ đâu (API/local)
  - **Datasources:** Giao tiếp API (RemoteDataSource) hoặc local (LocalDataSource)
- **Quy tắc:** Không import Presentation, chỉ phụ thuộc Domain.

---

## 🔄 Data Flow Example

1. **UI (Widget/Page)** → trigger event vào **BLoC/Cubit/Controller/Provider**
2. **BLoC/Cubit/Provider** → gọi `execute()` trên **UseCase**
3. **UseCase** → gọi method trên **Repository (abstract)**
4. **RepositoryImpl (Data Layer)** → kiểm tra network, gọi **RemoteDataSource** hoặc **LocalDataSource**
5. **RemoteDataSource** → gọi API qua Dio, nhận JSON
6. **Model** → map JSON thành Entity
7. **RepositoryImpl** trả về Entity cho UseCase
8. **UseCase** trả về cho BLoC/Cubit/Provider
9. **BLoC/Cubit/Provider** emit state mới cho UI

---

## 💉 Dependency Injection (DI)

- **Công cụ:** `get_it` + `injectable`
- **Cách dùng:**
  - Annotate class với `@injectable`, `@lazySingleton`, `@factory`
  - External dependency (SharedPreferences, Connectivity, ...) cung cấp qua `@module` trong `core/di/injection.dart`
  - Chạy `flutter pub run build_runner build` để generate `injection.config.dart`
- **Lợi ích:** Giảm coupling, dễ test, dễ mock, dễ maintain.

---

## 🔄 State Management

- **Hỗ trợ đa dạng:** BLoC, Cubit, GetX, Provider, Riverpod
- **Base class:** Đặt trong `core/state_management/`
- **Tùy chọn:** Mỗi feature có thể chọn state management phù hợp (hoặc mix nhiều loại nếu cần)
- **Ví dụ:**  
  - `features/auth/presentation/bloc/auth_bloc.dart`
  - `features/auth/presentation/cubit/auth_cubit.dart`
  - `features/auth/presentation/getx/auth_getx.dart`
  - `features/auth/presentation/providers/auth_provider.dart`
  - `features/auth/presentation/riverpod/auth_riverpod.dart`

---

## 🧪 Testing

- **Unit Test:** Test UseCase, Repository, Model mapping
- **Widget Test:** Test UI logic, interaction
- **Integration Test:** Test flow end-to-end

---

## 🌍 Environment & Config

- **Config môi trường:** Sử dụng `--dart-define=ENV=dev|staging|prod` và/hoặc Flavors
- **File:** `core/config/environment_config.dart`
- **Cách lấy ENV:**  
  ```dart
  static const String _envString = String.fromEnvironment('ENV', defaultValue: 'dev');
  ```
- **Build command ví dụ:**
  ```sh
  flutter run --flavor development -t lib/main.dart --dart-define=ENV=dev
  ```

---

## 📦 Shared & Core

- **core/**: Chứa các thành phần dùng chung toàn app (network, storage, theme, l10n, ...)
- **shared/**: Chứa các widget, model, helper dùng lại giữa các feature

---

## 📝 Best Practices

- **Không import ngược layer:** Presentation → Domain → Data (1 chiều)
- **Không dùng logic nghiệp vụ trong UI**
- **Mỗi feature độc lập, dễ tách module**
- **Luôn test UseCase, Repository**
- **Tách biệt config môi trường, không hardcode**

---

## 📚 Tham khảo thêm

- [docs/architecture.md](architecture.md)
- [docs/build_flavor.md](build_flavor.md)
- [docs/ENVIRONMENT_SETUP.md](ENVIRONMENT_SETUP.md)
- [docs/rename_project.md](rename_project.md)

---

**Template này giúp team scale nhanh, onboard dễ, maintain lâu dài và test hiệu quả!**