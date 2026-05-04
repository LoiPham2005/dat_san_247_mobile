import 'package:dat_san_247_mobile/core/base/di/injection.dart';
import 'package:dat_san_247_mobile/core/base/state/riverpod/base_notifier.dart';
import 'package:dat_san_247_mobile/features/customer/booking/data/models/booking_request.dart';
import 'package:dat_san_247_mobile/features/customer/booking/data/repositories/booking_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'booking_detail_notifier.g.dart';

@riverpod
class BookingDetailNotifier extends _$BookingDetailNotifier
    with BaseNotifier<BookingResponse> {
  late final BookingRepository _repository;
  late final String _bookingId;

  @override
  Future<BookingResponse> build(String id) async {
    _repository = getIt<BookingRepository>();
    _bookingId = id;
    final result = await _repository.getBookingDetail(id);
    return result.fold(
      onSuccess: (data) => data,
      onFailure: (f) => throw f,
    );
  }

  Future<void> refresh() => runResult(
        action: () => _repository.getBookingDetail(_bookingId),
        mapper: (data) => data,
        keepPreviousOnLoading: true,
      );

  Future<void> cancelBooking(String reason) => runResult(
        action: () async {
          final cancelRes = await _repository.cancelBooking(_bookingId, reason);
          return cancelRes.fold(
            onSuccess: (_) => _repository.getBookingDetail(_bookingId),
            onFailure: (f) async => throw f,
          );
        },
        mapper: (data) => data,
        successMessage: 'Hủy đặt sân thành công',
      );
}
