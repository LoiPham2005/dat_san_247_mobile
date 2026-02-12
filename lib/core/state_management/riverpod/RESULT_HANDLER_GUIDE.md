# Result Handler - Helper Functions Guide

## 📖 Tổng quan

File `result_handler.dart` cung cấp các helper functions để xử lý `Result` type một cách ngắn gọn và dễ dàng trong AsyncNotifier (đặc biệt với riverpod_generator).

## 🎯 Lợi ích

### Trước khi sử dụng helper:
```dart
Future<void> loadCategories() async {
  state = const AsyncLoading();
  final result = await _repository.getCategories();

  result.fold(
    onSuccess: (data) => state = AsyncData(data),
    onFailure: (failure) => state = AsyncError(failure, StackTrace.current),
  );
}
```

### Sau khi sử dụng helper:
```dart
Future<void> loadCategories() async {
  state = const AsyncLoading();
  state = await executeWithLoading(() => _repository.getCategories());
}
```

**Giảm từ 7 dòng xuống còn 2 dòng!** 🎉

## 📚 Các Helper Functions

### 1. `executeWithLoading()` - Cho Query Operations (GET/FETCH)

**Mục đích:** Tự động xử lý Result và chuyển thành AsyncValue

**Sử dụng:**
```dart
Future<void> loadCategories({Map<String, dynamic>? params}) async {
  state = const AsyncLoading();
  state = await executeWithLoading(() => _repository.getCategories(params: params));
}
```

**Khi nào dùng:**
- Khi fetch data từ API
- Khi load danh sách
- Khi get chi tiết một item

---

### 2. `executeWithCallback()` - Cho Mutation Operations (POST/PUT/DELETE)

**Mục đích:** Xử lý mutations với callback để thực hiện hành động sau khi thành công

**Sử dụng:**
```dart
Future<void> createCategory(CategoryRutGonModel category) async {
  await executeWithCallback(
    () => _repository.createCategory(category),
    onSuccess: (_) => loadCategories(), // Reload data sau khi tạo thành công
  );
}

Future<void> deleteCategory(String id) async {
  await executeWithCallback(
    () => _repository.deleteCategory(id),
    onSuccess: (_) {
      loadCategories();
      showSuccessMessage('Đã xóa thành công');
    },
    onFailure: (failure) {
      showErrorMessage(failure.message);
    },
  );
}
```

**Khi nào dùng:**
- Khi create/update/delete data
- Khi cần reload data sau khi mutation thành công
- Khi cần show notification sau khi thành công/thất bại

---

### 3. `handleResultToAsyncValue()` - Convert Result sang AsyncValue

**Mục đích:** Chuyển đổi trực tiếp Result thành AsyncValue

**Sử dụng:**
```dart
Future<void> loadData() async {
  final result = await _repository.getData();
  state = handleResultToAsyncValue(result);
}
```

---

### 4. `handleResultWithCallback()` - Xử lý Result với callbacks

**Mục đích:** Xử lý Result và thực hiện callbacks mà không cập nhật state

**Sử dụng:**
```dart
Future<void> exportData() async {
  final result = await _repository.exportData();
  handleResultWithCallback(
    result,
    onSuccess: (data) => print('Exported: $data'),
    onFailure: (failure) => print('Failed: ${failure.message}'),
  );
}
```

## 💡 Best Practices

### ✅ DO:

1. **Sử dụng `executeWithLoading()` cho queries:**
```dart
Future<void> loadItems() async {
  state = const AsyncLoading();
  state = await executeWithLoading(() => _repository.getItems());
}
```

2. **Sử dụng `executeWithCallback()` cho mutations:**
```dart
Future<void> createItem(Item item) async {
  await executeWithCallback(
    () => _repository.createItem(item),
    onSuccess: (_) => loadItems(),
  );
}
```

3. **Combine với error handling:**
```dart
Future<void> updateItem(String id, Item item) async {
  await executeWithCallback(
    () => _repository.updateItem(id, item),
    onSuccess: (_) {
      loadItems();
      showSnackBar('Cập nhật thành công');
    },
    onFailure: (failure) {
      showSnackBar('Lỗi: ${failure.message}');
    },
  );
}
```

### ❌ DON'T:

1. **Không dùng cho non-Result types:**
```dart
// ❌ BAD
state = await executeWithLoading(() => someNonResultFunction());

// ✅ GOOD
final data = await someNonResultFunction();
state = AsyncData(data);
```

2. **Không quên set loading state:**
```dart
// ❌ BAD - Không có loading indicator
state = await executeWithLoading(() => _repository.getItems());

// ✅ GOOD
state = const AsyncLoading();
state = await executeWithLoading(() => _repository.getItems());
```

## 🔄 So sánh với các approach khác

### BaseAsyncNotifier (Khi không dùng riverpod_generator)
```dart
class MyNotifier extends BaseAsyncNotifier<List<Item>> {
  Future<void> loadItems() async {
    await onQuery(
      action: () => _repository.getItems(),
    );
  }
}
```

### Helper Functions (Khi dùng riverpod_generator)
```dart
@riverpod
class MyNotifier extends _$MyNotifier {
  Future<void> loadItems() async {
    state = const AsyncLoading();
    state = await executeWithLoading(() => _repository.getItems());
  }
}
```

## 📝 Ví dụ hoàn chỉnh

```dart
import 'package:flutter_base_template/core/state_management/riverpod/result_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'my_notifier.g.dart';

@riverpod
class MyNotifier extends _$MyNotifier {
  late final MyRepository _repository;

  @override
  FutureOr<List<Item>> build() {
    _repository = ref.watch(myRepositoryProvider);
    return [];
  }

  // Query: Load data
  Future<void> loadItems({Map<String, dynamic>? params}) async {
    state = const AsyncLoading();
    state = await executeWithLoading(() => _repository.getItems(params: params));
  }

  // Mutation: Create
  Future<void> createItem(Item item) async {
    await executeWithCallback(
      () => _repository.createItem(item),
      onSuccess: (_) => loadItems(),
    );
  }

  // Mutation: Update
  Future<void> updateItem(String id, Item item) async {
    await executeWithCallback(
      () => _repository.updateItem(id, item),
      onSuccess: (_) => loadItems(),
    );
  }

  // Mutation: Delete
  Future<void> deleteItem(String id) async {
    await executeWithCallback(
      () => _repository.deleteItem(id),
      onSuccess: (_) => loadItems(),
    );
  }
}
```

## 🎓 Kết luận

Helper functions giúp:
- ✅ Giảm boilerplate code đáng kể
- ✅ Code dễ đọc và maintain hơn
- ✅ Tương thích hoàn toàn với riverpod_generator
- ✅ Xử lý error tự động
- ✅ Logging tự động khi có lỗi
