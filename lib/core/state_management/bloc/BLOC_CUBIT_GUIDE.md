# 📚 BLOC & CUBIT - TỔNG HỢP KHÁI NIỆM & BASE CONFIGURATION

## 🎯 CÁC KHÁI NIỆM QUAN TRỌNG

### 1. **Bloc vs Cubit**

| Khía cạnh | Bloc | Cubit |
|-----------|------|-------|
| **Cơ chế** | Event-driven (Events → States) | Method-driven (Methods → States) |
| **Boilerplate** | Nhiều hơn (cần Events) | Ít hơn (không cần Events) |
| **Testability** | Tốt hơn (test events) | Tốt |
| **Traceability** | Tốt hơn (track events) | Bình thường |
| **Khi nào dùng** | Complex logic, nhiều events | Simple logic, ít operations |

### 2. **Core Concepts**

#### **A. States (Trạng thái)**

```dart
enum BaseStatus {
  initial,      // Khởi tạo
  loading,      // Đang tải lần đầu
  loaded,       // Đã tải xong
  empty,        // Không có data
  failure,      // Có lỗi
  success,      // Thành công (mutation)
  submitting,   // Đang submit (mutation)
  refreshing,   // Đang refresh
  loadingMore,  // Đang load more (pagination)
}
```

#### **B. Events (Sự kiện - chỉ cho Bloc)**

```dart
abstract class BaseEvent extends Equatable {
  const BaseEvent();

  @override
  List<Object?> get props => [];
}

// Example:
class LoadDataEvent extends BaseEvent {}
class CreateItemEvent extends BaseEvent {
  final Item item;
  const CreateItemEvent(this.item);

  @override
  List<Object?> get props => [item];
}
```

#### **C. Emitter (Phát state - chỉ cho Bloc)**

```dart
on<LoadDataEvent>((event, emit) async {
  emit(BaseState.loading());
  // ... logic
  emit(BaseState.loaded(data));
});
```

---

## 🔑 CÁC PHƯƠNG THỨC QUAN TRỌNG

### 1. **BaseBloc / BaseCubit Methods**

#### **A. Query Operations (GET/FETCH)**

```dart
// Bloc
await onQuery(
  emit: emit,  // Chỉ Bloc cần emit
  action: () => repository.getData(),
  onSuccess: (data) => print('Got data'),
  onFailure: (failure) => print('Error'),
  cancelPrevious: true,  // Hủy request cũ
  preserveData: false,   // Không giữ data cũ khi loading
);

// Cubit
await onQuery(
  action: () => repository.getData(),
  onSuccess: (data) => print('Got data'),
  onFailure: (failure) => print('Error'),
);
```

#### **B. Mutation Operations (POST/PUT/DELETE)**

```dart
// Bloc
await onMutation(
  emit: emit,
  action: () => repository.createItem(item),
  successMessage: 'Tạo thành công',
  onSuccess: (_) => add(LoadDataEvent()),
  showLoading: true,
);

// Cubit
await onMutation(
  action: () => repository.createItem(item),
  successMessage: 'Tạo thành công',
  onSuccess: (_) => loadData(),
);
```

#### **C. Pagination**

```dart
// Bloc
await executePagination(
  emit: emit,
  action: () => repository.getMore(page: nextPage),
  onSuccess: (newData) => print('Loaded more'),
);

// Cubit
await executePagination(
  action: () => repository.getMore(page: nextPage),
  onSuccess: (newData) => print('Loaded more'),
);
```

#### **D. Flexible Execute**

```dart
// Bloc
await run(
  emit: emit,
  action: () async {
    // Custom logic
  },
  loadingState: BaseState.loading(),
  onSuccess: () => print('Done'),
  onError: (error, stack) => print('Error: $error'),
);

// Cubit
await run(
  action: () async {
    // Custom logic
  },
  loadingState: BaseState.loading(),
);
```

### 2. **State Methods**

```dart
// Getters
state.isInitial
state.isLoading
state.isLoaded
state.isEmpty
state.isFailure
state.isSuccess
state.isSubmitting
state.isRefreshing
state.isLoadingMore
state.hasData
state.hasError
state.isProcessing
state.canRetry

// Display
state.displayMessage  // Auto message based on status

// CopyWith
state.copyWith(
  status: BaseStatus.loaded,
  data: newData,
  error: 'Error message',
  message: 'Success message',
)

// Retry helpers
state.incrementRetry()
state.resetRetry()
```

