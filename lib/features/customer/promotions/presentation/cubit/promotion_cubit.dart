import 'package:dat_san_247_mobile/core/base/errors/failures.dart';
import 'package:dat_san_247_mobile/core/base/state/base_status.dart';
import 'package:dat_san_247_mobile/core/base/state/bloc/base_state.dart';
import 'package:dat_san_247_mobile/core/base/state/cubit/base_cubit.dart';
import 'package:dat_san_247_mobile/features/customer/promotions/data/models/promotion_model.dart';
import 'package:dat_san_247_mobile/features/customer/promotions/data/models/user_voucher_model.dart';
import 'package:dat_san_247_mobile/features/customer/promotions/data/repositories/promotion_repository.dart';
import 'package:injectable/injectable.dart';

class PromotionData {
  final List<PromotionModel> promotions;
  final List<UserVoucherModel> myVouchers;

  PromotionData({this.promotions = const [], this.myVouchers = const []});
}

@injectable
class PromotionCubit extends BaseCubit<PromotionData> {
  final PromotionRepository _repository;

  PromotionCubit(this._repository) : super(BaseState.initial());

  Future<void> fetchAll() async {
    emit(BaseState.loading(previousData: state.data));
    final promoResult = await _repository.getPromotions(page: 1, limit: 50);
    final voucherResult = await _repository.getMyVouchers();

    promoResult.fold(
      onSuccess: (promos) {
        voucherResult.fold(
          onSuccess: (vouchers) {
            emit(BaseState.success(data: PromotionData(promotions: promos, myVouchers: vouchers)));
          },
          onFailure: (f) {
            emit(BaseState.failure(error: f.userMessage));
          },
        );
      },
      onFailure: (f) {
        emit(BaseState.failure(error: f.userMessage));
      },
    );
  }

  Future<void> collectPromotion(String id) async {
    final result = await _repository.collectPromotion(id);
    result.fold(
      onSuccess: (_) {
        fetchAll(); // Refresh both lists
      },
      onFailure: (f) {
        // Handle failure if needed, maybe toast
      },
    );
  }
}
