import 'package:dat_san_247_mobile/core/base/state/bloc/base_state.dart';
import 'package:dat_san_247_mobile/core/base/state/cubit/base_cubit.dart';
import 'package:dat_san_247_mobile/features/owner/booking/data/models/booking_models.dart';
import 'package:dat_san_247_mobile/features/owner/booking/data/repositories/owner_booking_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class OwnerBookingDetailCubit extends BaseCubit<OwnerBookingModel> {
  final OwnerBookingRepository _repository;

  OwnerBookingDetailCubit(this._repository) : super(BaseState.initial());

  void init(OwnerBookingModel booking) {
    safeEmit(BaseState.success(data: booking));
  }

  Future<void> fetchBookingDetail(String id) async {
    await run<OwnerBookingModel>(
      action: () => _repository.getBookingDetail(id),
    );
  }

  Future<void> updateStatus(String bookingId, String status) async {
    final result = await _repository.updateBookingStatus(bookingId, status);
    result.fold(
      onFailure: (failure) => safeEmit(
        BaseState.failure(error: failure.message, previousData: state.data),
      ),
      onSuccess: (r) {
        if (state.data != null) {
          final statusEnum = BookingStatus.values.firstWhere(
            (e) => e.name == status,
            orElse: () => state.data!.status,
          );
          safeEmit(BaseState.success(
            data: state.data!.copyWith(status: statusEnum),
            message: 'Cập nhật trạng thái thành công',
          ));
        }
      },
    );
  }
}
