import 'package:dat_san_247_mobile/core/base/state/bloc/base_state.dart';
import 'package:dat_san_247_mobile/core/base/state/cubit/base_cubit.dart';
import 'package:dat_san_247_mobile/features/customer/booking/data/models/booking_request.dart';
import 'package:dat_san_247_mobile/features/customer/booking/data/repositories/booking_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class MyBookingsCubit extends BaseCubit<List<BookingResponse>> {
  final BookingRepository _repository;

  MyBookingsCubit(this._repository) : super(BaseState.initial());

  Future<void> getMyBookings() async {
    safeEmit(BaseState.loading());
    
    final result = await _repository.getMyBookings();
    
    result.fold(
      onSuccess: (data) => safeEmit(BaseState.success(data: data)),
      onFailure: (failure) => safeEmit(BaseState.failure(error: failure.message)),
    );
  }
}
