import 'package:dat_san_247_mobile/core/base/errors/result.dart';
import 'package:dat_san_247_mobile/core/common/mixins/api_handler_mixin.dart';
import 'package:dat_san_247_mobile/features/customer/promotions/data/models/promotion_model.dart';
import 'package:dat_san_247_mobile/features/customer/promotions/data/models/user_voucher_model.dart';
import 'package:dat_san_247_mobile/features/customer/promotions/data/services/promotion_service.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class PromotionRepository with ApiHandlerMixin {
  final PromotionService _service;

  PromotionRepository(this._service);

  Future<Result<List<PromotionModel>>> getPromotions({int? page, int? limit}) {
    return safeCallUnwrap(() => _service.getPromotions(page: page, limit: limit));
  }

  Future<Result<List<UserVoucherModel>>> getMyVouchers() {
    return safeCallUnwrap(() => _service.getMyVouchers());
  }

  Future<Result<void>> collectPromotion(String id) {
    return safeCallUnwrap(() => _service.collectPromotion(id));
  }
}
