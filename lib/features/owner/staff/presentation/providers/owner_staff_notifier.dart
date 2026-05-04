import 'package:dat_san_247_mobile/core/base/di/injection.dart';
import 'package:dat_san_247_mobile/core/base/state/riverpod/base_notifier.dart';
import 'package:dat_san_247_mobile/features/owner/staff/data/models/staff_models.dart';
import 'package:dat_san_247_mobile/features/owner/staff/data/repositories/staff_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'owner_staff_notifier.freezed.dart';
part 'owner_staff_notifier.g.dart';

@freezed
abstract class OwnerStaffData with _$OwnerStaffData {
  const factory OwnerStaffData({
    @Default([]) List<OwnerStaffModel> staffMembers,
    @Default([]) List<StaffInviteModel> pendingInvites,
  }) = _OwnerStaffData;
}

@riverpod
class OwnerStaffNotifier extends _$OwnerStaffNotifier
    with BaseNotifier<OwnerStaffData> {
  late final OwnerStaffRepository _repository;
  late final String _venueId;

  @override
  Future<OwnerStaffData> build(String venueId) async {
    _repository = getIt<OwnerStaffRepository>();
    _venueId = venueId;
    return _fetchAll();
  }

  Future<OwnerStaffData> _fetchAll() async {
    final staffResult = await _repository.getStaff(_venueId);
    final invitesResult = await _repository.getInvites(_venueId);
    final staff = staffResult.fold(onSuccess: (s) => s, onFailure: (f) => throw f);
    final invites =
        invitesResult.fold(onSuccess: (i) => i, onFailure: (f) => throw f);
    return OwnerStaffData(staffMembers: staff, pendingInvites: invites);
  }

  Future<void> refresh() => runAsync(
        action: _fetchAll,
        keepPreviousOnLoading: true,
      );

  Future<void> inviteStaff(String email, StaffRole role) async {
    final result = await _repository.inviteStaff({
      'venue_id': _venueId,
      'email': email,
      'role': role.name,
    });
    if (result.isSuccess) await refresh();
  }

  Future<void> updateStaffStatus(String staffId, bool isActive) async {
    final result = await _repository.updateStaffStatus(staffId, isActive);
    if (result.isSuccess) await refresh();
  }

  Future<void> revokeInvite(String inviteId) async {
    final result = await _repository.revokeInvite(inviteId);
    if (result.isSuccess) await refresh();
  }

  Future<void> forceAcceptInvite(String inviteId) async {
    final result = await _repository.forceAcceptInvite(inviteId);
    if (result.isSuccess) await refresh();
  }
}
