import 'package:dat_san_247_mobile/core/base/di/injection.dart';
import 'package:dat_san_247_mobile/core/base/state/riverpod/base_notifier.dart';
import 'package:dat_san_247_mobile/features/customer/booking/data/repositories/booking_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'payment_notifier.g.dart';

@riverpod
class PaymentNotifier extends _$PaymentNotifier with BaseNotifier<String?> {
  late final BookingRepository _repository;

  @override
  Future<String?> build() async {
    _repository = getIt<BookingRepository>();
    return null;
  }

  /// Tạo URL thanh toán gateway (VNPAY/MOMO/ZALOPAY)
  Future<void> createPaymentUrl(String method, String bookingCode) =>
      runResult(
        action: () => _repository.createGatewayPaymentUrl(method, bookingCode),
        mapper: (url) => url,
      );

  /// Polling trạng thái thanh toán — không cập nhật state, chỉ trả về.
  Future<String?> pollPaymentStatus(String bookingCode) async {
    final result = await _repository.getPaymentStatus(bookingCode);
    return result.fold(
      onSuccess: (status) => status,
      onFailure: (_) => null,
    );
  }
}
