import 'package:get/get.dart';
import 'package:dat_san_247_mobile/core/config/app/repository_helper/base_response.dart';

class BaseController extends GetxController {
  final isLoading = false.obs;

  void showLoading() => isLoading.value = true;
  void hideLoading() => isLoading.value = false;

  void showError(String message) {
    Get.snackbar('Lỗi', message);
  }

  /// action: hàm gọi repo, trả về BaseResponse<TData>
  /// targetList: danh sách Rx muốn đồng bộ (tuỳ chọn)
  /// mergeList: cách trộn current + newData => list mới (tuỳ chọn)
  /// onSuccess: callback khi thành công, nhận data từ response (tuỳ chọn)
  Future<void> performAction<TData, TItem>({
    required Future<BaseResponse<TData>> Function() action,
    RxList<TItem>? targetList,
    List<TItem> Function(List<TItem> current, TData newData)? mergeList,
    void Function(TData data)? onSuccess,
    bool showLoading = true,
  }) async {
    try {
      if (showLoading) this.showLoading();
      final res = await action();
      if (showLoading) this.hideLoading();

      if (res.isSuccess) {
        final data = res.data;

          // In message server trả về
        if (res.message != null) {
          print("Server message: ${res.message}");
        }
        
        if (targetList != null && data != null) {
          if (mergeList != null) {
            final updated = mergeList(targetList.toList(), data);
            targetList.assignAll(updated);
          } else if (data is List<TItem>) {
            targetList.assignAll(data);
          }
          // nếu data không phải List<TItem> thì để onSuccess xử lý
        }

        if (onSuccess != null && data != null) onSuccess(data);
      } else {
        showError(res.message ?? 'Có lỗi xảy ra');
      }

      print("Base_controller dataaaaaaaaaaaaaaaaaa: ${res.data}");
    } catch (e) {
      if (showLoading) this.hideLoading();
      showError(e.toString());
    }
  }

  Future<void> fetchList<T>({
    required Future<BaseResponse<List<T>>> Function() action,
    required RxList<T> targetList,
  }) async {
    await performAction<List<T>, T>(
      action: action,
      targetList: targetList,
    );
  }

  Future<void> refreshList<T>({
    required Future<BaseResponse<List<T>>> Function() action,
    required RxList<T> targetList,
  }) async {
    await fetchList<T>(action: action, targetList: targetList);
  }

  Future<void> fetchDetail<T>({
    required Future<BaseResponse<T>> Function() action,
    required Rxn<T> targetObject,
  }) async {
    try {
      final response = await action();
      if (response.data != null) {
        targetObject.value = response.data;
      } else {
        targetObject.value = null;
      }
    } catch (e) {
      targetObject.value = null;
      rethrow; // nếu muốn bắn lỗi ra ngoài
    }
  }

  Future<void> addItem<T>({
    required Future<BaseResponse<T>> Function() action,
    required RxList<T> targetList,
  }) async {
    await performAction<T, T>(
      action: action,
      onSuccess: (added) {
        targetList.add(added);
        targetList.refresh();
      },
      showLoading: false,
    );
  }

  Future<void> updateItem<T>({
    required Future<BaseResponse<T>> Function() action,
    required RxList<T> targetList,
    required bool Function(T item, T updated) matcher,
  }) async {
    await performAction<T, T>(
      action: action,
      onSuccess: (updated) {
        final idx = targetList.indexWhere((e) => matcher(e, updated));
        if (idx != -1) {
          targetList[idx] = updated;
        } else {
          targetList.add(updated);
        }
        targetList.refresh();
      },
    );
  }

  Future<void> deleteItem<T>({
    required Future<BaseResponse<dynamic>> Function() action,
    required RxList<T> targetList,
    required bool Function(T item) matcher,
    void Function()? onSuccess,
  }) async {
    await performAction<dynamic, T>(
      action: action,
      onSuccess: (_) {
        targetList.removeWhere(matcher);
        targetList.refresh();
        if (onSuccess != null) onSuccess();
      },
    );
  }

  Future<void> searchItems<T>({
    required Future<BaseResponse<List<T>>> Function(String keyword) action,
    required RxList<T> targetList,
    required String keyword,
  }) async {
    try {
      final response = await action(keyword);
      if (response.data != null) {
        targetList.assignAll(response.data!);
      } else {
        targetList.clear();
      }
    } catch (e) {
      print("Lỗi khi search: $e");
      targetList.clear();
    }
  }

  // mẫu
  //   Future<void> fetchSize2() async {
  //   await fetchList<SizeModel>(
  //     action: () => repo.getSizes(),
  //     targetList: size2List,
  //   );
  // }

// Future<void> addSize2(SizeModel size) async {
//   await addItem<SizeModel>(
//     action: () => repo.addSize(size),
//     targetList: size2List,
//   );
// }

// Future<void> updateSize2(SizeModel size) async {
//   await updateItem<SizeModel>(
//     action: () => repo.updateSize(size),
//     targetList: size2List,
//     matcher: (a, b) => a.id == b.id,
//   );
// }

// Future<void> deleteSize2(String id) async {
//   await deleteItem<SizeModel>(
//     action: () => repo.deleteSize(id),
//     targetList: size2List,
//     matcher: (e) => e.id == id,
//   );
// }
}
