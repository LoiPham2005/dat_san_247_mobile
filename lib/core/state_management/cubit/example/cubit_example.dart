import 'package:dat_san_247_mobile/core/errors/result.dart';
import 'package:dat_san_247_mobile/core/state_management/bloc/base_state.dart';
import 'package:dat_san_247_mobile/core/state_management/cubit/base_cubit.dart';

/// 📘 EXAMPLE: CÁCH SỬ DỤNG BASE CUBIT MỚI
class UserCubit extends BaseCubit<List<String>> {
  UserCubit() : super(BaseState.initial());

  Future<void> fetchUsers() async {
    await execute(
      action: () async {
        await Future.delayed(const Duration(seconds: 1));
        return const ResultSuccess(['User 1', 'User 2']);
      },
    );
  }

  Future<void> updateProfile(String name) async {
    await execute(
      action: () async {
        await Future.delayed(const Duration(seconds: 1));
        return const ResultSuccess(['User updated']);
      },
      successMessage: 'Cập nhật thành công!',
    );
  }

  Future<void> loadMore() async {
    await executePagination(
      action: () async {
        await Future.delayed(const Duration(seconds: 1));
        final current = state.data ?? [];
        return ResultSuccess([...current, 'User ${current.length + 1}']);
      },
    );
  }
}
