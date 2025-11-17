# Hướng dẫn đóng góp

Cảm ơn bạn đã quan tâm đến việc đóng góp cho dự án! Mọi đóng góp đều được hoan nghênh.

## Quy trình phát triển

1.  **Fork the repository** về tài khoản GitHub của bạn.
2.  **Clone a fork** của bạn về máy local.
3.  **Tạo một branch mới** cho tính năng hoặc bản vá lỗi của bạn:
    ```bash
    git checkout -b feature/ten-tinh-nang-moi
    ```
4.  **Thực hiện các thay đổi** trên branch mới.
5.  **Chạy các kiểm tra** để đảm bảo code chất lượng.
6.  **Tạo một Pull Request** từ branch của bạn vào branch `main` của repository gốc.

## Quy tắc về Code

-   Tuân thủ theo hướng dẫn **Effective Dart**: [https://dart.dev/guides/language/effective-dart](https://dart.dev/guides/language/effective-dart)
-   Chạy lệnh `dart format .` trước khi commit để đảm bảo code được định dạng thống nhất.
-   Chạy `flutter analyze` để kiểm tra các lỗi và cảnh báo tiềm ẩn.

## Quy tắc về Commit Message

Chúng tôi khuyến khích tuân theo chuẩn **Conventional Commits**. Điều này giúp lịch sử commit rõ ràng và dễ dàng tự động tạo changelog.

-   `feat:`: Một tính năng mới.
-   `fix:`: Một bản vá lỗi.
-   `docs:`: Thay đổi liên quan đến tài liệu.
-   `style:`: Thay đổi về định dạng code (dấu cách, dấu chấm phẩy...).
-   `refactor:`: Tái cấu trúc code mà không thay đổi chức năng.
-   `test:`: Thêm hoặc sửa đổi test.
-   `chore:`: Các công việc bảo trì (cập nhật build script, dependencies...).