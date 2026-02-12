// ════════════════════════════════════════════════════════════════
// 📁 lib/core/state_management/riverpod/example/complete_example.dart
// ════════════════════════════════════════════════════════════════
import 'package:flutter/material.dart';
import 'package:dat_san_247_mobile/core/state_management/riverpod/riverpod_extensions.dart';
import 'package:dat_san_247_mobile/core/state_management/riverpod/riverpod_listeners.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 📘 COMPLETE EXAMPLE - Tổng hợp tất cả patterns và best practices

// ════════════════════════════════════════════════════════════════
// 1️⃣ PROVIDERS
// ════════════════════════════════════════════════════════════════

// Async provider
final userProvider = FutureProvider<String>((ref) async {
  await Future.delayed(const Duration(seconds: 1));
  return 'John Doe';
});

// ════════════════════════════════════════════════════════════════
// 2️⃣ WIDGET EXAMPLES
// ════════════════════════════════════════════════════════════════

/// Example 1: Basic ConsumerWidget
class BasicExample extends ConsumerWidget {
  const BasicExample({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProvider);

    return userAsync.when(
      data: (user) => Text('User: $user'),
      loading: () => const CircularProgressIndicator(),
      error: (error, _) => Text('Error: $error'),
    );
  }
}

/// Example 2: Sử dụng Extensions
class ExtensionExample extends ConsumerWidget {
  const ExtensionExample({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProvider);

    // ✅ Sử dụng extension methods
    final userName = userAsync.dataOrDefault('Guest');
    final hasError = userAsync.errorOrNull != null;
    final isLoadingOrRefreshing = userAsync.isLoadingOrRefreshing;

    return Column(
      children: [
        Text('User: $userName'),
        Text('Has Error: $hasError'),
        Text('Loading: $isLoadingOrRefreshing'),
        ElevatedButton(onPressed: () => ref.invalidate(userProvider), child: const Text('Refresh')),
      ],
    );
  }
}

/// Example 3: Sử dụng Listeners
class ListenerExample extends ConsumerStatefulWidget {
  const ListenerExample({super.key});

  @override
  ConsumerState<ListenerExample> createState() => _ListenerExampleState();
}

class _ListenerExampleState extends ConsumerState<ListenerExample> {
  @override
  void initState() {
    super.initState();

    // ✅ Setup listeners
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Listen và show SnackBar
      listenAsyncValueWithSnackBar(
        ref: ref,
        context: context,
        provider: userProvider,
        successMessage: 'User loaded!',
        showSuccessSnackBar: true,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(userProvider);

    return userAsync.when(
      data: (user) => Text('User: $user'),
      loading: () => const CircularProgressIndicator(),
      error: (error, _) => Text('Error: $error'),
    );
  }
}

/// Example 4: Advanced Patterns
class AdvancedExample extends ConsumerStatefulWidget {
  const AdvancedExample({super.key});

  @override
  ConsumerState<AdvancedExample> createState() => _AdvancedExampleState();
}

class _AdvancedExampleState extends ConsumerState<AdvancedExample> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // ✅ Listen và show dialog on error
      listenAsyncValueWithDialog(
        ref: ref,
        context: context,
        provider: userProvider,
        errorTitle: 'Lỗi tải user',
        showErrorDialog: true,
      );

      // ✅ Listen specific field changes
      listenFieldChange<String, int>(
        ref: ref,
        provider: userProvider,
        selector: (user) => user.length,
        onChanged: (oldLength, newLength) {
          print('Name length changed from $oldLength to $newLength');
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(userProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Advanced Example')),
      body: Center(
        child: userAsync.when(
          data: (user) => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('User: $user'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.refresh(userProvider),
                child: const Text('Refresh'),
              ),
            ],
          ),
          loading: () => const CircularProgressIndicator(),
          error: (error, _) => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, color: Colors.red, size: 48),
              const SizedBox(height: 16),
              Text('Error: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.invalidate(userProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════
// 3️⃣ BEST PRACTICES SUMMARY
// ════════════════════════════════════════════════════════════════

/*
✅ DO:
1. Sử dụng ref.watch() trong build method
2. Sử dụng ref.read() trong callbacks/events
3. Sử dụng ref.listen() cho side effects
4. Sử dụng extensions để code ngắn gọn hơn
5. Sử dụng reusable listeners
6. Cleanup trong ref.onDispose()

❌ DON'T:
1. Không dùng ref.watch() trong callbacks
2. Không dùng ref.read() trong build
3. Không mutate state trực tiếp
4. Không forget dispose resources

📚 PATTERNS:
- listenAsyncValueWithSnackBar() - Show toast
- listenAsyncValueWithDialog() - Show dialog
- listenAndNavigateOnSuccess() - Navigate
- listenAndPopOnSuccess() - Pop screen
- listenFieldChange() - Listen specific field

🎨 EXTENSIONS:
- dataOrDefault() - Get data or default value
- dataOrNull - Get data or null
- errorOrNull - Get error or null
- isLoadingOrRefreshing - Check loading state
- mapData() - Transform data
- onData() - Execute on data
- onError() - Execute on error
*/
