import 'package:dat_san_247_mobile/core/errors/result.dart';
import 'package:dat_san_247_mobile/core/state_management/base_status.dart';
import 'package:dat_san_247_mobile/core/state_management/providers/base_provider.dart';

/// 📘 EXAMPLE: CÁCH SỬ DỤNG BASE PROVIDER
class UserProvider extends BaseProvider<List<String>> {
  // 1️⃣ TRUY VẤN (QUERY)
  Future<void> fetchUsers() async {
    await execute(
      action: () async {
        await Future.delayed(const Duration(seconds: 1));
        return const ResultSuccess(['User 1', 'User 2']);
      },
    );
  }

  // 2️⃣ THAY ĐỔI DỮ LIỆU (MUTATION)
  Future<void> saveUser(String name) async {
    await execute(
      action: () async {
        await Future.delayed(const Duration(seconds: 1));
        return ResultSuccess(['Saved $name']);
      },
      successMessage: 'Lưu thành công',
    );
  }

  // 3️⃣ TRẠNG THÁI TÙY CHỈNH (CUSTOM STATUS)
  Future<void> customExecute() async {
    await execute(
      action: () async {
        await Future.delayed(const Duration(seconds: 1));
        return const ResultSuccess(['Custom']);
      },
      // Ưu tiên sử dụng status truyền vào thay vì tự động detect
      customStatus: BaseStatus.submitting,
    );
  }
}
