import 'package:dat_san_247_mobile/core/common/mixins/api_handler_mixin.dart';
import 'package:dat_san_247_mobile/core/base/errors/result.dart';
import 'package:dat_san_247_mobile/features/customer/invoice/data/models/invoice_model.dart';
import 'package:dat_san_247_mobile/features/customer/invoice/data/services/invoice_service.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class InvoiceRepository with ApiHandlerMixin {
  final InvoiceService _service;

  InvoiceRepository(this._service);

  Future<Result<List<InvoiceModel>>> getMyInvoices() {
    return safeCallUnwrap(() => _service.getMyInvoices());
  }
}
