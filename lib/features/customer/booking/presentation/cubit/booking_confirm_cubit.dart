import 'package:dat_san_247_mobile/core/base/state/bloc/base_state.dart';
import 'package:dat_san_247_mobile/core/base/state/cubit/base_cubit.dart';
import 'package:dat_san_247_mobile/features/customer/booking/data/models/booking_request.dart';
import 'package:dat_san_247_mobile/features/customer/booking/data/repositories/booking_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class BookingConfirmCubit extends BaseCubit<BookingResponse> {
  final BookingRepository _repository;

  BookingConfirmCubit(this._repository) : super(BaseState.initial());

  Future<void> createBooking(CreateBookingRequest request) async {
    safeEmit(BaseState.loading());
    
    final result = await _repository.createBooking(request);
    
    result.fold(
      onSuccess: (data) => safeEmit(BaseState.success(data: data)),
      onFailure: (failure) => safeEmit(BaseState.failure(error: failure.message)),
    );
  }

  Future<void> processPayment(String bookingId, String method) async {
    safeEmit(BaseState.loading());
    
    final result = await _repository.initiatePayment(bookingId, method);
    
    result.fold(
      onSuccess: (data) {
        // Handle payment gateway or direct success
        // For now, we assume simple success or URL return
        safeEmit(BaseState.success(message: 'Thanh toán thành công'));
      },
      onFailure: (failure) => safeEmit(BaseState.failure(error: failure.message)),
    );
  }
}
