# Flutter Base — Project Instructions

## Language
Reply in **Vietnamese**. Keep code, class names, file names, and technical terms in English.

## Architecture
```
lib/
  config/           — Flavor, env config
  core/
    base/
      di/           — injectable + get_it (DI)
      errors/       — Result<T>, Failure subtypes, ErrorHandler
      state/
        bloc/       — BaseState, BaseCubit, BaseBloc, AutoBloc, CubitPage
        riverpod/   — BaseAsyncNotifier (limited use)
    data/network/   — ApiResponse<T>, ApiPaginatedData<T>, DioClient
    common/         — extensions, constants, utils
  features/{name}/
    data/
      models/       — @freezed + json_serializable
      services/     — @RestApi (Retrofit)
      repositories/ — optional, only when Domain layer is needed
    presentation/
      cubit/        — extends BaseCubit<T>
      pages/        — extends CubitPage<C,D> or AutoCubitConsumer
  routes/           — go_router typed routes (code-gen)
```

## Key Rules

### Service return type
```dart
// CORRECT — interceptor handles exceptions → Failure
Future<ApiResponse<T>>
Future<ApiResponse<ApiPaginatedData<T>>>
Future<void>

// WRONG — never wrap with Result in service layer
Future<Result<ApiResponse<T>>>
```

### Cubit method selection
| Return type | Method |
|---|---|
| `Future<ApiResponse<R>>` | `runServiceUnwrap` ← most common |
| `Future<ApiResponse<ApiPaginatedData<R>>>` | `runServiceUnwrapPagination` |
| `Future<Result<R>>` | `run` |
| `Future<R>` (raw) | `runService` |
| `Future<Result<T>>` (chained) | `runChain` |

### State
- Always init with `const BaseState.initial()`
- Refresh: `loadingState: BaseState.loading(previousData: state.data)`
- Always set `cancelPrevious: true` on load/refresh
- Save `_lastParams` so refresh reuses same filters

### DI annotations
- `@injectable` → Cubit/Bloc (new instance each time)
- `@LazySingleton()` → Service, Repository, stateful singletons
- `@Singleton()` → eager init at boot

### After any code-gen change
Run task: **⚡ Build Runner: Build**

### Theme & color usage
- **Theme-aware color** (đổi theo light/dark/blue/pink/green): dùng `context.colors.brand.primary`, `context.colors.bg.page`, `context.colors.text.title`, … Nguồn: [color_config.json](lib/design/theme/colors/color_config.json) → gen ra [color_tokens.dart](lib/gen/theme/color_tokens.dart) + [color_palettes.dart](lib/gen/theme/color_palettes.dart).
- **Static color** (không đổi theo theme): dùng `AppColors.white`, `AppColors.facebook`, `AppColors.grey`. Section "CORE" ở đầu [app_colors.dart](lib/design/theme/styles/app_colors.dart).
- **`AppColors.textPrimary` / `AppColors.primaryLightBrand` / `AppColors.mutedLight`...**: **LEGACY** — đã `@Deprecated`. Code mới dùng token (`context.colors.X.Y`); code cũ migrate dần.
- Thêm theme/token mới: edit JSON → `make theme-gen` (hoặc `make theme-sync` để fill missing). Tool chỉ chấp nhận hex `0xAARRGGBB`, không cho `Colors.xxx` reference nữa.

### Enum naming convention
- **Enum mới**: dùng `lowerCamelCase` + `@JsonValue('UPPERCASE')` để map backend value (xem [auth_enums.dart](lib/features/auth/data/models/auth_enums.dart) làm tham chiếu).
- **Enum cũ UPPERCASE** (`BookingStatus.PENDING`, `VenueStatus.APPROVED`...): cố ý mirror tên enum Postgres ở backend → giữ nguyên, file đã có `// ignore_for_file: constant_identifier_names` ở đầu kèm lý do. Đừng đổi vì sẽ break ~300+ references và cần map `apiValue` thủ công cho mỗi enum.
- **Khi thêm value mới vào enum cũ**: viết UPPERCASE để nhất quán với các value sẵn có trong file đó.

## Skills
Use these for step-by-step workflows:
- `.claude/skills/commands/` — toàn bộ Makefile targets + VSCode Tasks + Dart tools
- `.claude/skills/app-config/` — FlavorConfig, AppInitializer, AppStartup, Observers, SystemUI
- `.claude/skills/new-feature/` — scaffold a full feature
- `.claude/skills/new-cubit/` — write a cubit from scratch
- `.claude/skills/new-route/` — add a typed go_router route
- `.claude/skills/code-review/` — review checklist for this codebase
- `.claude/skills/core-architecture/` — Extensions, Utils, Mixins, Network, Cache, Services, Base classes
- `.claude/skills/design-system/` — AppColors, AppDimensions, AppTextStyles, AppTheme, ThemeCubit, LocaleCubit
- `.claude/skills/shared/` — Shared widgets (AppButton/TextField/Dialog/...), Base models, CommonParam
- `.claude/skills/modules/` — AdManager, AnalyticsService, IapService (RevenueCat)
- `.claude/skills/app-entry/` — app.dart, main_common, entry points, error zones, AppRouter
- `.claude/skills/api-conventions/` — Nguyên tắc Request/Response class, không dùng Map<String, dynamic>
