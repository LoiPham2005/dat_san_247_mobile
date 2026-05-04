import 'package:dat_san_247_mobile/core/base/di/injection.dart';
import 'package:dat_san_247_mobile/core/base/state/riverpod/base_notifier.dart';
import 'package:dat_san_247_mobile/core/services/manager/toast_service.dart';
import 'package:dat_san_247_mobile/features/owner/venue/data/models/venue_models.dart';
import 'package:dat_san_247_mobile/features/owner/venue/data/repositories/venue_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'owner_venue_notifier.g.dart';

class OwnerVenueListData extends Equatable {
  final List<OwnerVenueModel> venues;
  final VenueStatus? filterStatus;
  final String searchQuery;

  const OwnerVenueListData({
    this.venues = const [],
    this.filterStatus,
    this.searchQuery = '',
  });

  List<OwnerVenueModel> get filteredVenues {
    var list = venues;
    if (filterStatus != null) {
      list = list.where((v) => v.status == filterStatus).toList();
    }
    if (searchQuery.isNotEmpty) {
      final q = searchQuery.toLowerCase();
      list = list
          .where((v) =>
              v.name.toLowerCase().contains(q) ||
              v.district.toLowerCase().contains(q))
          .toList();
    }
    return list;
  }

  int countStatus(VenueStatus s) => venues.where((v) => v.status == s).length;

  OwnerVenueListData copyWith({
    List<OwnerVenueModel>? venues,
    VenueStatus? filterStatus,
    bool clearFilter = false,
    String? searchQuery,
  }) =>
      OwnerVenueListData(
        venues: venues ?? this.venues,
        filterStatus:
            clearFilter ? null : (filterStatus ?? this.filterStatus),
        searchQuery: searchQuery ?? this.searchQuery,
      );

  @override
  List<Object?> get props => [venues, filterStatus, searchQuery];
}

@riverpod
class OwnerVenueNotifier extends _$OwnerVenueNotifier
    with BaseNotifier<OwnerVenueListData> {
  late final OwnerVenueRepository _repository;

  @override
  Future<OwnerVenueListData> build() async {
    _repository = getIt<OwnerVenueRepository>();
    final result = await _repository.getOwnerVenues();
    final venues = result.fold(
      onSuccess: (v) => v,
      onFailure: (f) => throw f,
    );
    return OwnerVenueListData(venues: venues);
  }

  Future<void> refresh() => runResult(
        action: _repository.getOwnerVenues,
        mapper: (venues) =>
            (currentData ?? const OwnerVenueListData()).copyWith(venues: venues),
        keepPreviousOnLoading: true,
      );

  void updateSearch(String query) {
    final current = currentData ?? const OwnerVenueListData();
    state = AsyncData(current.copyWith(searchQuery: query));
  }

  void setFilter(VenueStatus? status) {
    final current = currentData ?? const OwnerVenueListData();
    state = AsyncData(status == null
        ? current.copyWith(clearFilter: true)
        : current.copyWith(filterStatus: status));
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
    result.fold(
      onSuccess: (_) {
        toast.success('Đã tạo venue mới thành công!');
        refresh();
      },
      onFailure: (failure) => toast.error(failure.message),
    );
  }
}
