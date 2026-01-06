import 'package:equatable/equatable.dart';

/// Params chuẩn cho các API request
class CommonParam extends Equatable {
  const CommonParam({
    this.page = 1,
    this.limit = 20,
    this.search,
    this.sortBy,
    this.sortOrder = SortOrder.desc,
    this.filters = const {},
    this.startDate,
    this.endDate,
  });

  final int page;
  final int limit;
  final String? search;
  final String? sortBy;
  final SortOrder sortOrder;
  final Map<String, dynamic> filters;
  final DateTime? startDate;
  final DateTime? endDate;

  /// Tạo param cho trang đầu
  factory CommonParam.first({int limit = 20}) => CommonParam(limit: limit);

  /// Copy với trang tiếp theo
  CommonParam nextPage() => copyWith(page: page + 1);

  /// Copy với trang đầu (refresh)
  CommonParam refresh() => copyWith(page: 1);

  /// Copy với search mới
  CommonParam withSearch(String? query) => copyWith(search: query, page: 1);

  /// Copy với filter mới
  CommonParam withFilter(String key, dynamic value) {
    final newFilters = Map<String, dynamic>.from(filters);
    if (value == null) {
      newFilters.remove(key);
    } else {
      newFilters[key] = value;
    }
    return copyWith(filters: newFilters, page: 1);
  }

  CommonParam copyWith({
    int? page,
    int? limit,
    String? search,
    String? sortBy,
    SortOrder? sortOrder,
    Map<String, dynamic>? filters,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return CommonParam(
      page: page ?? this.page,
      limit: limit ?? this.limit,
      search: search ?? this.search,
      sortBy: sortBy ?? this.sortBy,
      sortOrder: sortOrder ?? this.sortOrder,
      filters: filters ?? this.filters,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'page': page,
      'limit': limit,
    };

    if (search != null && search!.isNotEmpty) {
      data['search'] = search;
    }
    if (sortBy != null) {
      data['sort_by'] = sortBy;
      data['sort_order'] = sortOrder.name;
    }
    if (startDate != null) {
      data['start_date'] = startDate!.millisecondsSinceEpoch ~/ 1000;
    }
    if (endDate != null) {
      data['end_date'] = endDate!.millisecondsSinceEpoch ~/ 1000;
    }

    data.addAll(filters);
    return data;
  }

  @override
  List<Object?> get props => [
        page,
        limit,
        search,
        sortBy,
        sortOrder,
        filters,
        startDate,
        endDate,
      ];
}

enum SortOrder { asc, desc }
