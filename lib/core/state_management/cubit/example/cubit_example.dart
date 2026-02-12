import 'package:dat_san_247_mobile/core/errors/result.dart';
import 'package:dat_san_247_mobile/core/state_management/bloc/base_state.dart';
import 'package:dat_san_247_mobile/core/state_management/cubit/base_cubit.dart';

/// 📘 EXAMPLE: CÁCH SỬ DỤNG BASE CUBIT
class UserCubit extends BaseCubit<List<String>> {
  UserCubit() : super(BaseState.initial());

  // 1️⃣ TRUY VẤN (QUERY) - TỰ ĐỘNG
  // - Khi chưa có data: Sẽ emit trạng thái Loading.
  // - Khi đã có data: Sẽ emit trạng thái Refreshing (giữ data cũ).
  // - Khi thành công: Sẽ emit trạng thái Loaded.
  Future<void> fetchUsers() async {
    await execute(
      action: () async {
        await Future.delayed(const Duration(seconds: 1));
        return const ResultSuccess(['User 1', 'User 2']);
      },
    );
  }

  // 2️⃣ THAY ĐỔI DỮ LIỆU (MUTATION) - TỰ ĐỘNG
  // - Tự động nhận diện là Mutation vì có [successMessage].
  // - Sẽ emit trạng thái Submitting.
  // - Khi thành công: Sẽ emit trạng thái Success.
  Future<void> updateProfile(String name) async {
    await execute(
      action: () async {
        await Future.delayed(const Duration(seconds: 1));
        return const ResultSuccess(['User updated']);
      },
      successMessage: 'Cập nhật thành công!',
    );
  }

  // 3️⃣ PHÂN TRANG (PAGINATION)
  // - Sẽ emit trạng thái LoadingMore (giữ data cũ).
  Future<void> loadMore() async {
    await executePagination(
      action: () async {
        await Future.delayed(const Duration(seconds: 1));
        final newData = [...(state.data ?? []), 'User 3'];
        return ResultSuccess(newData);
      },
    );
  }

  // 4️⃣ SỬ DỤNG TRẠNG THÁI TÙY CHỈNH (CUSTOM STATUS)
  // - Người dùng có thể truyền trực tiếp state muốn emit lúc bắt đầu.
  Future<void> customExecute() async {
    await execute(
      action: () async {
        await Future.delayed(const Duration(seconds: 1));
        return const ResultSuccess(['Custom Data']);
      },
      // Truyền trực tiếp state khởi đầu mong muốn
      customLoadingState: BaseState.loading(previousData: state.data),
    );
  }
}
