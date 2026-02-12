# 🎯 RIVERPOD BASE CONFIGURATION

Hệ thống base configuration hoàn chỉnh cho Riverpod trong dự án Flutter.

## 📁 Cấu trúc thư mục

```
lib/core/state_management/riverpod/
├── riverpod.dart                      # ⭐ Barrel file - Import file này để dùng tất cả
├── base_async_notifier.dart           # Base class cho AsyncNotifier (không dùng codegen)
├── result_handler.dart                # Helper functions cho codegen (@riverpod)
├── riverpod_extensions.dart           # Extension methods cho Ref, AsyncValue
├── riverpod_listeners.dart            # Reusable listeners (toast, dialog, navigation)
├── RIVERPOD_GUIDE.md                  # 📚 Documentation đầy đủ về Riverpod
├── RESULT_HANDLER_GUIDE.md            # 📚 Hướng dẫn sử dụng result_handler
└── example/
    ├── riverpod_example.dart          # Ví dụ BaseAsyncNotifier
    └── complete_example.dart          # Ví dụ tổng hợp tất cả patterns
```

## 🚀 Quick Start

### 1. Import base configuration

```dart
// Thay vì import nhiều files:
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_base_template/core/state_management/riverpod/base_async_notifier.dart';
// import 'package:flutter_base_template/core/state_management/riverpod/result_handler.dart';
// ...

// Chỉ cần import 1 file:
import 'package:flutter_base_template/core/state_management/riverpod/riverpod.dart';
```

### 2. Chọn approach phù hợp

#### **Approach A: Sử dụng BaseAsyncNotifier** (Không dùng code generation)

```dart
import 'package:flutter_base_template/core/state_management/riverpod/riverpod.dart';

final myProvider = AsyncNotifierProvider<MyNotifier, List<Item>>(MyNotifier.new);

class MyNotifier extends BaseAsyncNotifier<List<Item>> {
  late final MyRepository _repository;

  @override
  FutureOr<List<Item>> build() {
    _repository = ref.watch(myRepositoryProvider);
    return [];
  }

  // ✅ Query (GET)
  Future<void> loadItems() async {
    await onQuery(action: () => _repository.getItems());
  }

  // ✅ Mutation (POST/PUT/DELETE)
  Future<void> createItem(Item item) async {
    await onMutation(
      action: () async {
        final result = await _repository.createItem(item);
        return result.map((_) => state.value ?? []);
      },
      successMessage: 'Tạo thành công',
      onSuccess: (_) => loadItems(),
    );
  }
}
```

#### **Approach B: Sử dụng result_handler** (Với code generation)

```dart
import 'package:flutter_base_template/core/state_management/riverpod/riverpod.dart';
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

  // ✅ Query (GET)
  Future<void> loadItems() async {
    state = const AsyncLoading();
    state = await executeWithLoading(() => _repository.getItems());
  }

  // ✅ Mutation (POST/PUT/DELETE)
  Future<void> createItem(Item item) async {
    await executeWithCallback(
      () => _repository.createItem(item),
      onSuccess: (_) => loadItems(),
    );
  }
}
```

### 3. Sử dụng trong UI

```dart
import 'package:flutter_base_template/core/state_management/riverpod/riverpod.dart';

class MyPage extends ConsumerStatefulWidget {
  const MyPage({super.key});

  @override
  ConsumerState<MyPage> createState() => _MyPageState();
}

class _MyPageState extends ConsumerState<MyPage> {
  @override
  void initState() {
    super.initState();

    // Load data khi vào page
    Future.microtask(() => ref.read(myProvider.notifier).loadItems());

    // Setup listeners
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // ✅ Listen và show SnackBar
      listenAsyncValueWithSnackBar(
        ref: ref,
        context: context,
        provider: myProvider,
        showErrorSnackBar: true,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(myProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('My Page')),
      body: state.when(
        data: (items) => ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) => ListTile(
            title: Text(items[index].name),
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => ref.read(myProvider.notifier).loadItems(),
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
```

## 📚 Utilities có sẵn

### 🎨 Extensions

#### AsyncValue Extensions
```dart
final state = ref.watch(myProvider);

// Lấy data hoặc default
final items = state.dataOrDefault([]);

// Lấy data hoặc null
final items = state.dataOrNull;

// Lấy error hoặc null
final error = state.errorOrNull;

// Kiểm tra loading/refreshing
if (state.isLoadingOrRefreshing) { }

// Map data
final names = state.mapData((items) => items.map((i) => i.name).toList());

// Execute callbacks
state.onData((data) => print('Got data'));
state.onError((error, stack) => print('Error'));
```

