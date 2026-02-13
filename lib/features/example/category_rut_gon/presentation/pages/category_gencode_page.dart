// ════════════════════════════════════════════════════════════════
// 📁 lib/features/category_rut_gon/presentation/pages/category_gencode_page.dart
// ════════════════════════════════════════════════════════════════
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../riverpod/category_riverpod_gencode.dart';
import '../widgets/category_card.dart';

class CategoryGencodePage extends ConsumerStatefulWidget {
  const CategoryGencodePage({super.key});

  @override
  ConsumerState<CategoryGencodePage> createState() => _CategoryGencodePageState();
}

class _CategoryGencodePageState extends ConsumerState<CategoryGencodePage> {
  @override
  void initState() {
    super.initState();
    // Khởi tạo fetch data khi vào page
    Future.microtask(() => ref.read(categoryRutGonGencodeProvider.notifier).loadCategories());
  }

  @override
  Widget build(BuildContext context) {
    // Watch state từ generator provider
    final state = ref.watch(categoryRutGonGencodeProvider);
    final notifier = ref.read(categoryRutGonGencodeProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh mục (Riverpod Gencode)'),
        elevation: 2,
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
                  Icon(Icons.category_outlined, size: 80, color: Colors.grey[300]),
                  const SizedBox(height: 16),
                  const Text(
                    'Không có danh mục nào',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => notifier.loadCategories(),
                    child: const Text('Tải lại dữ liệu'),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async => notifier.loadCategories(),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return CategoryCard(
                  category: category,
                  onTap: () {
                    // Xử lý khi nhấn vào category
                  },
                );
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 60),
              const SizedBox(height: 16),
              Text('Lỗi: ${error.toString()}'),
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
