import 'package:dat_san_247_mobile/core/common/constants/api_endpoints.dart';
import 'package:dat_san_247_mobile/features/owner/venue/data/models/venue_models.dart';
import 'package:dat_san_247_mobile/core/data/network/api_response.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'dart:io';

part 'venue_service.g.dart';

@RestApi()
@LazySingleton()
abstract class OwnerVenueService {
  @factoryMethod
  factory OwnerVenueService(Dio dio) = _OwnerVenueService;

  /// 🏟️ Get all venues owned by me
  @GET(ApiEndpoints.ownerVenues)
  Future<ApiResponse<List<OwnerVenueModel>>> getOwnerVenues();

  /// 🏟️ Get venue detail
  @GET(ApiEndpoints.ownerVenueDetail)
  Future<ApiResponse<OwnerVenueModel>> getVenueDetail(@Path('id') String id);

  /// 📝 Create a new venue
  @POST(ApiEndpoints.ownerVenues)
  Future<ApiResponse<OwnerVenueModel>> createVenue(@Body() Map<String, dynamic> data);

  /// 📝 Update venue info
  @PATCH(ApiEndpoints.ownerVenueDetail)
  Future<ApiResponse<OwnerVenueModel>> updateVenue(@Path('id') String id, @Body() Map<String, dynamic> data);

  /// 🎾 Get courts for a venue
  @GET(ApiEndpoints.ownerCourts)
  Future<ApiResponse<List<OwnerCourtModel>>> getVenueCourts(@Path('vId') String vId);

  /// 🎾 Create a new court
  @POST(ApiEndpoints.ownerCourts)
  Future<ApiResponse<OwnerCourtModel>> createCourt(@Path('vId') String vId, @Body() Map<String, dynamic> data);

  /// 🎾 Delete a court
  @DELETE('${ApiEndpoints.ownerCourts}/{courtId}')
  Future<ApiResponse<void>> deleteCourt(@Path('vId') String vId, @Path('courtId') String courtId);

  /// 🏷️ Get pricing rules for a court
  @GET(ApiEndpoints.ownerPricingRules)
  Future<ApiResponse<List<OwnerPricingRuleModel>>> getCourtPricingRules(@Path('cId') String cId);

  /// ✨ Set pricing rules
  @POST(ApiEndpoints.ownerPricingRules)
  Future<ApiResponse<dynamic>> updatePricingRules(@Path('cId') String cId, @Body() Map<String, dynamic> data);

  /// 🛠️ Get services for a venue
  @GET(ApiEndpoints.ownerVenueServices)
  Future<ApiResponse<List<VenueServiceModel>>> getVenueServices(@Path('vId') String vId);

  @POST(ApiEndpoints.ownerVenueServices)
  Future<ApiResponse<VenueServiceModel>> addVenueService(@Path('vId') String vId, @Body() Map<String, dynamic> data);

  @PATCH('${ApiEndpoints.ownerVenueServices}/{serviceId}')
  Future<ApiResponse<VenueServiceModel>> updateVenueService(@Path('vId') String vId, @Path('serviceId') String serviceId, @Body() Map<String, dynamic> data);

  @DELETE('${ApiEndpoints.ownerVenueServices}/{serviceId}')
  Future<ApiResponse<dynamic>> deleteVenueService(@Path('vId') String vId, @Path('serviceId') String serviceId);

  /// 🛡️ Get refund policy
  @GET(ApiEndpoints.ownerRefundPolicies)
  Future<ApiResponse<RefundPolicyModel>> getRefundPolicy(@Path('vId') String vId);
  
  @GET(ApiEndpoints.ownerAmenities)
  Future<ApiResponse<List<AmenityModel>>> getVenueAmenities(@Path('vId') String vId);

  @POST(ApiEndpoints.ownerAmenities)
  Future<ApiResponse<AmenityModel>> addVenueAmenity(@Path('vId') String vId, @Body() Map<String, dynamic> data);

  @DELETE('${ApiEndpoints.ownerAmenities}/{amenityId}')
  Future<ApiResponse<dynamic>> deleteVenueAmenity(@Path('vId') String vId, @Path('amenityId') String amenityId);

  @PATCH('${ApiEndpoints.ownerAmenities}/{amenityId}')
  Future<ApiResponse<AmenityModel>> updateVenueAmenity(@Path('vId') String vId, @Path('amenityId') String amenityId, @Body() Map<String, dynamic> data);

  @GET(ApiEndpoints.ownerOperatingHours)
  Future<ApiResponse<List<VenueOperatingHoursModel>>> getOperatingHours(@Path('vId') String vId);

  @PATCH(ApiEndpoints.ownerOperatingHours)
  Future<ApiResponse<dynamic>> updateOperatingHours(@Path('vId') String vId, @Body() Map<String, dynamic> data);

  /// 📅 Get schedule exceptions
  @GET(ApiEndpoints.ownerExceptions)
  Future<ApiResponse<List<VenueScheduleExceptionModel>>> getScheduleExceptions(@Path('vId') String vId);

  @POST(ApiEndpoints.ownerExceptions)
  Future<ApiResponse<VenueScheduleExceptionModel>> createScheduleException(@Path('vId') String vId, @Body() Map<String, dynamic> data);

  @DELETE('${ApiEndpoints.ownerExceptions}/{exceptionId}')
  Future<ApiResponse<void>> deleteScheduleException(@Path('vId') String vId, @Path('exceptionId') String exceptionId);

  /// 🖼️ Get media attachments
  @GET(ApiEndpoints.ownerMedia)
  Future<ApiResponse<List<MediaAttachmentModel>>> getMediaAttachments(@Path('vId') String vId);

  @POST(ApiEndpoints.ownerMedia)
  Future<ApiResponse<MediaAttachmentModel>> createMediaAttachment(@Path('vId') String vId, @Body() Map<String, dynamic> data);

  @DELETE('${ApiEndpoints.ownerMedia}/{mediaId}')
  Future<ApiResponse<void>> deleteMediaAttachment(@Path('vId') String vId, @Path('mediaId') String mediaId);

  @POST('${ApiEndpoints.ownerVenues}/upload')
  @MultiPart()
  Future<ApiResponse<VenueUploadResponse>> uploadFile(@Part(name: 'file') File file);

  @PATCH('${ApiEndpoints.ownerMedia}/{mediaId}/cover')
  Future<ApiResponse<MediaAttachmentModel>> setCoverMedia(@Path('vId') String vId, @Path('mediaId') String mediaId);

  @GET(ApiEndpoints.ownerVerification)
  Future<ApiResponse<VenueVerificationModel>> getVerification(@Path('vId') String vId);

  @POST(ApiEndpoints.ownerVerification)
  Future<ApiResponse<VenueVerificationModel>> submitVerification(@Path('vId') String vId, @Body() Map<String, dynamic> data);
}
