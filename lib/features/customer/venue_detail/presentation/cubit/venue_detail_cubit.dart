import 'package:dat_san_247_mobile/core/base/state/bloc/base_state.dart';
import 'package:dat_san_247_mobile/core/base/state/cubit/base_cubit.dart';
import 'package:dat_san_247_mobile/features/customer/venue_detail/data/models/venue_detail_model.dart';
import 'package:dat_san_247_mobile/features/customer/venue_detail/data/repositories/venue_detail_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class VenueDetailCubit extends BaseCubit<VenueDetailModel> {
  final VenueDetailRepository _repository;

  VenueDetailCubit(this._repository) : super(BaseState.initial());

  Future<void> fetchVenueDetail(String slug) async {
    await run<VenueDetailModel>(
      action: () => _repository.getVenueDetail(slug),
    );
  }

  Future<void> toggleFavorite(String venueId) async {
    final result = await _repository.toggleFavorite(venueId);
    if (result.isSuccess) {
      final isFavorite = result.dataOrNull ?? false;
      state.whenSuccess(
        (model, message) {
          emit(BaseState.success(
            data: model.copyWith(isFavorite: isFavorite),
            message: isFavorite ? 'Đã thêm vào yêu thích' : 'Đã xóa khỏi yêu thích',
          ));
        },
      );
    }
  }
}
