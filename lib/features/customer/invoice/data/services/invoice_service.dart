import 'package:dat_san_247_mobile/core/common/constants/api_endpoints.dart';
import 'package:dat_san_247_mobile/core/data/network/api_response.dart';
import 'package:dat_san_247_mobile/features/customer/invoice/data/models/invoice_model.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'invoice_service.g.dart';

@RestApi()
@LazySingleton()
abstract class InvoiceService {
  @factoryMethod
  factory InvoiceService(Dio dio) = _InvoiceService;

  @GET(ApiEndpoints.myInvoices)
  Future<ApiResponse<List<InvoiceModel>>> getMyInvoices();
}
