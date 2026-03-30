import 'package:dat_san_247_mobile/core/base/errors/result.dart';
import 'package:dat_san_247_mobile/core/common/mixins/api_handler_mixin.dart';
import 'package:dat_san_247_mobile/features/owner/review/data/models/owner_review_model.dart';
import 'package:dat_san_247_mobile/features/owner/review/data/services/owner_review_service.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class OwnerReviewRepository with ApiHandlerMixin {
  final OwnerReviewService _service;
  OwnerReviewRepository(this._service);

  Future<Result<List<OwnerReviewModel>>> getOwnerReviews([String? venueId]) {
    return safeCallUnwrap(() => _service.getOwnerReviews(venueId));
  }

  Future<Result<OwnerReviewModel>> replyReview(String reviewId, String replyComment) {
    return safeCallUnwrap(() => _service.replyReview(reviewId, {
      'reply_comment': replyComment,
    }));
  }
}
