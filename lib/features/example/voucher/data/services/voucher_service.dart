import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/voucher_model.dart';

part 'voucher_service.g.dart';

@RestApi()
abstract class VoucherService {
  factory VoucherService(Dio dio, {String baseUrl}) = _VoucherService;

  @GET('/vouchers')
  Future<List<VoucherModel>> getVouchers();

  @GET('/vouchers/search')
  Future<List<VoucherModel>> searchVouchers(@Query('q') String query);

  @GET('/vouchers/{id}')
  Future<VoucherModel> getVoucherDetail(@Path('id') String id);

  @DELETE('/vouchers/{id}')
  Future<void> deleteVoucher(@Path('id') String id);

  @POST('/vouchers/apply/{code}')
  Future<VoucherModel> applyVoucher(@Path('code') String code);
}
