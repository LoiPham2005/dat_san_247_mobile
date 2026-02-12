# 📚 RIVERPOD - TỔNG HỢP KHÁI NIỆM & BASE CONFIGURATION

## 🎯 CÁC KHÁI NIỆM QUAN TRỌNG TRONG RIVERPOD

### 1. **Provider Types** (Các loại Provider)

| Provider Type | Mục đích | Khi nào dùng |
|--------------|----------|--------------|
| `Provider<T>` | Cung cấp giá trị không đổi/computed | Dependency injection, config, computed values |
| `StateProvider<T>` | Quản lý state đơn giản | Counter, toggle, simple state |
| `FutureProvider<T>` | Async data một lần | Fetch data không cần refresh |
| `StreamProvider<T>` | Stream data liên tục | Real-time data, WebSocket |
| `NotifierProvider<T>` | State + logic (sync) | Complex state management |
| `AsyncNotifierProvider<T>` | State + logic (async) | **RECOMMENDED** - API calls, async operations |

### 2. **Ref Methods** (Các phương thức của Ref)

#### 📖 **Đọc Provider**
```dart
// ref.watch() - Rebuild khi provider thay đổi (dùng trong build)
final value = ref.watch(myProvider);

// ref.read() - Đọc một lần, không rebuild (dùng trong callbacks/events)
final value = ref.read(myProvider);

// ref.listen() - Lắng nghe thay đổi và thực hiện side effects
ref.listen(myProvider, (previous, next) {
  // Show snackbar, navigate, etc.
});

// ref.listenManual() - Listen nhưng có thể close manually
final subscription = ref.listenManual(myProvider, (previous, next) {});
subscription.close();
```

#### 🔄 **Quản lý Provider**
```dart
// ref.invalidate() - Reset provider về initial state
ref.invalidate(myProvider);

// ref.refresh() - Force refresh provider
ref.refresh(myProvider);

// ref.exists() - Kiểm tra provider có tồn tại không
if (ref.exists(myProvider)) { }

// ref.onDispose() - Cleanup khi provider bị dispose
ref.onDispose(() {
  // Close streams, cancel timers, etc.
});
```

### 3. **AsyncValue<T>** (Quản lý async state)

```dart
// Các trạng thái
AsyncValue<T>.loading()  // Đang load
AsyncValue<T>.data(T)    // Có data
AsyncValue<T>.error(e)   // Có lỗi

// Các methods
state.when(
  data: (data) => Widget,
  loading: () => Widget,
  error: (error, stack) => Widget,
)

state.whenData((data) => Widget)  // Chỉ xử lý khi có data
state.whenOrNull(data: (data) => {})  // Nullable

// Properties
state.isLoading  // bool
state.hasError   // bool
state.hasValue   // bool
state.value      // T? (nullable)
state.error      // Object?
```

### 4. **Notifier Methods** (Trong AsyncNotifier)

```dart
class MyNotifier extends AsyncNotifier<T> {
  // state - AsyncValue<T> (read/write)
  state = AsyncLoading();
  state = AsyncData(data);
  state = AsyncError(error, stack);

  // ref - ProviderRef (access other providers)
  ref.watch(otherProvider);
  ref.read(otherProvider);
  ref.invalidate(otherProvider);

  // build() - Initialize state
  @override
  FutureOr<T> build() { }
}
```

### 5. **Consumer Widgets**

```dart
// ConsumerWidget - Stateless + ref
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = ref.watch(myProvider);
    return Text(value);
  }
}

// ConsumerStatefulWidget - Stateful + ref
class MyWidget extends ConsumerStatefulWidget {
  @override
  ConsumerState<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends ConsumerState<MyWidget> {
  @override
  Widget build(BuildContext context) {
    final value = ref.watch(myProvider);
    return Text(value);
  }
}

// Consumer - Builder pattern
Consumer(
  builder: (context, ref, child) {
    final value = ref.watch(myProvider);
    return Text(value);
  },
)
```

### 6. **Modifiers** (Code Generation)

```dart
// @riverpod - Auto-generate provider
@riverpod
class MyNotifier extends _$MyNotifier { }

// @Riverpod(keepAlive: true) - Không auto-dispose
@Riverpod(keepAlive: true)
class MyNotifier extends _$MyNotifier { }

// Family - Provider với parameters
@riverpod
class MyNotifier extends _$MyNotifier {
  @override
  FutureOr<T> build(String id) { }  // Parameter
}
// Usage: ref.watch(myNotifierProvider('id'))
```

---

## 🏗️ BASE CONFIGURATION - CẤU TRÚC ĐỀ XUẤT

