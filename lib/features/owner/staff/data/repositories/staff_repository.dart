import 'package:dat_san_247_mobile/core/base/errors/result.dart';
import 'package:dat_san_247_mobile/core/common/mixins/api_handler_mixin.dart';
import 'package:dat_san_247_mobile/features/owner/staff/data/models/staff_models.dart';
import 'package:dat_san_247_mobile/features/owner/staff/data/services/staff_service.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class OwnerStaffRepository with ApiHandlerMixin {
  final OwnerStaffService _service;
  OwnerStaffRepository(this._service);

  Future<Result<List<OwnerStaffModel>>> getStaff(String venueId) {
    return safeCallUnwrap(() => _service.getStaff(venueId));
  }

  Future<Result<StaffInviteModel>> inviteStaff(Map<String, dynamic> data) {
    return safeCallUnwrap(() => _service.inviteStaff(data));
  }

  Future<Result<List<StaffInviteModel>>> getInvites(String venueId) {
    return safeCallUnwrap(() => _service.getInvites(venueId));
  }

  Future<Result<OwnerStaffModel>> updateStaffStatus(String staffId, bool isActive) {
    return safeCallUnwrap(() => _service.updateStaffStatus(staffId, {'is_active': isActive}));
  }

  Future<Result<void>> revokeInvite(String inviteId) {
    return safeCallUnwrap(() => _service.revokeInvite(inviteId)).thenMap((_) => null);
  }

  Future<Result<OwnerStaffModel>> forceAcceptInvite(String inviteId) {
    return safeCallUnwrap(() => _service.forceAcceptInvite(inviteId));
  }
}
