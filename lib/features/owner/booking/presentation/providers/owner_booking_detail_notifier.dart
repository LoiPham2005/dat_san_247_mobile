import 'package:dat_san_247_mobile/core/base/di/injection.dart';
import 'package:dat_san_247_mobile/core/base/state/riverpod/base_notifier.dart';
import 'package:dat_san_247_mobile/features/owner/booking/data/models/booking_models.dart';
import 'package:dat_san_247_mobile/features/owner/booking/data/repositories/owner_booking_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'owner_booking_detail_notifier.g.dart';

@riverpod
class OwnerBookingDetailNotifier extends _$OwnerBookingDetailNotifier
    with BaseNotifier<OwnerBookingModel> {
  late final OwnerBookingRepository _repository;
  late final OwnerBookingModel _initial;

  @override
  Future<OwnerBookingModel> build(OwnerBookingModel booking) async {
    _repository = getIt<OwnerBookingRepository>();
    _initial = booking;
    return booking;
  }

  Future<void> refresh() => runResult(
        action: () => _repository.getBookingDetail(_initial.id),
        mapper: (data) => data,
        keepPreviousOnLoading: true,
      );

  Future<void> updateStatus(String bookingId, String status) async {
    final result = await _repository.updateBookingStatus(bookingId, status);
    result.fold(
      onFailure: (f) {
        state = AsyncError(f, StackTrace.current);
      },
      onSuccess: (_) {
        final current = currentData;
        if (current == null) return;
        final statusEnum = BookingStatus.values.firstWhere(
          (e) => e.name == status,
          orElse: () => current.status,
        );
        state = AsyncData(current.copyWith(status: statusEnum));
      },
    );
  }
}
