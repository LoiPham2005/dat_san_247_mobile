import 'package:dat_san_247_mobile/core/base/state/bloc/base_state.dart';
import 'package:dat_san_247_mobile/core/base/state/cubit/base_cubit.dart';
import 'package:dat_san_247_mobile/features/customer/recurring_booking/data/models/recurring_booking_model.dart';
import 'package:dat_san_247_mobile/features/customer/recurring_booking/data/repositories/recurring_booking_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class RecurringBookingCubit extends BaseCubit<List<RecurringBookingModel>> {
  final RecurringBookingRepository _repository;

  RecurringBookingCubit(this._repository) : super(BaseState.initial());

  Future<void> getBookings() async {
    await run(
      action: () => _repository.getMyRecurringBookings(),
    );
  }

  Future<void> toggleStatus(String id, bool currentStatus) async {
    final result = await _repository.toggleRecurringBooking(id, !currentStatus);
    if (result.isSuccess) {
      // Refresh list after toggle
      await getBookings();
    }
  }
}
