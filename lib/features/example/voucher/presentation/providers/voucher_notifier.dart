import 'package:dat_san_247_mobile/core/base/di/dio_provider.dart';
import 'package:dat_san_247_mobile/core/base/state/riverpod/base_notifier.dart';
import 'package:dat_san_247_mobile/features/example/voucher/data/models/voucher_model.dart';
import 'package:dat_san_247_mobile/features/example/voucher/data/services/voucher_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'voucher_notifier.g.dart';

@riverpod
class VoucherNotifier extends _$VoucherNotifier
    with BaseNotifier<List<VoucherModel>> {
  late VoucherService _service;

  @override
  Future<List<VoucherModel>> build() async {
    _service = VoucherService(ref.read(dioProvider));
    return _service.getVouchers();
  }

  // ── CASE 1: Refresh giữ data cũ (overlay, không flash trắng) ──
  // keepPreviousOnLoading tự track _previousData, tự clear — không cần viết gì thêm
  Future<void> refresh() => runAsync(
    action: _service.getVouchers,
    keepPreviousOnLoading: true,
  );

  // ── CASE 2: Cancel previous (search debounce) ──
  // cancelPrevious tự tăng generation token — không cần viết token thủ công
  Future<void> search(String query) => runAsync(
    action: () => _service.searchVouchers(query),
    cancelPrevious: true,
    keepPreviousOnLoading: true,
  );

  // ── CASE 3: Apply voucher — toast tự động, lastFailure có type ──
  // successMessage → RiverpodListeners tự show toast
  // lastFailure → page check: if (notifier.lastFailure is AuthFailure) → /login
  Future<void> applyVoucher(String code) => runAsync(
    action: () async {
      final applied = await _service.applyVoucher(code);
      final list = await _service.getVouchers();
      return [applied, ...list.where((v) => v.id != applied.id)];
    },
  );

  // ── CASE 4: Optimistic delete + rollback ──
  // onError tự động rollback, không cần try/catch thủ công
  Future<void> deleteVoucher(String id) {
    final snapshot = currentData ?? [];
    state = AsyncData(snapshot.where((v) => v.id != id).toList()); // optimistic
    return runAsync(
      action: () async {
        await _service.deleteVoucher(id);
        return currentData ?? [];
      },
      errorMessage: 'Lỗi khi xóa voucher', // Sẽ hiện: "Lỗi khi xóa voucher: [Lỗi thực tế]"
      onError: (e, s) => state = AsyncData(snapshot), // rollback 1 dòng
    );
  }

  // ── CASE 5: Chain 3 bước async (load → filter → enrich) ──
  // cancelPrevious bảo vệ toàn bộ chain — không cần check token từng bước
  // runAsync throw exception nếu có lỗi → AsyncError tự động
  Future<void> loadUnused() => runAsync(
    cancelPrevious: true,
    action: () async {
      final list = await _service.getVouchers();            // bước 1: load
      final unused = list.where((v) => !v.isUsed).toList(); // bước 2: filter
      return _enrichFirst(unused);                          // bước 3: enrich
    },
  );

  Future<List<VoucherModel>> _enrichFirst(List<VoucherModel> list) async {
    if (list.isEmpty) return list;
    final detail = await _service.getVoucherDetail(list.first.id);
    return [detail, ...list.skip(1)];
  }

  // ── CASE 6: Empty state rõ ràng ──
  // emitEmptyForEmptyList → notifier.isEmpty = true
  // Page phân biệt được "đang load" vs "load xong nhưng trống"
  Future<void> load() => runAsync(
    action: _service.getVouchers,
    emitEmptyForEmptyList: true,
  );

  // ── CASE 7: Tất cả cùng lúc (refresh + cancel + empty + toast) ──
  // 5 dòng, đủ cả 4 tính năng — không bỏ sót gì
  Future<void> searchWithRefresh(String query) => runAsync(
    action: () => _service.searchVouchers(query),
    cancelPrevious: true,
    keepPreviousOnLoading: true,
    emitEmptyForEmptyList: true,
    successMessage: 'Tìm thấy kết quả!',
  );
}
