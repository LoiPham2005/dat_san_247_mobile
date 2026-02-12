import 'dart:async';

import 'package:dat_san_247_mobile/core/errors/result.dart';
import 'package:dat_san_247_mobile/core/state_management/riverpod/base_async_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 📘 EXAMPLE: CÁCH SỬ DỤNG BASE ASYNC NOTIFIER (RIVERPOD)
class UserNotifier extends BaseAsyncNotifier<List<String>> {
  @override
  FutureOr<List<String>> build() {
    return [];
  }

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
  Future<void> updateUser(String name) async {
    await execute(
      action: () async {
        await Future.delayed(const Duration(seconds: 1));
        return ResultSuccess(['Updated $name']);
      },
      successMessage: 'Cập nhật thành công',
    );
  }

  // 3️⃣ TRẠNG THÁI TÙY CHỈNH (CUSTOM STATUS)
  Future<void> customExecute() async {
    await execute(
      action: () async {
        await Future.delayed(const Duration(seconds: 1));
        return const ResultSuccess(['Custom']);
      },
      // Truyền trực tiếp AsyncValue khởi đầu
      customLoadingState: const AsyncLoading<List<String>>().copyWithPrevious(
        AsyncData(state.value ?? []),
      ),
    );
  }
}
