// ════════════════════════════════════════════════════════════════
// 📁 category_toi_uu/presentation/pages/category_page.dart
// ════════════════════════════════════════════════════════════════
import 'package:dat_san_247_mobile/core/di/injection.dart';
import 'package:dat_san_247_mobile/core/state_management/bloc/base_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/category_entity.dart';
import '../bloc/category_bloc.dart';
import '../bloc/category_event.dart';
import '../widgets/category_card.dart';

/// 🎯 CategoryPage — Entry point
///
/// Tạo BlocProvider ở đây, inject Bloc từ GetIt.
class CategoryPage extends StatelessWidget {
  const CategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<CategoryBloc>()..add(const LoadCategories()),
      child: const _CategoryView(),
    );
  }
}

/// CategoryView — UI chính
class _CategoryView extends StatelessWidget {
  const _CategoryView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh mục'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<CategoryBloc>().add(const LoadCategories(refresh: true));
            },
          ),
        ],
      ),
      body: BlocConsumer<CategoryBloc, BaseState>(
        listener: (context, state) {
          // ❌ Hiển thị lỗi
          if (state.isFailure && state.hasError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.error!), backgroundColor: Colors.red));
          }
          // ✅ Hiển thị thành công (sau mutation)
          if (state.isSuccess && state.message != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message!), backgroundColor: Colors.green));
          }
        },
        builder: (context, state) {
          // 🔄 Loading
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // 📭 Empty
          if (state.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inbox, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    state.displayMessage,
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () =>
                        context.read<CategoryBloc>().add(const LoadCategories(refresh: true)),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Thử lại'),
                  ),
                ],
              ),
            );
          }

          // 📋 Data loaded — Nhận List<CategoryEntity>
          if (state.hasData && state.data is List<CategoryEntity>) {
            final categories = state.data as List<CategoryEntity>;
            return RefreshIndicator(
              onRefresh: () async {
                context.read<CategoryBloc>().add(const LoadCategories(refresh: true));
              },
              child: Stack(
                children: [
                  ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      return CategoryCard(
                        category: category,
                        onTap: () {
                          // Navigate to detail page
                        },
                        onEdit: () {
                          // Navigate to edit page
                        },
                        onDelete: () {
                          context.read<CategoryBloc>().add(
                            DeleteCategory(category.categoryId.toString()),
                          );
                        },
                      );
                    },
                  ),
                  // Hiển thị loading indicator khi refreshing
                  if (state.isRefreshing)
                    const Positioned(top: 0, left: 0, right: 0, child: LinearProgressIndicator()),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
