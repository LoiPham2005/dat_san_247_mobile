// 📁 lib/core/usecases/params.dart
import 'package:equatable/equatable.dart';

/// Dùng khi UseCase không cần params
class NoParams extends Equatable {
  const NoParams();
  @override
  List<Object?> get props => [];
}

/// Base class cho params phức tạp — override [toJson] nếu cần gọi API.
abstract class Params extends Equatable {
  const Params();
  Map<String, dynamic> toJson() => {};
}

// ── Common Params ─────────────────────────────────────────────

/// Pagination — dùng cho list APIs
class PaginationParams extends Params {
  final int page;
  final int limit;
  final String? sortBy;
  final bool ascending;

  const PaginationParams({this.page = 1, this.limit = 20, this.sortBy, this.ascending = true});

  @override
  List<Object?> get props => [page, limit, sortBy, ascending];

  @override
  Map<String, dynamic> toJson() => {
    'page': page,
    'limit': limit,
    if (sortBy != null) 'sort_by': sortBy,
    if (sortBy != null) 'order': ascending ? 'asc' : 'desc',
  };

  PaginationParams copyWith({int? page, int? limit, String? sortBy, bool? ascending}) =>
      PaginationParams(
        page: page ?? this.page,
        limit: limit ?? this.limit,
        sortBy: sortBy ?? this.sortBy,
        ascending: ascending ?? this.ascending,
      );

  PaginationParams nextPage() => copyWith(page: page + 1);
  PaginationParams reset() => copyWith(page: 1);
}

/// ID param — dùng cho get/delete by ID
class IdParam extends Params {
  final String id;
  const IdParam(this.id);

  @override
  List<Object?> get props => [id];
}

/// Search — keyword + pagination + optional filters
class SearchParams extends Params {
  final String? keyword;
  final int page;
  final int limit;
  final Map<String, dynamic>? filters;

  const SearchParams({this.keyword, this.page = 1, this.limit = 20, this.filters});

  @override
  List<Object?> get props => [keyword, page, limit, filters];

  @override
  Map<String, dynamic> toJson() => {
    if (keyword?.isNotEmpty == true) 'keyword': keyword,
    'page': page,
    'limit': limit,
    if (filters != null) ...filters!,
  };

  SearchParams copyWith({String? keyword, int? page, int? limit, Map<String, dynamic>? filters}) =>
      SearchParams(
        keyword: keyword ?? this.keyword,
        page: page ?? this.page,
        limit: limit ?? this.limit,
        filters: filters ?? this.filters,
      );

  SearchParams nextPage() => copyWith(page: page + 1);
  SearchParams clear() => const SearchParams();
}

/// Date range — filter by date
class DateRangeParams extends Params {
  final DateTime? startDate;
  final DateTime? endDate;

  const DateRangeParams({this.startDate, this.endDate});

  @override
  List<Object?> get props => [startDate, endDate];

  @override
  Map<String, dynamic> toJson() => {
    if (startDate != null) 'start_date': startDate!.toIso8601String(),
    if (endDate != null) 'end_date': endDate!.toIso8601String(),
  };

  bool get isValid => startDate != null && endDate != null;
  Duration? get duration => isValid ? endDate!.difference(startDate!) : null;
}

// ── Extension ─────────────────────────────────────────────────

/// Convert Params sang query string — chỉ dùng cho GET request.
extension ParamsQueryString on Params {
  String toQueryString() {
    final json = toJson();
    if (json.isEmpty) return '';
    return json.entries
        .where((e) => e.value != null)
        .map((e) => '${e.key}=${Uri.encodeComponent(e.value.toString())}')
        .join('&');
  }
}
