import 'package:dat_san_247_mobile/core/base/errors/result.dart';
import 'package:dat_san_247_mobile/core/base/state/bloc/base_state.dart';
import 'package:dat_san_247_mobile/core/base/state/cubit/base_cubit.dart';
import 'package:dat_san_247_mobile/core/services/manager/toast_service.dart';
import 'package:dat_san_247_mobile/features/owner/dashboard/data/models/owner_dashboard_models.dart';
import 'package:dat_san_247_mobile/features/owner/dashboard/data/repositories/dashboard_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

// ── Dashboard State ────────────────────────────────────────────────────────
class DashboardState extends Equatable {
  final List<OwnerVenueSummaryModel> venues;
  final OwnerVenueSummaryModel? selectedVenue;
  final OwnerBookingStatsModel? stats;
  final OwnerRevenueModel? revenue;
  final List<OwnerPendingBookingModel> pendingBookings;
  final List<OwnerRecentReviewModel> recentReviews;

  const DashboardState({
    this.venues = const [],
    this.selectedVenue,
    this.stats,
    this.revenue,
    this.pendingBookings = const [],
    this.recentReviews = const [],
  });

  factory DashboardState.initial() => const DashboardState();

  @override
  List<Object?> get props => [venues, selectedVenue, stats, revenue, pendingBookings, recentReviews];

  DashboardState copyWith({
    List<OwnerVenueSummaryModel>? venues,
    OwnerVenueSummaryModel? selectedVenue,
    OwnerBookingStatsModel? stats,
    OwnerRevenueModel? revenue,
    List<OwnerPendingBookingModel>? pendingBookings,
    List<OwnerRecentReviewModel>? recentReviews,
  }) {
    return DashboardState(
      venues: venues ?? this.venues,
      selectedVenue: selectedVenue ?? this.selectedVenue,
      stats: stats ?? this.stats,
      revenue: revenue ?? this.revenue,
      pendingBookings: pendingBookings ?? this.pendingBookings,
      recentReviews: recentReviews ?? this.recentReviews,
    );
  }
}

// ── Dashboard Cubit ───────────────────────────────────────────────────────
@injectable
class DashboardCubit extends BaseCubit<DashboardState> {
  final DashboardRepository _repository;

  DashboardCubit(this._repository) : super(BaseState.initial());

  /// 🚀 Initialization — Fetch everything for the primary venue
  Future<void> init() async {
    emit(BaseState.loading(previousData: state.data));

    // 1. Get venues
    final venuesRes = await _repository.getOwnerVenues();
    if (isClosed) return;

    if (venuesRes.isFailure) {
      emit(BaseState.failure(
        error: venuesRes.failureOrNull?.message ?? 'Lỗi tải danh sách sân',
        previousData: state.data,
      ));
      return;
    }

    final venues = venuesRes.dataOrNull ?? [];
    if (venues.isEmpty) {
      emit(BaseState.empty(message: 'Bạn chưa có sân nào'));
      return;
    }

    final primaryVenue = venues.first;
    final initialDashboardData = DashboardState(
      venues: venues,
      selectedVenue: primaryVenue,
    );

    // 2. Fetch stats, revenue, and bookings for the primary venue
    await refresh(vId: primaryVenue.id, current: initialDashboardData);
  }

  /// 🔄 Refresh data for a venue
  Future<void> refresh({String? vId, DashboardState? current}) async {
    if (isClosed) return;
    final venueId = vId ?? state.data?.selectedVenue?.id;
    if (venueId == null) return;

    final initialData = current ?? state.data ?? DashboardState(selectedVenue: state.data?.selectedVenue);
    emit(BaseState.loading(previousData: initialData));

    // Execute multiple fetch operations in parallel
    final results = await Future.wait([
      _repository.getStats(venueId: venueId),
      _repository.getRevenue(venueId: venueId),
      _repository.getPendingBookings(venueId),
    ]);

    // Use explicit casting with Result<T> pattern
    final statsRes = results[0] as Result<OwnerBookingStatsModel>;
    final revenueRes = results[1] as Result<OwnerRevenueModel>;
    final pendingRes = results[2] as Result<List<OwnerPendingBookingModel>>;

    if (isClosed) return;

    final updatedData = initialData.copyWith(
      stats: statsRes.dataOrNull,
      revenue: revenueRes.dataOrNull,
      pendingBookings: pendingRes.dataOrNull ?? [],
    );

    emit(BaseState.success(data: updatedData));
  }

  /// 🏟️ Select a different venue
  Future<void> selectVenue(OwnerVenueSummaryModel venue) async {
    final newState = state.data?.copyWith(selectedVenue: venue);
    await refresh(vId: venue.id, current: newState);
  }

  /// ✅ Accept booking
  Future<void> acceptBooking(String id) async {
    toast.loading('Đang xác nhận...');
    final result = await _repository.updateBookingStatus(id, 'CONFIRMED');
    toast.stopLoading();

    if (isClosed) return;

    if (result.isSuccess) {
      toast.success('Đã xác nhận đơn đặt sân');
      await refresh();
    } else {
      toast.error(result.failureOrNull?.message ?? 'Không thể xác nhận đơn');
    }
  }

  /// ❌ Reject booking
  Future<void> rejectBooking(String id) async {
    toast.loading('Đang từ chối...');
    final result = await _repository.updateBookingStatus(id, 'CANCELLED');
    toast.stopLoading();

    if (isClosed) return;

    if (result.isSuccess) {
      toast.success('Đã từ chối đơn đặt sân');
      await refresh();
    } else {
      toast.error(result.failureOrNull?.message ?? 'Không thể từ chối đơn');
    }
  }
}
