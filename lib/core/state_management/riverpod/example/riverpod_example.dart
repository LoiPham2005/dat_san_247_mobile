import 'dart:async';

import 'package:dat_san_247_mobile/core/errors/result.dart';
import 'package:dat_san_247_mobile/core/state_management/riverpod/base_async_notifier.dart';

/// 📘 EXAMPLE: CÁCH SỬ DỤNG BASE ASYNC NOTIFIER (RIVERPOD)
class UserNotifier extends BaseAsyncNotifier<List<String>> {
  @override
  FutureOr<List<String>> build() {
    return [];
  }

  Future<void> fetchUsers() async {
    await execute(
      action: () async {
        await Future.delayed(const Duration(seconds: 1));
        return const ResultSuccess(['User 1', 'User 2']);
      },
    );
  }

  Future<void> updateUser(String name) async {
    await execute(
      action: () async {
        await Future.delayed(const Duration(seconds: 1));
        return ResultSuccess(['Updated $name']);
      },
      successMessage: 'Cập nhật thành công',
    );
  }
}