#### WidgetRef Extensions
```dart
// Invalidate multiple providers
ref.invalidateAll([provider1, provider2, provider3]);

// Refresh multiple providers
ref.refreshAll([provider1, provider2]);
```

### 🎧 Listeners

#### Show SnackBar
```dart
listenAsyncValueWithSnackBar(
  ref: ref,
  context: context,
  provider: myProvider,
  successMessage: 'Thành công!',
  showSuccessSnackBar: true,
  showErrorSnackBar: true,
);
```

#### Show Dialog
```dart
listenAsyncValueWithDialog(
  ref: ref,
  context: context,
  provider: myProvider,
  errorTitle: 'Lỗi',
  showErrorDialog: true,
);
```

#### Navigate on Success
```dart
listenAndNavigateOnSuccess(
  ref: ref,
  context: context,
  provider: myProvider,
  route: '/home',
  replace: true,
);
```

#### Pop on Success
```dart
listenAndPopOnSuccess(
  ref: ref,
  context: context,
  provider: myProvider,
  result: 'created',
);
```

#### Listen Field Changes
```dart
listenFieldChange<User, String>(
  ref: ref,
  provider: userProvider,
  selector: (user) => user.name,
  onChanged: (oldName, newName) => print('Name changed'),
);
```

## 🎯 Best Practices

### ✅ DO:

1. **Sử dụng `ref.watch()` trong build method**
   ```dart
   final data = ref.watch(myProvider);
   ```

2. **Sử dụng `ref.read()` trong callbacks/events**
   ```dart
   onPressed: () => ref.read(myProvider.notifier).loadData()
   ```

3. **Sử dụng `ref.listen()` cho side effects**
   ```dart
   ref.listen(myProvider, (previous, next) {
     // Show toast, navigate, etc.
   });
   ```

4. **Sử dụng extensions để code ngắn gọn**
   ```dart
   final items = state.dataOrDefault([]);
   ```

5. **Sử dụng reusable listeners**
   ```dart
   listenAsyncValueWithSnackBar(...);
   ```

### ❌ DON'T:

1. **Không dùng `ref.watch()` trong callbacks**
   ```dart
   // ❌ BAD
   onPressed: () {
     final data = ref.watch(myProvider); // Không rebuild!
   }
   ```

2. **Không dùng `ref.read()` trong build**
   ```dart
   // ❌ BAD
   @override
   Widget build(BuildContext context) {
     final data = ref.read(myProvider); // Không rebuild khi thay đổi!
   }
   ```

3. **Không mutate state trực tiếp**
   ```dart
   // ❌ BAD
   state.value.add(newItem);

   // ✅ GOOD
   state = AsyncData([...state.value ?? [], newItem]);
   ```

## 📖 Documentation

- **[RIVERPOD_GUIDE.md](./RIVERPOD_GUIDE.md)** - Tổng hợp tất cả khái niệm Riverpod
- **[RESULT_HANDLER_GUIDE.md](./RESULT_HANDLER_GUIDE.md)** - Hướng dẫn sử dụng result_handler
- **[example/complete_example.dart](./example/complete_example.dart)** - Ví dụ tổng hợp

## 🎓 Khi nào dùng gì?

| Tình huống | Approach | Lý do |
|------------|----------|-------|
| Dự án mới, muốn type-safe | Code generation + result_handler | Best practices, ít boilerplate |
| Dự án cũ, không dùng codegen | BaseAsyncNotifier | Dễ migrate, nhiều features |
| Simple state (counter, toggle) | StateProvider | Đơn giản, nhanh |
| Computed values | Provider | Pure, cacheable |
| Real-time data | StreamProvider | Auto-update |

## 🚀 Next Steps

1. Đọc [RIVERPOD_GUIDE.md](./RIVERPOD_GUIDE.md) để hiểu đầy đủ các khái niệm
2. Xem [example/complete_example.dart](./example/complete_example.dart) để học patterns
3. Áp dụng vào dự án của bạn
4. Sử dụng extensions và listeners để code ngắn gọn hơn

## 💡 Tips

- Import `riverpod.dart` thay vì import từng file riêng lẻ
- Sử dụng extensions để code ngắn gọn hơn
- Sử dụng reusable listeners thay vì viết lại logic
- Đọc documentation khi cần tham khảo
- Xem examples để học patterns

---

**Happy Coding! 🎉**
