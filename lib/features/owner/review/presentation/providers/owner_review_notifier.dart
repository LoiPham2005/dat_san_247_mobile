import 'package:dat_san_247_mobile/core/base/di/injection.dart';
import 'package:dat_san_247_mobile/core/base/state/riverpod/base_notifier.dart';
import 'package:dat_san_247_mobile/features/owner/review/data/models/owner_review_model.dart';
import 'package:dat_san_247_mobile/features/owner/review/data/repositories/owner_review_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'owner_review_notifier.g.dart';

@riverpod
class OwnerReviewNotifier extends _$OwnerReviewNotifier
    with BaseNotifier<List<OwnerReviewModel>> {
  late final OwnerReviewRepository _repository;
  String? _venueId;

  @override
  Future<List<OwnerReviewModel>> build(String? venueId) async {
    _repository = getIt<OwnerReviewRepository>();
    _venueId = venueId;
    final result = await _repository.getOwnerReviews(venueId);
    return result.fold(
      onSuccess: (data) => data,
      onFailure: (f) => throw f,
    );
  }

  Future<void> refresh() => runResult(
        action: () => _repository.getOwnerReviews(_venueId),
        mapper: (data) => data,
        keepPreviousOnLoading: true,
        emitEmptyForEmptyList: true,
      );

  Future<void> replyReview(String reviewId, String comment) async {
    final res = await _repository.replyReview(reviewId, comment);
    res.fold(
      onFailure: (_) {},
      onSuccess: (updated) {
        final current = currentData;
        if (current == null) return;
        final list = [...current];
        final idx = list.indexWhere((r) => r.id == reviewId);
        if (idx != -1) {
          list[idx] = list[idx].copyWith(
            response: updated.response,
            respondedAt: updated.respondedAt,
          );
          state = AsyncData(list);
        }
      },
    );
  }
}
