import 'package:dat_san_247_mobile/core/common/constants/api_endpoints.dart';
import 'package:dat_san_247_mobile/core/data/network/api_response.dart';
import 'package:dat_san_247_mobile/features/owner/review/data/models/owner_review_model.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'owner_review_service.g.dart';

@RestApi()
@LazySingleton()
abstract class OwnerReviewService {
  @factoryMethod
  factory OwnerReviewService(Dio dio) = _OwnerReviewService;

  @GET(ApiEndpoints.ownerReviews)
  Future<ApiResponse<List<OwnerReviewModel>>> getOwnerReviews(@Query('venue_id') String? venueId);

  @PATCH(ApiEndpoints.ownerReplyReview)
  Future<ApiResponse<OwnerReviewModel>> replyReview(
    @Path('id') String reviewId,
    @Body() Map<String, dynamic> data,
  );
}
