import 'package:dat_san_247_mobile/core/base/state/bloc/base_state.dart';
import 'package:dat_san_247_mobile/core/base/state/cubit/base_cubit.dart';
import 'package:dat_san_247_mobile/features/customer/booking/data/models/booking_request.dart';
import 'package:dat_san_247_mobile/features/customer/booking/data/repositories/booking_repository.dart';
import 'package:dat_san_247_mobile/core/services/manager/toast_service.dart';
import 'package:injectable/injectable.dart';

@injectable
class BookingDetailCubit extends BaseCubit<BookingResponse> {
  final BookingRepository _repository;

  BookingDetailCubit(this._repository) : super(BaseState.initial());

  Future<void> getBookingDetail(String id) async {
    safeEmit(BaseState.loading());
    
    final result = await _repository.getBookingDetail(id);
    
    result.fold(
      onSuccess: (data) => safeEmit(BaseState.success(data: data)),
      onFailure: (failure) => safeEmit(BaseState.failure(error: failure.message)),
    );
  }
  Future<void> cancelBooking(String id, String reason) async {
    // We keep current data and just show loading if needed, 
    // or we can use a separate state if we want to distinguish.
    // For now, let's just emit loading and then success/failure.
    
    final result = await _repository.cancelBooking(id, reason);
    
    result.fold(
      onSuccess: (_) {
        // After cancellation, we might want to refresh details 
        // to show the updated CANCELLED status.
        getBookingDetail(id);
        emit(BaseState.success(data: state.data, message: 'Hủy đặt sân thành công'));
      },
      onFailure: (failure) => toast.error(failure.message),
    );
  }
}
