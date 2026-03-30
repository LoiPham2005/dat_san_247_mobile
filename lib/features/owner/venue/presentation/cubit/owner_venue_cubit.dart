import 'package:dat_san_247_mobile/core/base/state/bloc/base_state.dart';
import 'package:dat_san_247_mobile/core/base/state/cubit/base_cubit.dart';
import 'package:dat_san_247_mobile/features/owner/venue/data/models/venue_models.dart';
import 'package:dat_san_247_mobile/features/owner/venue/data/repositories/venue_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:dat_san_247_mobile/core/services/manager/toast_service.dart';

// ── Venue List State ────────────────────────────────────────────────────────
class OwnerVenueListState extends Equatable {
  final List<OwnerVenueModel> venues;
  final VenueStatus? filterStatus;
  final String searchQuery;

  const OwnerVenueListState({
    this.venues = const [],
    this.filterStatus,
    this.searchQuery = '',
  });

  factory OwnerVenueListState.initial() => const OwnerVenueListState();

  List<OwnerVenueModel> get filteredVenues {
    var list = venues;
    if (filterStatus != null) {
      list = list.where((v) => v.status == filterStatus).toList();
    }
    if (searchQuery.isNotEmpty) {
      final q = searchQuery.toLowerCase();
      list = list
          .where((v) => v.name.toLowerCase().contains(q) || v.district.toLowerCase().contains(q))
          .toList();
    }
    return list;
  }

  int countStatus(VenueStatus s) => venues.where((v) => v.status == s).length;

  OwnerVenueListState copyWith({
    List<OwnerVenueModel>? venues,
    VenueStatus? filterStatus,
    bool clearFilter = false,
    String? searchQuery,
  }) {
    return OwnerVenueListState(
      venues: venues ?? this.venues,
      filterStatus: clearFilter ? null : (filterStatus ?? this.filterStatus),
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props => [venues, filterStatus, searchQuery];
}

// ── Owner Venue Cubit ───────────────────────────────────────────────────────
@injectable
class OwnerVenueCubit extends BaseCubit<OwnerVenueListState> {
  final OwnerVenueRepository _repository;

  OwnerVenueCubit(this._repository) : super(BaseState.initial());

  /// 🚀 Fetch all owner venues
  Future<void> fetchVenues() async {
    emit(BaseState.loading(previousData: state.data));
    final result = await _repository.getOwnerVenues();
    if (isClosed) return;

    result.fold(
      onSuccess: (venues) {
        if (venues.isEmpty) {
          emit(BaseState.empty(message: 'Bạn chưa có địa điểm nào. Thêm ngay!'));
        } else {
          emit(BaseState.success(
              data: (state.data ?? const OwnerVenueListState()).copyWith(venues: venues)));
        }
      },
      onFailure: (failure) => emit(BaseState.failure(
        error: failure.message,
        previousData: state.data,
      )),
    );
  }

  /// 🔄 Refresh venues
  Future<void> refresh() => fetchVenues();

  /// 🔍 Update search query
  void updateSearch(String query) {
    emit(BaseState.success(
        data: (state.data ?? const OwnerVenueListState()).copyWith(searchQuery: query)));
  }

  /// 🎯 Filter by status
  void setFilter(VenueStatus? status) {
    if (status == null) {
      emit(BaseState.success(
          data: (state.data ?? const OwnerVenueListState()).copyWith(clearFilter: true)));
    } else {
      emit(BaseState.success(
          data: (state.data ?? const OwnerVenueListState()).copyWith(filterStatus: status)));
    }
  }

  Future<void> createVenue({
    required String name,
    required String address,
    required String city,
    required String district,
    String? ward,
    String? phone,
    double? lat,
    double? lng,
  }) async {
    toast.loading('Đang tạo sân bãi...');
    final result = await _repository.createVenue({
      'name': name,
      'address': address,
      'city': city,
      'district': district,
      'ward': ward,
      'phone': phone,
      'latitude': lat,
      'longitude': lng,
    });
    toast.stopLoading();

    if (isClosed) return;

    result.fold(
      onSuccess: (newVenue) {
        toast.success('Đã tạo venue mới thành công!');
        fetchVenues(); // Refresh the list
      },
      onFailure: (failure) {
        toast.error(failure.message);
      },
    );
  }
}
