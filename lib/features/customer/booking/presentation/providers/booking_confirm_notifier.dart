import 'package:dat_san_247_mobile/core/base/di/injection.dart';
import 'package:dat_san_247_mobile/core/base/state/riverpod/base_notifier.dart';
import 'package:dat_san_247_mobile/features/customer/booking/data/models/booking_request.dart';
import 'package:dat_san_247_mobile/features/customer/booking/data/repositories/booking_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'booking_confirm_notifier.g.dart';

@riverpod
class BookingConfirmNotifier extends _$BookingConfirmNotifier
    with BaseNotifier<BookingResponse?> {
  late final BookingRepository _repository;

  @override
  Future<BookingResponse?> build() async {
    _repository = getIt<BookingRepository>();
    return null;
  }

  Future<void> createBooking(CreateBookingRequest request) => runResult(
        action: () => _repository.createBooking(request),
        mapper: (data) => data,
      );

  Future<void> processPayment(String bookingId, String method) => runAsync(
        action: () async {
          final res = await _repository.initiatePayment(bookingId, method);
          return res.fold(
            onSuccess: (_) => currentData,
            onFailure: (f) => throw f,
          );
        },
        successMessage: 'Thanh toán thành công',
      );

  void resetState() {
    state = const AsyncData(null);
  }
}
