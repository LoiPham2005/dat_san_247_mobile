---
name: code-review
description: Review code Flutter theo chuẩn project — kiểm tra Service, Model, Cubit, Page, DI, Route. Dùng khi user nói "review code", "check code", "kiểm tra file này có đúng không".
argument-hint: [file-path hoặc feature-name]
disable-model-invocation: false
allowed-tools: Read Glob Grep
---

# Code Review: $ARGUMENTS

Đọc file được chỉ định rồi kiểm tra từng mục theo checklist sau. Báo cáo rõ: ✅ đúng / ❌ sai (kèm dòng code cụ thể) / ⚠️ cần chú ý.

## Service layer
- [ ] Return type `Future<ApiResponse<T>>` — **không** có `Result<>` bọc ngoài
- [ ] `Future<void>` cho DELETE
- [ ] Có `@LazySingleton()`, `@RestApi()`, `@factoryMethod`
- [ ] Endpoint dùng `ApiEndpoints.xxx`, không hardcode string
- [ ] `@Queries()` cho filter, `@Path()` cho path param, `@Body()` cho body

## Model layer
- [ ] `@freezed abstract class` + `with _$ClassName`
- [ ] Có `part '*.freezed.dart'` + `part '*.g.dart'`
- [ ] `factory fromJson` có
- [ ] Field nullable đúng với API contract
- [ ] Không dùng `@JsonKey` không cần thiết (field_rename: snake đã bật)

## Cubit layer
- [ ] `@injectable` (không phải `@LazySingleton`)
- [ ] `const BaseState.initial()` — có `const`
- [ ] `runServiceUnwrap` là default; không dùng `runResultUnwrap` với Service
- [ ] `cancelPrevious: true` trên load/refresh
- [ ] `_lastParams` lưu và dùng lại trong `refresh`
- [ ] `loadingState: BaseState.loading(previousData: state.data)` trên refresh
- [ ] Mutation cập nhật đúng item trong list (không fetch lại toàn bộ)
- [ ] `successMessage` có trên create/update/delete

## Page / UI layer
- [ ] Dùng `CubitPage` hoặc `AutoCubitConsumer` — không tự viết `BlocProvider` thủ công
- [ ] `state.whenReady` xử lý đủ 4 case: loading, success, empty, failure
- [ ] `loading` case: hiển thị data cũ nếu `prev != null`
- [ ] Toast chỉ show khi `state.message != null`
- [ ] Không gọi cubit method trong `builder` (chỉ trong `onPressed`, `listener`)

## DI & build.yaml
- [ ] Sau khi thêm annotation → Build Runner đã chạy
- [ ] `injection.config.dart` không edit thủ công

## Route
- [ ] `@TypedGoRoute` khai báo đúng path
- [ ] Route public thêm vào `_publicRoutes`
- [ ] Build Runner đã chạy — có `$RouteName` mixin

## Failure handling
- [ ] Không expose `e.toString()` hoặc stack trace ra UI
- [ ] `failureMapper` phân loại `NetworkFailure`, `AuthFailure` khi UX khác nhau
