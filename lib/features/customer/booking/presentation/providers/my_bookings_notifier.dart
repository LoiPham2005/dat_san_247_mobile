import 'package:dat_san_247_mobile/core/base/di/injection.dart';
import 'package:dat_san_247_mobile/core/base/state/riverpod/base_notifier.dart';
import 'package:dat_san_247_mobile/features/customer/booking/data/models/booking_request.dart';
import 'package:dat_san_247_mobile/features/customer/booking/data/repositories/booking_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'my_bookings_notifier.g.dart';

@riverpod
class MyBookingsNotifier extends _$MyBookingsNotifier
    with BaseNotifier<List<BookingResponse>> {
  late final BookingRepository _repository;

  @override
  Future<List<BookingResponse>> build() async {
    _repository = getIt<BookingRepository>();
    final result = await _repository.getMyBookings();
    return result.fold(
      onSuccess: (data) => data,
      onFailure: (f) => throw f,
    );
  }

  Future<void> refresh() => runResult(
        action: _repository.getMyBookings,
        mapper: (data) => data,
        keepPreviousOnLoading: true,
        emitEmptyForEmptyList: true,
      );
}