### 3. **Cubit-only Methods**

```dart
// Safe emit (check isClosed)
safeEmit(BaseState.loaded(data));

// Utility
reset();                    // Reset to initial
updateData(newData);        // Update data directly
setEmpty(message: 'Empty'); // Set empty state
cancelCurrentOperation();   // Cancel current query
```

---

## 🎨 PATTERNS PHỔ BIẾN

### Pattern 1: Load Data (Query)

#### **Bloc:**
```dart
class MyBloc extends BaseBloc {
  on<LoadDataEvent>((event, emit) async {
    await onQuery(
      emit: emit,
      action: () => repository.getData(),
    );
  });
}

// Usage
bloc.add(LoadDataEvent());
```

#### **Cubit:**
```dart
class MyCubit extends BaseCubit<List<Item>> {
  Future<void> loadData() async {
    await onQuery(
      action: () => repository.getData(),
    );
  }
}

// Usage
cubit.loadData();
```

### Pattern 2: Create/Update/Delete (Mutation)

#### **Bloc:**
```dart
on<CreateItemEvent>((event, emit) async {
  await onMutation(
    emit: emit,
    action: () => repository.createItem(event.item),
    successMessage: 'Tạo thành công',
    onSuccess: (_) => add(LoadDataEvent()),
  );
});
```

#### **Cubit:**
```dart
Future<void> createItem(Item item) async {
  await onMutation(
    action: () => repository.createItem(item),
    successMessage: 'Tạo thành công',
    onSuccess: (_) => loadData(),
  );
}
```

### Pattern 3: Refresh Data

#### **Bloc:**
```dart
on<RefreshDataEvent>((event, emit) async {
  await onQuery(
    emit: emit,
    action: () => repository.getData(),
    // Auto detect refreshing if has data
  );
});
```

#### **Cubit:**
```dart
Future<void> refreshData() async {
  await onQuery(
    action: () => repository.getData(),
  );
}
```

### Pattern 4: Load More (Pagination)

#### **Bloc:**
```dart
on<LoadMoreEvent>((event, emit) async {
  await executePagination(
    emit: emit,
    action: () async {
      final newItems = await repository.getMore(page: currentPage + 1);
      return newItems.map((items) {
        final current = state.data as List<Item>? ?? [];
        return [...current, ...items] as T;
      });
    },
    onSuccess: (_) => currentPage++,
  );
});
```

#### **Cubit:**
```dart
Future<void> loadMore() async {
  await executePagination(
    action: () async {
      final newItems = await repository.getMore(page: currentPage + 1);
      return newItems.map((items) {
        final current = state.data ?? [];
        return [...current, ...items];
      });
    },
    onSuccess: (_) => currentPage++,
  );
}
```

---

## 🎭 UI INTEGRATION

### 1. **BlocProvider**

```dart
BlocProvider(
  create: (context) => MyBloc()..add(LoadDataEvent()),
  child: MyPage(),
)

// Multiple providers
MultiBlocProvider(
  providers: [
    BlocProvider(create: (_) => Bloc1()),
    BlocProvider(create: (_) => Bloc2()),
  ],
  child: MyApp(),
)
```

### 2. **BlocBuilder**

```dart
BlocBuilder<MyBloc, BaseState<List<Item>>>(
  builder: (context, state) {
    if (state.isLoading) {
      return CircularProgressIndicator();
    }

    if (state.isFailure) {
      return Text('Error: ${state.error}');
    }

    if (state.isEmpty) {
      return Text('No data');
    }

    return ListView.builder(
      itemCount: state.data!.length,
      itemBuilder: (context, index) => ItemTile(state.data![index]),
    );
  },
)
```

### 3. **BlocListener**

```dart
BlocListener<MyBloc, BaseState>(
  listener: (context, state) {
    if (state.isSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.message ?? 'Success')),
      );
    }

    if (state.isFailure) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.error ?? 'Error'),
          backgroundColor: Colors.red,
        ),
      );
    }
  },
  child: MyWidget(),
)
```

### 4. **BlocConsumer** (Builder + Listener)

