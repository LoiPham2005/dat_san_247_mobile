import 'package:dat_san_247_mobile/core/base/state/base_status.dart';
import 'package:dat_san_247_mobile/core/base/state/bloc/base_state.dart';
import 'package:dat_san_247_mobile/core/base/state/cubit/base_cubit.dart';
import 'package:dat_san_247_mobile/features/owner/review/data/models/owner_review_model.dart';
import 'package:dat_san_247_mobile/features/owner/review/data/repositories/owner_review_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'owner_review_cubit.freezed.dart';

@freezed
abstract class OwnerReviewState with _$OwnerReviewState {
  const factory OwnerReviewState({
    @Default([]) List<OwnerReviewModel> reviews,
    String? currentVenueId,
  }) = _OwnerReviewState;
}

@injectable
class OwnerReviewCubit extends BaseCubit<OwnerReviewState> {
  final OwnerReviewRepository _repository;
  OwnerReviewCubit(this._repository) : super(BaseState(status: BaseStatus.initial, data: const OwnerReviewState()));

  Future<void> fetchReviews({String? venueId}) async {
    emit(BaseState.loading(previousData: state.data));
    final res = await _repository.getOwnerReviews(venueId);
    res.fold(
      onFailure: (err) => emit(BaseState.failure(error: err.message, previousData: state.data)),
      onSuccess: (data) => emit(BaseState.success(data: state.data?.copyWith(reviews: data, currentVenueId: venueId))),
    );
  }

  Future<void> replyReview(String reviewId, String comment) async {
    final res = await _repository.replyReview(reviewId, comment);
    res.fold(
      onFailure: (err) => emit(BaseState.failure(error: err.message, previousData: state.data)),
      onSuccess: (updatedReview) {
        final List<OwnerReviewModel> currentReviews = [...(state.data?.reviews ?? [])];
        final idx = currentReviews.indexWhere((r) => r.id == reviewId);
        if (idx != -1) {
          // Merge thông tin mới (phản hồi) vào cái cũ đang có đầy đủ info khách hàng
          currentReviews[idx] = currentReviews[idx].copyWith(
            response: updatedReview.response,
            respondedAt: updatedReview.respondedAt,
          );
          emit(BaseState.success(data: state.data?.copyWith(reviews: currentReviews)));
        }
      },
    );
  }
}
