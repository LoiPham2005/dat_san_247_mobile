// // lib/features/category/presentation/pages/category_detail_page.dart
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../../../core/state_management/bloc/data_bloc/data_event.dart';
// import '../../../../core/state_management/bloc/data_bloc/data_state.dart';
// import '../../domain/entities/category.dart';
// import '../bloc/category_bloc.dart';

// class CategoryDetailPage extends StatefulWidget {
//   final String categoryId;
  
//   const CategoryDetailPage({
//     super.key,
//     required this.categoryId,
//   });

//   @override
//   State<CategoryDetailPage> createState() => _CategoryDetailPageState();
// }

// class _CategoryDetailPageState extends State<CategoryDetailPage> {
//   @override
//   void initState() {
//     super.initState();
//     context.read<CategoryBloc>().add(
//       FetchDataDetailEvent<Category>(id: widget.categoryId),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Chi tiết danh mục'),
//       ),
//       body: BlocBuilder<CategoryBloc, DataState<Category>>(
//         builder: (context, state) {
//           if (state is DataLoading<Category>) {
//             return const Center(child: CircularProgressIndicator());
//           }
          
//           if (state is DataDetailLoaded<Category>) {
//             final category = state.data;
//             return SingleChildScrollView(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   if (category.image != null)
//                     ClipRRect(
//                       borderRadius: BorderRadius.circular(12),
//                       child: Image.network(
//                         category.image!,
//                         width: double.infinity,
//                         height: 200,
//                         fit: BoxFit.cover,
//                         errorBuilder: (_, __, ___) => Container(
//                           height: 200,
//                           color: Colors.grey[300],
//                           child: const Icon(Icons.image, size: 64),
//                         ),
//                       ),
//                     ),
//                   const SizedBox(height: 24),
//                   Text(
//                     category.name,
//                     style: const TextStyle(
//                       fontSize: 24,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   if (category.description != null)
//                     Text(
//                       category.description!,
//                       style: TextStyle(
//                         fontSize: 16,
//                         color: Colors.grey[600],
//                       ),
//                     ),
//                   const SizedBox(height: 24),
//                   _buildInfoRow('Số sản phẩm', category.productCount.toString()),
//                   _buildInfoRow(
//                     'Ngày tạo',
//                     '${category.createdAt.day}/${category.createdAt.month}/${category.createdAt.year}',
//                   ),
//                 ],
//               ),
//             );
//           }
          
//           if (state is DataError<Category>) {
//             return Center(
//               child: Text(
//                 state.message,
//                 style: const TextStyle(color: Colors.red),
//               ),
//             );
//           }
          
//           return const SizedBox.shrink();
//         },
//       ),
//     );
//   }
  
//   Widget _buildInfoRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             label,
//             style: const TextStyle(
//               fontSize: 14,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//           Text(
//             value,
//             style: TextStyle(
//               fontSize: 14,
//               color: Colors.grey[600],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

