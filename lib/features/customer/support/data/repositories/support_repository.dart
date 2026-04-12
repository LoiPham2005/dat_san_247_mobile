import 'package:dat_san_247_mobile/core/base/errors/result.dart';
import 'package:dat_san_247_mobile/core/common/mixins/api_handler_mixin.dart';
import 'package:dat_san_247_mobile/features/customer/support/data/models/support_ticket_model.dart';
import 'package:dat_san_247_mobile/features/customer/support/data/services/support_service.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class SupportRepository with ApiHandlerMixin {
  final SupportService _service;

  SupportRepository(this._service);

  Future<Result<List<SupportTicketModel>>> getMyTickets() {
    return safeCallUnwrap(() => _service.getMyTickets());
  }

  Future<Result<SupportTicketModel>> createTicket(Map<String, dynamic> data) {
    return safeCallUnwrap(() => _service.createTicket(data));
  }
}
