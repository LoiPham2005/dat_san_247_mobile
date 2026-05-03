import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../../core/base/di/dio_provider.dart';
import '../../data/models/voucher_model.dart';
import '../../data/services/voucher_service.dart';

part 'voucher_provider_goc.g.dart';

@riverpod
class VoucherNotifier extends _$VoucherNotifier {
  late VoucherService _service;

  // Tự track generation token để cancel request cũ
  int _generation = 0;

  // Tự track previous data để làm refresh overlay
  List<VoucherModel>? _previousData;
  bool get isRefreshing => state.isLoading && _previousData != null;

  @override
  Future<List<VoucherModel>> build() async {
    _service = VoucherService(ref.read(dioProvider));
    return _service.getVouchers();
  }

  // ── CASE 1: Refresh giữ data cũ (overlay, không flash trắng) ──
  // Phải tự track _previousData, tự clear ở mọi nhánh (success + error)
  Future<void> refresh() async {
    _previousData = state.asData?.value;
    state = const AsyncLoading();
    try {
      state = AsyncData(await _service.getVouchers());
    } catch (e, s) {
      state = AsyncError(e, s);
    } finally {
      _previousData = null;
    }
  }

  // ── CASE 2: Cancel previous (search debounce) ──
  // Phải tự viết generation token, check sau MỖI await
  Future<void> search(String query) async {
    _generation++;
    final token = _generation;
    _previousData = state.asData?.value;
    state = const AsyncLoading();
    try {
      final result = await _service.searchVouchers(query);
      if (_generation != token) return; // đã bị cancel
      _previousData = null;
      state = AsyncData(result);
    } catch (e, s) {
      if (_generation != token) return;
      _previousData = null;
      state = AsyncError(e, s);
    }
  }

  // ── CASE 3: Apply voucher — toast? không có, lỗi chỉ là Object ──
  // Muốn toast phải listen ở page rồi tự check state change
  // Muốn biết AuthFailure hay NetworkFailure phải cast state.asError?.error
  Future<void> applyVoucher(String code) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final applied = await _service.applyVoucher(code);
      final list = await _service.getVouchers();
      return [applied, ...list.where((v) => v.id != applied.id)];
    });
  }

  // ── CASE 4: Optimistic delete + rollback ──
  // Phải tự giữ snapshot, tự rollback trong catch, toast lỗi ở đâu?
  Future<void> deleteVoucher(int id) async {
    final snapshot = state.asData?.value ?? [];
    state = AsyncData(snapshot.where((v) => v.id != id).toList()); // optimistic
    try {
      await _service.deleteVoucher(id as String);
    } catch (_) {
      state = AsyncData(snapshot); // rollback thủ công
      // phải tự show error ở đây hoặc re-throw rồi page catch
    }
  }

  // ── CASE 5: Chain 3 bước async (load → filter → enrich) ──
  // Generation token phải check SAU MỖI await, dễ quên 1 chỗ → race condition
  Future<void> loadActive() async {
    _generation++;
    final token = _generation;
    state = const AsyncLoading();
    try {
      final list = await _service.getVouchers();
      if (_generation != token) return;

      final unused = list.where((v) => !v.isUsed).toList();

      List<VoucherModel> enriched = unused;
      if (unused.isNotEmpty) {
        final detail = await _service.getVoucherDetail(unused.first.id);
        if (_generation != token) return; // phải check lại
        enriched = [detail, ...unused.skip(1)];
      }
      _previousData = null;
      state = AsyncData(enriched);
    } catch (e, s) {
      if (_generation != token) return;
      _previousData = null;
      state = AsyncError(e, s);
    }
  }

  // ── CASE 6: Empty state ──
  // Check isEmpty trong UI, không phân biệt "chưa search" vs "search ra 0 kết quả"
  // Phải viết: AsyncData(:final value) => value.isEmpty ? EmptyWidget() : List()
  Future<void> loadEmpty() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _service.getVouchers());
    // UI không biết lý do empty — "chưa có voucher" hay "search không ra"?
  }

  // ── CASE 7: Tất cả cùng lúc (refresh + cancel + empty) ──
  // ~20 dòng boilerplate, dễ bỏ sót 1 trong các check
  Future<void> searchWithRefresh(String query) async {
    _generation++;
    final token = _generation;
    _previousData = state.asData?.value;
    state = const AsyncLoading();
    try {
      final result = await _service.searchVouchers(query);
      if (_generation != token) return;
      _previousData = null;
      // empty? check ở page, không có flag rõ ràng
      state = AsyncData(result);
    } catch (e, s) {
      if (_generation != token) return;
      _previousData = null;
      state = AsyncError(e, s);
      // toast? không có — page phải tự listen
    }
  }
}
