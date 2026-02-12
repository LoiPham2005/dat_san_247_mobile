// ════════════════════════════════════════════════════════════════
// 📁 lib/features/category/presentation/widgets/category_detail_page.dart
// ════════════════════════════════════════════════════════════════
import 'package:flutter/material.dart';
import 'package:dat_san_247_mobile/core/state_management/bloc/base_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/category_model.dart';
import '../bloc/category_bloc.dart';

class CategoryDetailPage extends StatelessWidget {
  final String categoryId;

  const CategoryDetailPage({super.key, required this.categoryId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chi tiết danh mục')),
      body: BlocBuilder<CategoryBloc, BaseState>(
        builder: (context, state) {
          if (state.isLoading) return const Center(child: CircularProgressIndicator());

          if (state.hasData && state.data is CategoryModel) {
            final category = state.data as CategoryModel;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (category.iconUrl != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        category.iconUrl!,
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                  const SizedBox(height: 24),
                  Text(
                    category.categoryName,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  if (category.description != null)
                    Text(
                      category.description!,
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                  const SizedBox(height: 24),
                  _buildRow('Trạng thái', category.status),
                  _buildRow('Thứ tự', category.displayOrder.toString()),
                  _buildRow('Ngày tạo', category.createdAt.toString()),
                ],
              ),
            );
          }

          return const Center(child: Text('Không tìm thấy dữ liệu'));
        },
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          Text(value, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
