import 'package:dat_san_247_mobile/core/base/di/injection.dart';
import 'package:dat_san_247_mobile/core/base/state/riverpod/base_notifier.dart';
import 'package:dat_san_247_mobile/features/venue_staff/dashboard/data/models/staff_dashboard_models.dart';
import 'package:dat_san_247_mobile/features/venue_staff/dashboard/data/repositories/staff_dashboard_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'staff_dashboard_notifier.g.dart';

@riverpod
class StaffDashboardNotifier extends _$StaffDashboardNotifier
    with BaseNotifier<StaffDashboardModel> {
  late final StaffDashboardRepository _repository;

  @override
  Future<StaffDashboardModel> build() async {
    _repository = getIt<StaffDashboardRepository>();
    final result = await _repository.getDashboardStats();
    return result.fold(
      onSuccess: (data) => data,
      onFailure: (f) => throw f,
    );
  }

  Future<void> refresh() => runResult(
        action: _repository.getDashboardStats,
        mapper: (data) => data,
        keepPreviousOnLoading: true,
      );
}
