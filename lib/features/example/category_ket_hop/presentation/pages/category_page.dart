// // ════════════════════════════════════════════════════════════════
// // 📁 lib/features/category/presentation/pages/category_page.dart
// // ════════════════════════════════════════════════════════════════
// import 'package:flutter/material.dart';
// import 'package:dat_san_247_mobile/core/di/injection.dart';
// import 'package:dat_san_247_mobile/core/state_management/bloc/base_state.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// import '../bloc/category_bloc.dart';
// import '../bloc/category_event.dart';
// import '../widgets/category_card.dart';

// class CategoryPage extends StatelessWidget {
//   const CategoryPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (_) => getIt<CategoryBloc>()..add(const LoadCategories()),
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
//             icon: const Icon(Icons.refresh),
//             onPressed: () {
//               context.read<CategoryBloc>().add(const LoadCategories(refresh: true));
//             },
//           ),
//         ],
//       ),
//       body: BlocConsumer<CategoryBloc, BaseState>(
//         listener: (context, state) {
//           if (state.isFailure && state.hasError) {
//             ScaffoldMessenger.of(
//               context,
//             ).showSnackBar(SnackBar(content: Text(state.error!), backgroundColor: Colors.red));
//           }
//           if (state.isSuccess && state.message != null) {
//             ScaffoldMessenger.of(
//               context,
//             ).showSnackBar(SnackBar(content: Text(state.message!), backgroundColor: Colors.green));
//             context.read<CategoryBloc>().add(const LoadCategories(refresh: true));
//           }
//         },
//         builder: (context, state) {
//           if (state.isLoading) return const Center(child: CircularProgressIndicator());

//           if (state.isEmpty) {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(Icons.inbox, size: 64, color: Colors.grey[400]),
//                   const SizedBox(height: 16),
//                   Text(
//                     state.displayMessage,
//                     style: TextStyle(fontSize: 16, color: Colors.grey[600]),
//                   ),
//                   const SizedBox(height: 16),
//                   ElevatedButton.icon(
//                     onPressed: () =>
//                         context.read<CategoryBloc>().add(const LoadCategories(refresh: true)),
//                     icon: const Icon(Icons.refresh),
//                     label: const Text('Thử lại'),
//                   ),
//                 ],
//               ),
//             );
//           }

//           if (state.hasData && state.data is List<CategoryModel>) {
//             final categories = state.data as List<CategoryModel>;
//             return RefreshIndicator(
//               onRefresh: () async {
//                 context.read<CategoryBloc>().add(const LoadCategories(refresh: true));
//               },
//               child: SizedBox()
//               // Stack(
//               //   children: [
//               //     ListView.builder(
//               //       padding: const EdgeInsets.all(16),
//               //       itemCount: categories.length,
//               //       itemBuilder: (context, index) {
//               //         final category = categories[index];
//               //         return CategoryCard(
//               //           category: category,
//               //           onTap: () {},
//               //           onEdit: () {},
//               //           onDelete: () {},
//               //         );
//               //       },
//               //     ),
//               //     if (state.isRefreshing)
//               //       const Positioned(top: 0, left: 0, right: 0, child: LinearProgressIndicator()),
//               //   ],
//               // ),
//             );
//           }

//           return const SizedBox.shrink();
//         },
//       ),
//     );
//   }
// }
