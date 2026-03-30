import 'package:dat_san_247_mobile/core/base/state/base_status.dart';
import 'package:dat_san_247_mobile/core/base/state/bloc/base_state.dart';
import 'package:dat_san_247_mobile/core/base/state/cubit/base_cubit.dart';
import 'package:dat_san_247_mobile/features/owner/staff/data/models/staff_models.dart';
import 'package:dat_san_247_mobile/features/owner/staff/data/repositories/staff_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'owner_staff_cubit.freezed.dart';

@freezed
abstract class OwnerStaffState with _$OwnerStaffState {
  const factory OwnerStaffState({
    @Default([]) List<OwnerStaffModel> staffMembers,
    @Default([]) List<StaffInviteModel> pendingInvites,
  }) = _OwnerStaffState;
}

@injectable
class OwnerStaffCubit extends BaseCubit<OwnerStaffState> {
  final OwnerStaffRepository _repository;
  OwnerStaffCubit(this._repository) : super(BaseState(status: BaseStatus.initial, data: OwnerStaffState()));

  Future<void> fetchStaffData(String venueId) async {
    emit(BaseState.loading(previousData: state.data));
    
    final staffResult = await _repository.getStaff(venueId);
    final invitesResult = await _repository.getInvites(venueId);
    
    if (isClosed) return;

    OwnerStaffState currentData = state.data ?? const OwnerStaffState();
    
    staffResult.fold(
      onSuccess: (staff) {
        currentData = currentData.copyWith(staffMembers: staff);
        invitesResult.fold(
          onSuccess: (invites) {
            emit(BaseState.success(data: currentData.copyWith(pendingInvites: invites)));
          },
          onFailure: (f) => emit(BaseState.failure(error: f.message, previousData: currentData)),
        );
      },
      onFailure: (f) => emit(BaseState.failure(error: f.message, previousData: currentData)),
    );
  }

  Future<void> inviteStaff(String venueId, String email, StaffRole role) async {
    emit(BaseState.loading(previousData: state.data));
    final result = await _repository.inviteStaff({
      'venue_id': venueId,
      'email': email,
      'role': role.name,
    });
    
    if (isClosed) return;
    
    result.fold(
      onSuccess: (_) => fetchStaffData(venueId),
      onFailure: (f) => emit(BaseState.failure(error: f.message, previousData: state.data)),
    );
  }

  Future<void> updateStaffStatus(String venueId, String staffId, bool isActive) async {
    emit(BaseState.loading(previousData: state.data));
    final result = await _repository.updateStaffStatus(staffId, isActive);
    
    if (isClosed) return;
    
    result.fold(
      onSuccess: (_) => fetchStaffData(venueId),
      onFailure: (f) => emit(BaseState.failure(error: f.message, previousData: state.data)),
    );
  }

  Future<void> revokeInvite(String venueId, String inviteId) async {
    emit(BaseState.loading(previousData: state.data));
    final result = await _repository.revokeInvite(inviteId);
    
    if (isClosed) return;
    
    result.fold(
      onSuccess: (_) => fetchStaffData(venueId),
      onFailure: (f) => emit(BaseState.failure(error: f.message, previousData: state.data)),
    );
  }

  Future<void> forceAcceptInvite(String venueId, String inviteId) async {
    emit(BaseState.loading(previousData: state.data));
    final result = await _repository.forceAcceptInvite(inviteId);
    
    if (isClosed) return;
    
    result.fold(
      onSuccess: (_) => fetchStaffData(venueId),
      onFailure: (f) => emit(BaseState.failure(error: f.message, previousData: state.data)),
    );
  }
}
