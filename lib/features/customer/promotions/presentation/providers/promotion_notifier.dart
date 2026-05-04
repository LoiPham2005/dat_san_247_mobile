import 'package:dat_san_247_mobile/core/base/di/injection.dart';
import 'package:dat_san_247_mobile/core/base/state/riverpod/base_notifier.dart';
import 'package:dat_san_247_mobile/features/customer/promotions/data/models/promotion_model.dart';
import 'package:dat_san_247_mobile/features/customer/promotions/data/models/user_voucher_model.dart';
import 'package:dat_san_247_mobile/features/customer/promotions/data/repositories/promotion_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'promotion_notifier.g.dart';

class PromotionData {
  final List<PromotionModel> promotions;
  final List<UserVoucherModel> myVouchers;

  const PromotionData({
    this.promotions = const [],
    this.myVouchers = const [],
  });
}

@riverpod
class PromotionNotifier extends _$PromotionNotifier
    with BaseNotifier<PromotionData> {
  late final PromotionRepository _repository;

  @override
  Future<PromotionData> build() async {
    _repository = getIt<PromotionRepository>();
    return _fetchAll();
  }

  Future<PromotionData> _fetchAll() async {
    final promoResult = await _repository.getPromotions(page: 1, limit: 50);
    final voucherResult = await _repository.getMyVouchers();

    final promotions = promoResult.fold(
      onSuccess: (p) => p,
      onFailure: (f) => throw f,
    );
    final vouchers = voucherResult.fold(
      onSuccess: (v) => v,
      onFailure: (f) => throw f,
    );
    return PromotionData(promotions: promotions, myVouchers: vouchers);
  }

  Future<void> refresh() => runAsync(
        action: _fetchAll,
        keepPreviousOnLoading: true,
      );

  Future<void> collectPromotion(String id) async {
    final result = await _repository.collectPromotion(id);
    if (result.isSuccess) await refresh();
  }
}
