import 'package:dat_san_247_mobile/core/errors/result.dart';
import 'package:dat_san_247_mobile/core/state_management/base_status.dart';
import 'package:dat_san_247_mobile/core/state_management/getx/base_controller.dart';

/// 📘 EXAMPLE: CÁCH SỬ DỤNG BASE CONTROLLER (GETX)
class UserXController extends BaseController<List<String>> {
  // 1️⃣ TRUY VẤN (QUERY)
  Future<void> fetchUsers() async {
    await execute(
      action: () async {
        await Future.delayed(const Duration(seconds: 1));
        return ResultSuccess(['User 1', 'User 2']);
      },
      // Tự động emit loading/refreshing
    );
  }

  // 2️⃣ THAY ĐỔI DỮ LIỆU (MUTATION)
  Future<void> addUser(String name) async {
    await execute(
      action: () async {
        await Future.delayed(const Duration(seconds: 1));
        return ResultSuccess(['User 1', 'User 2', name]);
      },
      successMessage: 'Thêm người dùng thành công', // Nhận diện tự động
    );
  }

  // 3️⃣ TRẠNG THÁI TÙY CHỈNH (CUSTOM STATUS)
  Future<void> fetchWithCustomStatus() async {
    await execute(
      action: () async {
        await Future.delayed(const Duration(seconds: 1));
        return ResultSuccess(['Data']);
      },
      // Có thể ép buộc status bất kỳ lúc bắt đầu
      customStatus: BaseStatus.submitting,
    );
  }
}
