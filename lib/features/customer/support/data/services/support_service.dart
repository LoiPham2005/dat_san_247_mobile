import 'package:dat_san_247_mobile/core/common/constants/api_endpoints.dart';
import 'package:dat_san_247_mobile/core/data/network/api_response.dart';
import 'package:dat_san_247_mobile/features/customer/support/data/models/support_ticket_model.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'support_service.g.dart';

@RestApi()
@LazySingleton()
abstract class SupportService {
  @factoryMethod
  factory SupportService(Dio dio) = _SupportService;

  @GET(ApiEndpoints.supportTickets)
  Future<ApiResponse<List<SupportTicketModel>>> getMyTickets();

  @POST(ApiEndpoints.supportTickets)
  Future<ApiResponse<SupportTicketModel>> createTicket(@Body() Map<String, dynamic> data);
}
