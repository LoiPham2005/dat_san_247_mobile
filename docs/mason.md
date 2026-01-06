# 🧱 Mason Feature Generator Guide

## 1. Giới thiệu

[Mason](https://pub.dev/packages/mason) là công cụ giúp generate code template nhanh chóng, chuẩn hóa cấu trúc dự án Flutter theo Clean Architecture.
Dự án này đã cấu hình sẵn **brick** `feature` để tạo mới một tính năng (feature) đầy đủ các layer: Domain, Data, Presentation.

---

## 2. Cài đặt Mason

Nếu chưa cài Mason, chạy:

```bash
dart pub global activate mason_cli
```

---

## 3. Thêm brick vào dự án (nếu chưa có)

Đã cấu hình sẵn trong [`mason.yaml`](../mason.yaml):

```yaml
bricks:
  feature:
    path: bricks/feature
```

---

## 4. Generate Feature Mới

Chạy lệnh sau để generate một feature mới:

```bash
mason make feature
```

**Quy trình:**
- Mason sẽ hỏi tên feature (`feature_name`) và các tuỳ chọn (list, detail, create, update, delete, state management).
- Sau khi trả lời, Mason sẽ tạo folder và file mẫu trong `lib/features/<feature_name>/` theo đúng Clean Architecture.

---

## 5. Các Biến & Tuỳ Chọn

- `feature_name`: Tên tính năng (vd: category, product, user)
- `state_management`: bloc, cubit, getx, provider, riverpod
- `has_list`: Tạo method lấy danh sách?
- `has_detail`: Tạo method lấy chi tiết?
- `has_create`: Tạo method tạo mới?
- `has_update`: Tạo method cập nhật?
- `has_delete`: Tạo method xoá?

---

## 6. Cấu trúc sau khi generate

```
lib/features/<feature_name>/
├── data/
│   ├── datasources/
│   ├── models/
│   └── repositories/
├── domain/
│   ├── entities/
│   ├── repositories/
│   └── usecases/
└── presentation/
    ├── bloc/
    ├── pages/
    └── widgets/
```

---

## 7. Sau khi generate

- **Chỉnh sửa lại endpoint, model, entity cho phù hợp API thực tế.**
- Chạy lại codegen nếu cần:
  ```bash
  dart run build_runner build --delete-conflicting-outputs
  ```
- Thêm logic vào các file đã generate.

---

## 8. Tài liệu tham khảo

- [Mason Official Docs](https://docs.brickhub.dev)
- [Clean Architecture Guide](architecture.md)
- [API Implementation Guide](call_api.md)

---

## 9. Một số lệnh hữu ích

```bash
# Xem danh sách bricks đã add
mason list

# Add brick mới (nếu cần)
mason add <brick_name> --path bricks/<brick_name>

# Remove brick
mason remove <brick_name>

mason get

mason make feature
```

---

## 10. Troubleshooting

- Nếu gặp lỗi khi generate, kiểm tra lại cú pháp file template trong `bricks/feature/__brick__`.
- Nếu file template báo đỏ trong VS Code, thêm exclude vào `analysis_options.yaml`:
  ```yaml
  analyzer:
    exclude:
      - "bricks/feature/__brick__/**"
  ```

---

**Happy Coding! 🚀**
