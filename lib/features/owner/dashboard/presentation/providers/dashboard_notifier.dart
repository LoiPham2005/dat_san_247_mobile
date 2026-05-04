import 'package:dat_san_247_mobile/core/base/di/injection.dart';
import 'package:dat_san_247_mobile/core/base/errors/result.dart';
import 'package:dat_san_247_mobile/core/base/state/riverpod/base_notifier.dart';
import 'package:dat_san_247_mobile/core/services/manager/toast_service.dart';
import 'package:dat_san_247_mobile/features/owner/dashboard/data/models/owner_dashboard_models.dart';
import 'package:dat_san_247_mobile/features/owner/dashboard/data/repositories/dashboard_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dashboard_notifier.g.dart';

class DashboardData extends Equatable {
  final List<OwnerVenueSummaryModel> venues;
  final OwnerVenueSummaryModel? selectedVenue;
  final OwnerBookingStatsModel? stats;
  final OwnerRevenueModel? revenue;
  final List<OwnerPendingBookingModel> pendingBookings;
  final List<OwnerRecentReviewModel> recentReviews;

  const DashboardData({
    this.venues = const [],
    this.selectedVenue,
    this.stats,
    this.revenue,
    this.pendingBookings = const [],
    this.recentReviews = const [],
  });

  @override
  List<Object?> get props =>
      [venues, selectedVenue, stats, revenue, pendingBookings, recentReviews];

  DashboardData copyWith({
    List<OwnerVenueSummaryModel>? venues,
    OwnerVenueSummaryModel? selectedVenue,
    OwnerBookingStatsModel? stats,
    OwnerRevenueModel? revenue,
    List<OwnerPendingBookingModel>? pendingBookings,
    List<OwnerRecentReviewModel>? recentReviews,
  }) =>
      DashboardData(
        venues: venues ?? this.venues,
        selectedVenue: selectedVenue ?? this.selectedVenue,
        stats: stats ?? this.stats,
        revenue: revenue ?? this.revenue,
        pendingBookings: pendingBookings ?? this.pendingBookings,
        recentReviews: recentReviews ?? this.recentReviews,
      );
}

@riverpod
class DashboardNotifier extends _$DashboardNotifier with BaseNotifier<DashboardData> {
  late final DashboardRepository _repository;

  @override
  Future<DashboardData> build() async {
    _repository = getIt<DashboardRepository>();
    return _initLoad();
  }

  Future<DashboardData> _initLoad() async {
    final venuesRes = await _repository.getOwnerVenues();
    final venues = venuesRes.fold(
      onSuccess: (v) => v,
      onFailure: (f) => throw f,
    );
    if (venues.isEmpty) return const DashboardData();

    final primary = venues.first;
    final initial = DashboardData(venues: venues, selectedVenue: primary);
    return _loadVenueData(primary.id, initial);
  }

  Future<DashboardData> _loadVenueData(String venueId, DashboardData base) async {
    final results = await Future.wait([
      _repository.getStats(venueId: venueId),
      _repository.getRevenue(venueId: venueId),
      _repository.getPendingBookings(venueId),
    ]);

    final statsRes = results[0] as Result<OwnerBookingStatsModel>;
    final revenueRes = results[1] as Result<OwnerRevenueModel>;
    final pendingRes = results[2] as Result<List<OwnerPendingBookingModel>>;

    return base.copyWith(
      stats: statsRes.dataOrNull,
      revenue: revenueRes.dataOrNull,
      pendingBookings: pendingRes.dataOrNull ?? [],
    );
  }

  Future<void> refresh({String? venueId}) async {
    final current = currentData;
    final id = venueId ?? current?.selectedVenue?.id;
    if (id == null || current == null) return;
    await runAsync(
      action: () => _loadVenueData(id, current),
      keepPreviousOnLoading: true,
    );
  }

  Future<void> selectVenue(OwnerVenueSummaryModel venue) async {
    final current = currentData;
    if (current == null) return;
    await runAsync(
      action: () => _loadVenueData(venue.id, current.copyWith(selectedVenue: venue)),
      keepPreviousOnLoading: true,
    );
  }

  Future<void> acceptBooking(String id) async {
    toast.loading('Đang xác nhận...');
    final result = await _repository.updateBookingStatus(id, 'CONFIRMED');
    toast.stopLoading();
    if (result.isSuccess) {
      toast.success('Đã xác nhận đơn đặt sân');
      await refresh();
    } else {
      toast.error(result.failureOrNull?.message ?? 'Không thể xác nhận đơn');
    }
  }

  Future<void> rejectBooking(String id) async {
    toast.loading('Đang từ chối...');
    final result = await _repository.updateBookingStatus(id, 'CANCELLED');
    toast.stopLoading();
    if (result.isSuccess) {
      toast.success('Đã từ chối đơn đặt sân');
      await refresh();
    } else {
      toast.error(result.failureOrNull?.message ?? 'Không thể từ chối đơn');
    }
  }
}
