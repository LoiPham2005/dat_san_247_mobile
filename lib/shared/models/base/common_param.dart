import 'package:equatable/equatable.dart';

/// 🎯 Tham số truy vấn chuẩn cho mọi API Request
/// Dùng để GỬI dữ liệu lên Server (Query Parameters)
class CommonParam extends Equatable {
  final int page;
  final int limit;
  final String? search;
  final String? sortBy;
  final SortOrder sortOrder;
  final Map<String, dynamic> filters;
  final DateTime? startDate;
  final DateTime? endDate;

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

  // Factories & Helpers
  factory CommonParam.first({int limit = 20}) => CommonParam(limit: limit);

  CommonParam nextPage() => copyWith(page: page + 1);
  CommonParam refresh() => copyWith(page: 1);
  CommonParam withSearch(String? query) => copyWith(search: query, page: 1);

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

  /// Convert sang Map để gửi qua Dio (Chỉ giữ lại các trường có giá trị)
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{'page': page, 'limit': limit};

    if (search != null && search!.trim().isNotEmpty)
      map['search'] = search!.trim();
    if (sortBy != null) {
      map['sort_by'] = sortBy;
      map['sort_order'] = sortOrder.name;
    }

    // Convert Date sang epoch seconds (Phổ biến trong Backend)
    if (startDate != null)
      map['start_date'] = startDate!.millisecondsSinceEpoch ~/ 1000;
    if (endDate != null)
      map['end_date'] = endDate!.millisecondsSinceEpoch ~/ 1000;

    // Thêm các custom filters khác
    if (filters.isNotEmpty) {
      map.addAll(filters);
    }

    return map;
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
