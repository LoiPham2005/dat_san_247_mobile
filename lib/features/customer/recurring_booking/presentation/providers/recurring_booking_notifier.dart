import 'package:dat_san_247_mobile/core/base/di/injection.dart';
import 'package:dat_san_247_mobile/core/base/state/riverpod/base_notifier.dart';
import 'package:dat_san_247_mobile/features/customer/recurring_booking/data/models/recurring_booking_model.dart';
import 'package:dat_san_247_mobile/features/customer/recurring_booking/data/repositories/recurring_booking_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'recurring_booking_notifier.g.dart';

@riverpod
class RecurringBookingNotifier extends _$RecurringBookingNotifier
    with BaseNotifier<List<RecurringBookingModel>> {
  late final RecurringBookingRepository _repository;

  @override
  Future<List<RecurringBookingModel>> build() async {
    _repository = getIt<RecurringBookingRepository>();
    final result = await _repository.getMyRecurringBookings();
    return result.fold(
      onSuccess: (data) => data,
      onFailure: (f) => throw f,
    );
  }

  Future<void> refresh() => runResult(
        action: _repository.getMyRecurringBookings,
        mapper: (data) => data,
        keepPreviousOnLoading: true,
        emitEmptyForEmptyList: true,
      );

  Future<void> toggleStatus(String id, bool currentStatus) async {
    final result = await _repository.toggleRecurringBooking(id, !currentStatus);
    if (result.isSuccess) await refresh();
  }
}
