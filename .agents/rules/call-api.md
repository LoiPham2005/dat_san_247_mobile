---
trigger: always_on
---

1. khi thêm mới 1 màn muốn thiếu lập route thì viết ở routes, viết vào app_routes.dart sau đó chạy gen code fvm dart run build_runner build --delete-conflicting-outputs
2. khi dùng để thông báo không dùng ScaffoldMessenger.of(context).showSnackBar tôi đã có ở toast_service.dart,
3. khi viết model @freezed
abstract class UserDeviceModel with _$UserDeviceModel
nhớ viết thêm chữ abstract
ví dụ:
// ✅ Tất cả tự sinh: copyWith, ==, hashCode, toString
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
abstract class LoginRequest with _$LoginRequest {
  const factory LoginRequest({
    required String email,
    required String password,
  }) = _LoginRequest;

  factory LoginRequest.fromJson(Map<String, dynamic> json) => _$LoginRequestFromJson(json);
}

// ════════════════════════════════════════════════════════════════════════════
// 📋 QUY TẮC NHANH
// ════════════════════════════════════════════════════════════════════════════
//
//  ✅ Luôn có const UserModel._()  → khi cần getter/method
//  ✅ field_rename: snake_case     → KHÔNG cần @JsonKey cho tên thông thường
//  ✅ @Default(value)              → thay vì = value trong constructor
//  ✅ @DateTimeConverter()         → cho mọi DateTime field
//  ✅ @JsonEnum(valueField:'value')→ cho mọi Enum
//  ✅ sealed class + union type    → cho State, Result
//  ✅ switch(state) { ... }        → pattern matching Dart 3, exhaustive
//
//  ❌ KHÔNG dùng @JsonKey cho snake_case thông thường (build.yaml lo rồi)
//  ❌ KHÔNG extends với Freezed    → dùng composition hoặc implements
//  ❌ KHÔNG quên part '*.freezed.dart' và part '*.g.dart'
//  ❌ KHÔNG quên chạy build_runner sau khi thêm field mới

4. nhớ đọc category_rut_gon ở example để học cashc call api tôi thiết lập
5. nhớ viết đường dẫn vào file api_endpoints.dart xong với vào file _service
6. mỗi lần dùng cubit phải kiển tra đã khai báo BlocProvider của nó chưa
7. check thông tin hay valifate ô nhập thì đọc file validators.dart hoặc các file trong thư mục extensions nó có đủ hết rồi
8. nếu cái nào mà có thể dùng chung nhiều màn có thể viết vào thưu mục shared xong gọi ra
