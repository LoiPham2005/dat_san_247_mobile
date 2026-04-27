import 'package:dat_san_247_mobile/core/base/state/bloc/base_state.dart';
import 'package:dat_san_247_mobile/core/base/state/cubit/base_cubit.dart';
import 'package:dat_san_247_mobile/features/customer/booking/data/repositories/booking_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class PaymentCubit extends BaseCubit<String> {
  final BookingRepository _repository;

  PaymentCubit(this._repository) : super(BaseState.initial());

  /// Gọi backend tạo URL thanh toán gateway (VNPAY/MOMO/ZALOPAY)
  Future<void> createPaymentUrl(String method, String bookingCode) async {
    safeEmit(BaseState.loading());
    final result = await _repository.createGatewayPaymentUrl(method, bookingCode);
    result.fold(
      onSuccess: (url) => safeEmit(BaseState.success(data: url)),
      onFailure: (failure) => safeEmit(BaseState.failure(error: failure.message)),
    );
  }

  /// Kiểm tra trạng thái thanh toán sau khi user quay lại app
  Future<String?> pollPaymentStatus(String bookingCode) async {
    final result = await _repository.getPaymentStatus(bookingCode);
    return result.fold(
      onSuccess: (status) => status,
      onFailure: (_) => null,
    );
  }
}
