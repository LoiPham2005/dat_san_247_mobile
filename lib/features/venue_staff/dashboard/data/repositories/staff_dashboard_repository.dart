import 'package:dat_san_247_mobile/features/venue_staff/dashboard/data/models/staff_dashboard_models.dart';
import 'package:dat_san_247_mobile/features/venue_staff/dashboard/data/services/staff_dashboard_service.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/base/errors/result.dart';
import '../../../../../core/common/mixins/api_handler_mixin.dart';

@LazySingleton()
class StaffDashboardRepository with ApiHandlerMixin {
  final StaffDashboardService _service;

  StaffDashboardRepository(this._service);

  Future<Result<StaffDashboardModel>> getDashboardStats() {
    return safeCallUnwrap(() => _service.getDashboardStats());
  }
}
