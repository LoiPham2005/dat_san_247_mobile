import 'package:dat_san_247_mobile/core/base/state/bloc/base_state.dart';
import 'package:dat_san_247_mobile/core/base/state/cubit/base_cubit.dart';
import 'package:dat_san_247_mobile/features/customer/favorite/data/models/favorite_venue_model.dart';
import 'package:dat_san_247_mobile/features/customer/favorite/data/repositories/favorite_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class FavoriteCubit extends BaseCubit<List<FavoriteVenueModel>> {
  final FavoriteRepository _repository;

  FavoriteCubit(this._repository) : super(BaseState.initial());

  Future<void> getFavorites() async {
    await run<List<FavoriteVenueModel>>(
      action: () => _repository.getFavorites(),
    );
  }

  Future<void> toggleFavorite(String venueId) async {
    final result = await _repository.toggleFavorite(venueId);
    if (result.isSuccess) {
      // Sau khi toggle thành công, ta tải lại danh sách để cập nhật UI
      await getFavorites();
    }
  }

  /// Xóa nhanh một item khỏi state local trước khi gọi API (Optimistic UI) 
  /// hoặc chỉ đơn giản là xóa khỏi list hiện tại sau khi confirm
  void removeLocal(String venueId) {
    if (state.isSuccess && state.data != null) {
      final currentList = List<FavoriteVenueModel>.from(state.data!);
      currentList.removeWhere((item) => item.venueId == venueId);
      emit(state.copyWith(data: currentList));
    }
  }
}
