---
name: new-feature
description: Scaffold một feature Flutter hoàn chỉnh theo chuẩn project (Mason brick + cubit + route). Dùng khi user nói "tạo feature", "tạo màn hình", "thêm module" hoặc hỏi cách bắt đầu một feature mới.
argument-hint: [feature-name]
disable-model-invocation: false
allowed-tools: Bash Read Write Edit Glob Grep
---

# Tạo Feature Mới: $ARGUMENTS

Thực hiện tuần tự các bước sau.

## Bước 1 — Mason brick

```bash
mason make feature_rut_gon_gen --on-conflict overwrite
```

Nhập `name = $ARGUMENTS` khi được hỏi. Brick sinh 4 file:
```
lib/features/$ARGUMENTS/
  data/
    models/{name}_model.dart
    services/{name}_service.dart
  presentation/
    cubit/{name}_list_cubit.dart
    pages/{name}_list_screen.dart
```

## Bước 2 — Endpoint

Mở `lib/core/common/constants/api_endpoints.dart`, thêm:
```dart
static const String $ARGUMENTS = '/api/$ARGUMENTS';
```

Cập nhật `{name}_service.dart` dùng constant thay vì hardcode string.

## Bước 3 — Model fields

Thêm fields thực tế vào `{name}_model.dart`:
```dart
@freezed
abstract class NameModel with _$NameModel {
  const factory NameModel({
    required int id,
    required String name,
    // Thêm fields theo API contract
    @Default(true) bool isActive,
  }) = _NameModel;
  factory NameModel.fromJson(Map<String, dynamic> json) => _$NameModelFromJson(json);
}
```

- `field_rename: snake` đã bật → `some_field` tự map sang `someField`, không cần `@JsonKey`
- Chỉ dùng `@JsonKey(name: '...')` khi tên thực sự khác convention

## Bước 4 — Mở rộng Cubit (nếu cần)

Xem [cubit-patterns.md](cubit-patterns.md) để thêm update, toggleActive, loadMore.

## Bước 5 — Route

Dùng skill `/new-route` hoặc xem hướng dẫn trong [route-guide.md](route-guide.md).

## Bước 6 — Build Runner

```bash
fvm dart run build_runner build --delete-conflicting-outputs
```

## Checklist

- [ ] Service return type là `Future<ApiResponse<T>>` (không có `Result<>` bọc ngoài)
- [ ] Cubit dùng `runServiceUnwrap`, có `cancelPrevious: true`, lưu `_lastParams`
- [ ] Page dùng `CubitPage` hoặc `AutoCubitConsumer`
- [ ] Route thêm vào `app_routes.dart` và guard
- [ ] Build Runner chạy không lỗi