```dart
BlocConsumer<MyBloc, BaseState<List<Item>>>(
  listener: (context, state) {
    if (state.isSuccess) {
      showSuccessSnackBar(state.message);
    }
  },
  builder: (context, state) {
    return ListView(...);
  },
)
```

### 5. **BlocSelector** (Optimize rebuilds)

```dart
BlocSelector<MyBloc, BaseState<User>, String>(
  selector: (state) => state.data?.name ?? '',
  builder: (context, name) {
    return Text('Name: $name');
  },
)
```

### 6. **context.read() & context.watch()**

```dart
// Read (không rebuild)
context.read<MyBloc>().add(LoadDataEvent());
context.read<MyCubit>().loadData();

// Watch (rebuild khi state thay đổi)
final state = context.watch<MyBloc>().state;
final state = context.watch<MyCubit>().state;
```

---

## 🔧 ADVANCED FEATURES

### 1. **Auto-detect Mutation**

```dart
// Tự động phát hiện mutation nếu có successMessage
await execute(
  action: () => repository.createItem(item),
  successMessage: 'Created!',  // → Auto mutation mode
);
```

### 2. **Auto-detect Refresh**

```dart
// Tự động phát hiện refresh nếu đã có data
await onQuery(
  action: () => repository.getData(),
  // Nếu state.data != null → Refreshing state
  // Nếu state.data == null → Loading state
);
```

### 3. **Cancel Previous Queries**

```dart
// Auto cancel old queries
await onQuery(
  action: () => repository.search(query),
  cancelPrevious: true,  // Default for queries
);
```

### 4. **Preserve Data on Error**

```dart
// Giữ data cũ khi có lỗi (cho mutation/refresh)
await onMutation(
  action: () => repository.updateItem(item),
  // Auto preserve data on error
);
```

### 5. **Custom Loading State**

```dart
await execute(
  action: () => repository.getData(),
  customLoadingState: BaseState.loading(previousData: oldData),
);
```

---

## 📝 BEST PRACTICES

### ✅ DO:

1. **Sử dụng Cubit cho simple logic**
   ```dart
   class CounterCubit extends BaseCubit<int> {
     void increment() => emit(state + 1);
   }
   ```

2. **Sử dụng Bloc cho complex logic**
   ```dart
   class AuthBloc extends BaseBloc {
     on<LoginEvent>(...);
     on<LogoutEvent>(...);
     on<RefreshTokenEvent>(...);
   }
   ```

3. **Sử dụng onQuery cho GET operations**
   ```dart
   await onQuery(action: () => repository.getData());
   ```

4. **Sử dụng onMutation cho POST/PUT/DELETE**
   ```dart
   await onMutation(
     action: () => repository.createItem(item),
     successMessage: 'Created!',
   );
   ```

5. **Handle errors properly**
   ```dart
   BlocListener(
     listener: (context, state) {
       if (state.isFailure) {
         showErrorDialog(state.error);
       }
     },
   )
   ```

### ❌ DON'T:

1. **Không emit state trực tiếp trong Bloc**
   ```dart
   // ❌ BAD
   emit(BaseState.loaded(data));

   // ✅ GOOD
   await onQuery(emit: emit, action: () => ...);
   ```

2. **Không forget close bloc/cubit**
   ```dart
   @override
   Future<void> close() {
     // Cleanup
     return super.close();
   }
   ```

3. **Không mutate state**
   ```dart
   // ❌ BAD
   state.data.add(newItem);

   // ✅ GOOD
   emit(BaseState.loaded([...state.data, newItem]));
   ```

---

## 🎓 KẾT LUẬN

### Bloc/Cubit cung cấp:
- ✅ **Separation of concerns** (UI ↔ Business Logic)
- ✅ **Testability** (dễ test logic)
- ✅ **Reusability** (tái sử dụng logic)
- ✅ **Predictability** (state changes rõ ràng)
- ✅ **DevTools** support

### Khi nào dùng gì?

| Tình huống | Approach |
|------------|----------|
| Simple state (counter, toggle) | **Cubit** |
| Complex flows (auth, checkout) | **Bloc** |
| Need event tracking | **Bloc** |
| Quick prototype | **Cubit** |
| Large team project | **Bloc** |
