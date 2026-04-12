import 'package:dat_san_247_mobile/core/base/errors/result.dart';
import 'package:dat_san_247_mobile/core/common/mixins/api_handler_mixin.dart';
import 'package:dat_san_247_mobile/features/customer/waitlist/data/models/waitlist_model.dart';
import 'package:dat_san_247_mobile/features/customer/waitlist/data/services/waitlist_service.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class WaitlistRepository with ApiHandlerMixin {
  final WaitlistService _service;

  WaitlistRepository(this._service);

  Future<Result<List<WaitlistModel>>> getMyWaitlist() {
    return safeCallUnwrap(() => _service.getMyWaitlist());
  }

  Future<Result<void>> cancelWaitlist(String id) {
    return safeCallUnwrap(() => _service.cancelWaitlist(id));
  }
}
