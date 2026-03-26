---
trigger: always_on
---

1. khi thêm mới 1 màn muốn thiếu lập route thì viết ở routes, viết vào app_routes.dart sau đó chạy gen code fvm dart run build_runner build --delete-conflicting-outputs
2. khi dùng để thông báo không dùng ScaffoldMessenger.of(context).showSnackBar tôi đã có ở toast_service.dart,
3. khi viết model @freezed
abstract class UserDeviceModel with _$UserDeviceModel
nhớ viết thêm chữ abstract
4. nhớ đọc category_rut_gon ở example để học cashc call api tôi thiết lập
5. nhớ viết đường dẫn vào file api_endpoints.dart xong với vào file _service
6. mỗi lần dùng cubit phải kiển tra đã khai báo BlocProvider của nó chưa
7. check thông tin hay valifate ô nhập thì đọc file validators.dart hoặc các file trong thư mục extensions nó có đủ hết rồi
