import 'package:dat_san_247_mobile/core/errors/result.dart';
import 'package:dat_san_247_mobile/core/mixins/api_handler_mixin.dart';
import 'package:injectable/injectable.dart';

import '../models/bbbbbbbb_model.dart';
import '../services/bbbbbbbb_service.dart';

@LazySingleton()
class BbbbbbbbRepository with ApiHandlerMixin {
  final BbbbbbbbService _service;

  BbbbbbbbRepository(this._service);

  Future<Result<List<BbbbbbbbModel>>> getBbbbbbbbs({Map<String, dynamic>? params}) {
    return safeCall(() => _service.getBbbbbbbbs(params: params));
  }

  Future<Result<BbbbbbbbModel>> getBbbbbbbbDetail(String id) {
    return safeCall(() => _service.getBbbbbbbbDetail(id));
  }

  Future<Result<BbbbbbbbModel>> createBbbbbbbb(BbbbbbbbModel data) {
    return safeCall(() => _service.createBbbbbbbb(data));
  }

  Future<Result<BbbbbbbbModel>> updateBbbbbbbb(String id, BbbbbbbbModel data) {
    return safeCall(() => _service.updateBbbbbbbb(id, data));
  }

  Future<Result<bool>> deleteBbbbbbbb(String id) {
    return safeCallBool(() => _service.deleteBbbbbbbb(id));
  }
}
