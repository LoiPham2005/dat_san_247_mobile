import 'package:dat_san_247_mobile/core/errors/result.dart';
import 'package:dat_san_247_mobile/core/state_management/base_status.dart';
import 'package:dat_san_247_mobile/core/state_management/getx/base_controller.dart';

/// 📘 EXAMPLE: CÁCH SỬ DỤNG BASE CONTROLLER (GETX)
class UserXController extends BaseController<List<String>> {
  Future<void> fetchUsers() async {
    await execute(
      action: () async {
        await Future.delayed(const Duration(seconds: 1));
        return const ResultSuccess(['User 1', 'User 2']);
      },
    );
  }

  Future<void> addUser(String name) async {
    await execute(
      action: () async {
        await Future.delayed(const Duration(seconds: 1));
        return ResultSuccess(['User 1', 'User 2', name]);
      },
      successMessage: 'Thêm người dùng thành công',
    );
  }

  Future<void> fetchWithCustomStatus() async {
    await execute(
      action: () async {
        await Future.delayed(const Duration(seconds: 1));
        return const ResultSuccess(['Data']);
      },
      loadingStatus: BaseStatus.loading,
    );
  }
}
