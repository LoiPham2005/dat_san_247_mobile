import 'package:dat_san_247_mobile/core/base/state/bloc/base_state.dart';
import 'package:dat_san_247_mobile/core/base/state/cubit/base_cubit.dart';
import 'package:dat_san_247_mobile/features/customer/waitlist/data/models/waitlist_model.dart';
import 'package:dat_san_247_mobile/features/customer/waitlist/data/repositories/waitlist_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class WaitlistCubit extends BaseCubit<List<WaitlistModel>> {
  final WaitlistRepository _repository;

  WaitlistCubit(this._repository) : super(BaseState.initial());

  Future<void> getWaitlist() async {
    await run(action: () => _repository.getMyWaitlist());
  }

  Future<void> cancelWaitlist(String id) async {
    final result = await _repository.cancelWaitlist(id);
    result.fold(
      onSuccess: (_) {
        getWaitlist(); // Refresh list
      },
      onFailure: (f) {
        // Error is handled by BaseCubit if we use run() for initial fetch
      },
    );
  }
}
