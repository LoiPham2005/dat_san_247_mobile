import 'package:dat_san_247_mobile/core/base/state/bloc/base_state.dart';
import 'package:dat_san_247_mobile/core/base/state/cubit/base_cubit.dart';
import 'package:dat_san_247_mobile/features/owner/venue/data/models/venue_models.dart';
import 'package:dat_san_247_mobile/features/owner/venue/data/repositories/venue_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class OwnerVenueDetailCubit extends BaseCubit<OwnerVenueModel> {
  final OwnerVenueRepository _repository;

  OwnerVenueDetailCubit(this._repository) : super(BaseState.initial());

  Future<void> fetchVenueDetail(String venueId) async {
    emit(BaseState.loading(previousData: state.data));
    final result = await _repository.getVenueDetail(venueId);
    
    if (isClosed) return;

    result.fold(
      onSuccess: (venue) => emit(BaseState.success(data: venue)),
      onFailure: (failure) => emit(BaseState.failure(
        error: failure.message,
        previousData: state.data,
      )),
    );
  }

  Future<void> refresh(String venueId) => fetchVenueDetail(venueId);

  Future<void> updateVenue(String id, Map<String, dynamic> data) async {
    emit(BaseState.loading(previousData: state.data));
    final result = await _repository.updateVenue(id, data);
    
    if (isClosed) return;

    result.fold(
      onSuccess: (venue) => emit(BaseState.success(data: venue)),
      onFailure: (failure) => emit(BaseState.failure(
        error: failure.message,
        previousData: state.data,
      )),
    );
  }
}
