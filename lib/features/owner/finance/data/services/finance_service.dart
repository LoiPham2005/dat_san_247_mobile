import 'package:dat_san_247_mobile/core/common/constants/api_endpoints.dart';
import 'package:dat_san_247_mobile/core/data/network/api_response.dart';
import 'package:dat_san_247_mobile/features/owner/finance/data/models/finance_models.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'finance_service.g.dart';

@RestApi()
@LazySingleton()
abstract class FinanceService {
  @factoryMethod
  factory FinanceService(Dio dio) = _FinanceService;

  @GET(ApiEndpoints.ownerWallet)
  Future<ApiResponse<WalletModel>> getWallet();

  @GET(ApiEndpoints.ownerBankAccounts)
  Future<ApiResponse<List<BankAccountModel>>> getBankAccounts();

  @POST(ApiEndpoints.ownerBankAccounts)
  Future<ApiResponse<BankAccountModel>> addBankAccount(@Body() Map<String, dynamic> data);

  @DELETE('${ApiEndpoints.ownerBankAccounts}/{id}')
  Future<ApiResponse<dynamic>> deleteBankAccount(@Path('id') String id);

  @GET(ApiEndpoints.ownerPayouts)
  Future<ApiResponse<List<PayoutRequestModel>>> getPayoutRequests();

  @POST(ApiEndpoints.ownerPayouts)
  Future<ApiResponse<PayoutRequestModel>> createPayoutRequest(@Body() Map<String, dynamic> data);

  @GET(ApiEndpoints.ownerFinanceStats)
  Future<ApiResponse<FinanceStatsModel>> getFinanceStats(@Query('venue_id') String? venueId);

  @GET(ApiEndpoints.ownerCommissions)
  Future<ApiResponse<List<CommissionRecordModel>>> getCommissions(@Query('venue_id') String? venueId);
}
