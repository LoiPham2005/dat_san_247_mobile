// import 'package:get/get.dart';
// import 'package:snakeup_app/core/getx/base_controller.dart';
// import 'package:snakeup_app/features/product/data/models/product_model.dart';
// import 'package:snakeup_app/features/size2/data/models/size2_model.dart';
// import 'package:snakeup_app/features/size2/data/repository/size2_repository.dart';

// class Size2Controller extends BaseController {
//   final size2List = <SizeModel>[].obs;

//   final Size2Repository repo = Size2Repository();

//   // final Size2Repository repo;
//   // Size2Controller({Size2Repository? repository})
//   //     : repo = repository ?? Size2Repository();

//   @override
//   void onInit() {
//     super.onInit();
//     fetchSize2();
//   }

//   /// Lấy danh sách size2
//   Future<void> fetchSize2() async {
//     await performAction(
//       action: () => repo.getSizes(),
//       // Không cần mergeList vì data đã là List<SizeModel>
//       targetList: size2List,
//     );
//   }

//   /// Thêm size2
//   Future<void> addSize2(SizeModel size) async {
//     await performAction(
//       action: () => repo.addSize(size),
//       // Đơn giản nhất: thêm vào list hiện tại
//       onSuccess: (added) {
//         size2List.add(added);
//         size2List.refresh();
//       },
//       // Nếu bạn muốn chắc chắn đồng bộ với server:
//       // onSuccess: (_) => fetchSize2(),
//       showLoading: false,
//     );
//   }

//   /// Cập nhật size2
//   Future<void> updateSize2(SizeModel size) async {
//     await performAction(
//       action: () => repo.updateSize(size),
//       onSuccess: (updated) {
//         final idx = size2List.indexWhere((e) => e.id == updated.id);
//         if (idx != -1) {
//           size2List[idx] = updated;
//         } else {
//           size2List.add(updated); // phòng trường hợp chưa có trong list
//         }
//         size2List.refresh();
//       },
//       // Hoặc thay bằng: onSuccess: (_) => fetchSize2(),
//     );
//   }

//   /// Xoá size2
//   Future<void> deleteSize2(String id) async {
//     await performAction(
//       action: () => repo.deleteSize(id),
//       onSuccess: (_) {
//         size2List.removeWhere((e) => e.id == id);
//         size2List.refresh();
//       },
//       // Hoặc: onSuccess: (_) => fetchSize2(),
//       showLoading: true,
//     );
//   }
// }
