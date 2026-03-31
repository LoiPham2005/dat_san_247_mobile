import 'package:dat_san_247_mobile/core/base/state/base_status.dart';
import 'package:dat_san_247_mobile/core/base/state/bloc/base_state.dart';
import 'package:dat_san_247_mobile/core/base/state/cubit/base_cubit.dart';
import 'package:dat_san_247_mobile/features/venue_staff/dashboard/data/models/staff_dashboard_models.dart';
import 'package:dat_san_247_mobile/features/venue_staff/dashboard/data/repositories/staff_dashboard_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'staff_dashboard_cubit.freezed.dart';

@freezed
abstract class StaffDashboardState with _$StaffDashboardState {
  const factory StaffDashboardState({
    StaffDashboardModel? dashboardData,
  }) = _StaffDashboardState;
}

@injectable
class StaffDashboardCubit extends BaseCubit<StaffDashboardState> {
  final StaffDashboardRepository _repository;

  StaffDashboardCubit(this._repository)
      : super(const BaseState(status: BaseStatus.initial, data: StaffDashboardState()));

  Future<void> initDashboard() async {
    emit(BaseState.loading(previousData: state.data));

    final result = await _repository.getDashboardStats();

    result.fold(
      onSuccess: (data) => emit(BaseState.success(
        data: StaffDashboardState(dashboardData: data),
      )),
      onFailure: (failure) => emit(BaseState.failure(
        error: failure.message,
        previousData: state.data,
      )),
    );
  }
}
