import 'package:dat_san_247_mobile/core/common/constants/api_endpoints.dart';
import 'package:dat_san_247_mobile/core/data/network/api_response.dart';
import 'package:dat_san_247_mobile/features/owner/staff/data/models/staff_models.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'staff_service.g.dart';

@RestApi()
@LazySingleton()
abstract class OwnerStaffService {
  @factoryMethod
  factory OwnerStaffService(Dio dio) = _OwnerStaffService;

  @GET(ApiEndpoints.ownerStaff)
  Future<ApiResponse<List<OwnerStaffModel>>> getStaff(@Path('venueId') String venueId);

  @POST(ApiEndpoints.ownerStaffInvite)
  Future<ApiResponse<StaffInviteModel>> inviteStaff(@Body() Map<String, dynamic> data);

  @GET(ApiEndpoints.ownerStaffInvites)
  Future<ApiResponse<List<StaffInviteModel>>> getInvites(@Path('venueId') String venueId);

  @PATCH(ApiEndpoints.ownerStaffStatus)
  Future<ApiResponse<OwnerStaffModel>> updateStaffStatus(
    @Path('staffId') String staffId,
    @Body() Map<String, dynamic> data,
  );

  @DELETE(ApiEndpoints.ownerStaffInviteAction)
  Future<ApiResponse<dynamic>> revokeInvite(@Path('inviteId') String inviteId);
  
  @POST('${ApiEndpoints.ownerStaffInviteAction}/force-accept')
  Future<ApiResponse<OwnerStaffModel>> forceAcceptInvite(@Path('inviteId') String inviteId);
}