### Cấu trúc thư mục
```
lib/core/state_management/riverpod/
├── base_async_notifier.dart          # Base cho AsyncNotifier (không dùng codegen)
├── result_handler.dart                # Helper functions cho codegen
├── riverpod_extensions.dart           # Extension methods cho Ref, AsyncValue
├── riverpod_listeners.dart            # Reusable listeners (toast, dialog, etc.)
├── RIVERPOD_GUIDE.md                  # Documentation đầy đủ
└── example/
    ├── basic_example.dart             # Ví dụ cơ bản
    ├── advanced_example.dart          # Ví dụ nâng cao
    └── codegen_example.dart           # Ví dụ với code generation
```

---

## 🎨 CÁC PATTERNS PHỔ BIẾN

### Pattern 1: Query (GET/FETCH)
```dart
Future<void> loadData() async {
  state = const AsyncLoading();
  state = await executeWithLoading(() => repository.getData());
}
```

### Pattern 2: Mutation (POST/PUT/DELETE)
```dart
Future<void> createData(Data data) async {
  await executeWithCallback(
    () => repository.create(data),
    onSuccess: (_) => loadData(),
  );
}
```

### Pattern 3: Listen & Show Toast
```dart
ref.listen(myProvider, (previous, next) {
  next.whenOrNull(
    error: (error, _) => showErrorToast(error.toString()),
  );

  if (notifier.message != null) {
    showSuccessToast(notifier.message!);
  }
});
```

### Pattern 4: Refresh Indicator
```dart
RefreshIndicator(
  onRefresh: () async => ref.read(myProvider.notifier).loadData(),
  child: ListView(...),
)
```

### Pattern 5: Pagination
```dart
Future<void> loadMore() async {
  if (state.isLoading) return;

  final currentData = state.value ?? [];
  state = AsyncData(currentData); // Keep current data

  final result = await repository.getMore(page: currentPage + 1);
  result.fold(
    onSuccess: (newData) {
      state = AsyncData([...currentData, ...newData]);
      currentPage++;
    },
    onFailure: (failure) => state = AsyncError(failure, StackTrace.current),
  );
}
```

---

## 📝 BEST PRACTICES

### ✅ DO:
1. **Sử dụng `ref.watch()` trong build method**
2. **Sử dụng `ref.read()` trong callbacks/events**
3. **Sử dụng `ref.listen()` cho side effects (toast, navigation)**
4. **Sử dụng AsyncNotifier cho complex state**
5. **Sử dụng code generation (@riverpod) cho type safety**
6. **Cleanup resources trong `ref.onDispose()`**

### ❌ DON'T:
1. **Không dùng `ref.watch()` trong callbacks** (sẽ không rebuild)
2. **Không dùng `ref.read()` trong build** (sẽ không rebuild khi thay đổi)
3. **Không mutate state trực tiếp** (luôn tạo state mới)
4. **Không forget dispose** (streams, controllers, timers)

---

## 🔧 CHEAT SHEET

### Đọc State
```dart
// Watch (rebuild)
final data = ref.watch(myProvider);
final data = ref.watch(myProvider.select((state) => state.value));

// Read (no rebuild)
final data = ref.read(myProvider);
final notifier = ref.read(myProvider.notifier);
```

### Cập nhật State
```dart
// Trong Notifier
state = AsyncLoading();
state = AsyncData(newData);
state = AsyncError(error, stack);

// Từ bên ngoài
ref.read(myProvider.notifier).updateData(newData);
ref.invalidate(myProvider);  // Reset
ref.refresh(myProvider);     // Force reload
```

### Listen Changes
```dart
// Basic listen
ref.listen(myProvider, (previous, next) {
  print('Changed from $previous to $next');
});

// Listen with condition
ref.listen(myProvider, (previous, next) {
  if (next.hasError) {
    showError(next.error);
  }
});

// Listen specific field
ref.listen(
  myProvider.select((state) => state.value?.id),
  (previous, next) {
    print('ID changed from $previous to $next');
  },
);
```

---

## 🎓 KẾT LUẬN

Riverpod cung cấp:
- ✅ **Type-safe** state management
- ✅ **Compile-time** error checking
- ✅ **Auto-dispose** providers
- ✅ **Testable** code
- ✅ **DevTools** support
- ✅ **Code generation** for less boilerplate

Sử dụng kết hợp:
- **BaseAsyncNotifier** cho manual providers
- **result_handler.dart** cho code generation
- **ref.listen()** cho side effects
- **AsyncValue.when()** cho UI rendering
