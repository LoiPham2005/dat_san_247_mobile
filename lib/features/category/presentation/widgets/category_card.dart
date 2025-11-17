// // lib/features/category/presentation/widgets/category_card.dart
// import 'package:flutter/material.dart';
// import '../../domain/entities/category.dart';

// class CategoryCard extends StatelessWidget {
//   final Category category;
//   final VoidCallback? onTap;
//   final VoidCallback? onEdit;
//   final VoidCallback? onDelete;
  
//   const CategoryCard({
//     super.key,
//     required this.category,
//     this.onTap,
//     this.onEdit,
//     this.onDelete,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: const EdgeInsets.only(bottom: 12),
//       child: InkWell(
//         onTap: onTap,
//         borderRadius: BorderRadius.circular(12),
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Row(
//             children: [
//               // Image
//               ClipRRect(
//                 borderRadius: BorderRadius.circular(8),
//                 child: category.image != null
//                     ? Image.network(
//                         category.image!,
//                         width: 60,
//                         height: 60,
//                         fit: BoxFit.cover,
//                         errorBuilder: (_, __, ___) => Container(
//                           width: 60,
//                           height: 60,
//                           color: Colors.grey[300],
//                           child: const Icon(Icons.image),
//                         ),
//                       )
//                     : Container(
//                         width: 60,
//                         height: 60,
//                         color: Colors.grey[300],
//                         child: const Icon(Icons.category),
//                       ),
//               ),
//               const SizedBox(width: 16),
              
//               // Info
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       category.name,
//                       style: const TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                     if (category.description != null) ...[
//                       const SizedBox(height: 4),
//                       Text(
//                         category.description!,
//                         style: TextStyle(
//                           fontSize: 14,
//                           color: Colors.grey[600],
//                         ),
//                         maxLines: 2,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ],
//                     const SizedBox(height: 4),
//                     Text(
//                       '${category.productCount} sản phẩm',
//                       style: TextStyle(
//                         fontSize: 12,
//                         color: Colors.grey[500],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
              
//               // Actions
//               PopupMenuButton<String>(
//                 onSelected: (value) {
//                   if (value == 'edit') {
//                     onEdit?.call();
//                   } else if (value == 'delete') {
//                     onDelete?.call();
//                   }
//                 },
//                 itemBuilder: (_) => [
//                   const PopupMenuItem(
//                     value: 'edit',
//                     child: Row(
//                       children: [
//                         Icon(Icons.edit, size: 20),
//                         SizedBox(width: 8),
//                         Text('Chỉnh sửa'),
//                       ],
//                     ),
//                   ),
//                   const PopupMenuItem(
//                     value: 'delete',
//                     child: Row(
//                       children: [
//                         Icon(Icons.delete, size: 20, color: Colors.red),
//                         SizedBox(width: 8),
//                         Text('Xóa', style: TextStyle(color: Colors.red)),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

