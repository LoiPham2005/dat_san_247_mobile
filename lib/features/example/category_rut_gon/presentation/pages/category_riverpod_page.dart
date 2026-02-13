// ════════════════════════════════════════════════════════════════
// 📁 lib/features/category_rut_gon/presentation/pages/category_riverpod_page.dart
// ════════════════════════════════════════════════════════════════
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/state_management/riverpod/riverpod_listeners.dart';
import '../riverpod/category_riverpod.dart';
import '../widgets/category_card.dart';

class CategoryRiverpodPage extends ConsumerStatefulWidget {
  const CategoryRiverpodPage({super.key});

  @override
  ConsumerState<CategoryRiverpodPage> createState() => _CategoryRiverpodPageState();
}

class _CategoryRiverpodPageState extends ConsumerState<CategoryRiverpodPage> {
  @override
  void initState() {
    super.initState();
    // Khởi tạo fetch data khi vào page
    Future.microtask(() => ref.read(categoryRutGonProvider.notifier).loadCategories());
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(categoryRutGonProvider);
    final notifier = ref.read(categoryRutGonProvider.notifier);

    // Lắng nghe sự thay đổi message (thành công/thất bại) từ BaseAsyncNotifier
    RiverpodListeners.common(ref: ref, context: context, provider: categoryRutGonProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh mục (Riverpod)'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: () => notifier.loadCategories()),
        ],
      ),
      body: state.when(
        data: (categories) {
          if (categories.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inbox, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  const Text('Không có dữ liệu', style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => notifier.loadCategories(),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Thử lại'),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async => notifier.loadCategories(),
            child: Stack(
              children: [
                ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    return CategoryCard(category: category, onTap: () {});
                  },
                ),
                if (notifier.isLoading)
                  const Positioned(top: 0, left: 0, right: 0, child: LinearProgressIndicator()),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 64),
              const SizedBox(height: 16),
              Text(error.toString()),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => notifier.loadCategories(),
                child: const Text('Thử lại'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
