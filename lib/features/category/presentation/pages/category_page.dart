// // lib/features/category/presentation/pages/category_page.dart
// import 'package:flutter/material.dart';
// import 'package:flutter_base_template/features/category/presentation/widgets/category_card.dart';
// import 'package:flutter_base_template/features/category/presentation/widgets/category_detail_page.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../../../core/state_management/bloc/data_bloc/data_event.dart';
// import '../../../../core/state_management/bloc/data_bloc/data_state.dart';
// import '../../../../core/di/injection.dart';
// import '../../domain/entities/category.dart';
// import '../bloc/category_bloc.dart';

// class CategoryPage extends StatelessWidget {
//   const CategoryPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (_) => getIt<CategoryBloc>()
//         ..add(const FetchDataListEvent<Category>()),
//       child: const CategoryView(),
//     );
//   }
// }

// class CategoryView extends StatelessWidget {
//   const CategoryView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Danh mục'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.search),
//             onPressed: () => _showSearchDialog(context),
//           ),
//           IconButton(
//             icon: const Icon(Icons.refresh),
//             onPressed: () {
//               context.read<CategoryBloc>().add(
//                 const FetchDataListEvent<Category>(refresh: true),
//               );
//             },
//           ),
//         ],
//       ),
//       body: BlocConsumer<CategoryBloc, DataState<Category>>(
//         listener: (context, state) {
//           if (state is DataError<Category>) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text(state.message),
//                 backgroundColor: Colors.red,
//               ),
//             );
//           } else if (state is DataOperationSuccess<Category>) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text(state.message),
//                 backgroundColor: Colors.green,
//               ),
//             );
//             // Reload list after operation
//             context.read<CategoryBloc>().add(
//                FetchDataListEvent<Category>(refresh: true),
//             );
//           }
//         },
//         builder: (context, state) {
//           if (state is DataLoading<Category>) {
//             return const Center(child: CircularProgressIndicator());
//           }
          
//           if (state is DataEmpty<Category>) {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const Icon(Icons.inbox, size: 64, color: Colors.grey),
//                   const SizedBox(height: 16),
//                   Text(
//                     state.message,
//                     style: const TextStyle(color: Colors.grey),
//                   ),
//                 ],
//               ),
//             );
//           }
          
//           if (state is DataListLoaded<Category>) {
//             return RefreshIndicator(
//               onRefresh: () async {
//                 context.read<CategoryBloc>().add(
//                   const FetchDataListEvent<Category>(refresh: true),
//                 );
//               },
//               child: ListView.builder(
//                 padding: const EdgeInsets.all(16),
//                 itemCount: state.data.length,
//                 itemBuilder: (context, index) {
//                   final category = state.data[index];
//                   return CategoryCard(
//                     category: category,
//                     onTap: () => _navigateToDetail(context, category),
//                     onEdit: () => _showEditDialog(context, category),
//                     onDelete: () => _confirmDelete(context, category),
//                   );
//                 },
//               ),
//             );
//           }
          
//           return const SizedBox.shrink();
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () => _showCreateDialog(context),
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
  
//   void _navigateToDetail(BuildContext context, Category category) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (_) => BlocProvider.value(
//           value: context.read<CategoryBloc>(),
//           child: CategoryDetailPage(categoryId: category.id),
//         ),
//       ),
//     );
//   }
  
//   void _showSearchDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: const Text('Tìm kiếm'),
//         content: TextField(
//           decoration: const InputDecoration(hintText: 'Nhập từ khóa...'),
//           onSubmitted: (query) {
//             Navigator.pop(context);
//             context.read<CategoryBloc>().add(
//               SearchDataEvent<Category>(query: query),
//             );
//           },
//         ),
//       ),
//     );
//   }
  
//   void _showCreateDialog(BuildContext context) {
//     final nameController = TextEditingController();
//     final descController = TextEditingController();
    
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: const Text('Tạo danh mục mới'),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             TextField(
//               controller: nameController,
//               decoration: const InputDecoration(labelText: 'Tên danh mục'),
//             ),
//             const SizedBox(height: 16),
//             TextField(
//               controller: descController,
//               decoration: const InputDecoration(labelText: 'Mô tả'),
//               maxLines: 3,
//             ),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Hủy'),
//           ),
//           TextButton(
//             onPressed: () {
//               if (nameController.text.isNotEmpty) {
//                 context.read<CategoryBloc>().add(
//                   CreateDataEvent<Category>({
//                     'name': nameController.text,
//                     'description': descController.text,
//                   }),
//                 );
//                 Navigator.pop(context);
//               }
//             },
//             child: const Text('Tạo'),
//           ),
//         ],
//       ),
//     );
//   }
  
//   void _showEditDialog(BuildContext context, Category category) {
//     final nameController = TextEditingController(text: category.name);
//     final descController = TextEditingController(text: category.description);
    
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: const Text('Chỉnh sửa danh mục'),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             TextField(
//               controller: nameController,
//               decoration: const InputDecoration(labelText: 'Tên danh mục'),
//             ),
//             const SizedBox(height: 16),
//             TextField(
//               controller: descController,
//               decoration: const InputDecoration(labelText: 'Mô tả'),
//               maxLines: 3,
//             ),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Hủy'),
//           ),
//           TextButton(
//             onPressed: () {
//               context.read<CategoryBloc>().add(
//                 UpdateDataEvent<Category>(
//                   id: category.id,
//                   data: {
//                     'name': nameController.text,
//                     'description': descController.text,
//                   },
//                 ),
//               );
//               Navigator.pop(context);
//             },
//             child: const Text('Cập nhật'),
//           ),
//         ],
//       ),
//     );
//   }
  
//   void _confirmDelete(BuildContext context, Category category) {
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: const Text('Xác nhận xóa'),
//         content: Text('Bạn có chắc muốn xóa "${category.name}"?'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Hủy'),
//           ),
//           TextButton(
//             onPressed: () {
//               context.read<CategoryBloc>().add(
//                 DeleteDataEvent<Category>(category.id),
//               );
//               Navigator.pop(context);
//             },
//             style: TextButton.styleFrom(foregroundColor: Colors.red),
//             child: const Text('Xóa'),
//           ),
//         ],
//       ),
//     );
//   }
// }

