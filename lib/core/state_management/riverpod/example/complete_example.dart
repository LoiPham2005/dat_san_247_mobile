// ════════════════════════════════════════════════════════════════
// 📁 lib/core/state_management/riverpod/example/complete_example.dart
// ════════════════════════════════════════════════════════════════
import 'package:flutter/material.dart';
import 'package:dat_san_247_mobile/core/state_management/riverpod/riverpod.dart';

/// 📘 COMPLETE EXAMPLE - Simplified
final userProvider = FutureProvider<String>((ref) async {
  await Future.delayed(const Duration(seconds: 1));
  return 'John Doe';
});

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

class ExtensionExample extends ConsumerWidget {
  const ExtensionExample({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProvider);

    // final userName = userAsync.dataOrDefault('Guest');
    final hasError = userAsync.hasError;
    final isLoading = userAsync.isLoading;

    return Column(
      children: [
        // Text('User: $userName'),
        Text('Has Error: $hasError'),
        Text('Loading: $isLoading'),
        ElevatedButton(onPressed: () => ref.invalidate(userProvider), child: const Text('Refresh')),
      ],
    );
  }
}

class ListenerExample extends ConsumerStatefulWidget {
  const ListenerExample({super.key});

  @override
  ConsumerState<ListenerExample> createState() => _ListenerExampleState();
}

class _ListenerExampleState extends ConsumerState<ListenerExample> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      RiverpodListeners.common(
        ref: ref,
        context: context,
        provider: userProvider,
        successMessage: 'User loaded!',
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
