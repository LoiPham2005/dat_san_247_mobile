// // ════════════════════════════════════════════════════════════════
// // 📁 lib/core/usecases/params.dart
// // ════════════════════════════════════════════════════════════════
// import 'package:equatable/equatable.dart';

// /// Dùng khi UseCase không cần params
// class NoParams extends Equatable {
//   const NoParams();

//   @override
//   List<Object?> get props => [];
// }

// /// Base class cho các params khác (optional)
// abstract class Params extends Equatable {
//   const Params();
// }



// ════════════════════════════════════════════════════════════════
// 📁 lib/core/usecases/params.dart (ULTIMATE)
// ════════════════════════════════════════════════════════════════
import 'package:equatable/equatable.dart';

/// Dùng khi UseCase không cần params
class NoParams extends Equatable {
  const NoParams();

  @override
  List<Object?> get props => [];
}

/// Base class cho các params phức tạp
///
/// Example:
/// ```dart
/// class SearchParams extends Params {
///   final String? keyword;
///   final int page;
///   final int limit;
///
///   const SearchParams({this.keyword, this.page = 1, this.limit = 20});
///
///   @override
///   List<Object?> get props => [keyword, page, limit];
///
///   @override
///   Map<String, dynamic> toJson() => {
///     if (keyword != null) 'keyword': keyword,
///     'page': page,
///     'limit': limit,
///   };
/// }
/// ```
abstract class Params extends Equatable {
  const Params();

  /// Convert params to JSON (for API calls)
  /// Override this in subclass
  Map<String, dynamic> toJson() => {};

  /// Convert params to query string
  String toQueryString() {
    final json = toJson();
    if (json.isEmpty) return '';
    return json.entries
        .where((e) => e.value != null)
        .map((e) => '${e.key}=${Uri.encodeComponent(e.value.toString())}')
        .join('&');
  }
}

// ════════════════════════════════════════════════════════════════
// COMMON PARAMS (Reusable)
// ════════════════════════════════════════════════════════════════

/// Pagination params - Dùng cho list APIs
class PaginationParams extends Params {
  final int page;
  final int limit;
  final String? sortBy;
  final bool ascending;

  const PaginationParams({
    this.page = 1,
    this.limit = 20,
    this.sortBy,
    this.ascending = true,
  });

  @override
  List<Object?> get props => [page, limit, sortBy, ascending];

  @override
  Map<String, dynamic> toJson() => {
        'page': page,
        'limit': limit,
        if (sortBy != null) 'sort_by': sortBy,
        if (sortBy != null) 'order': ascending ? 'asc' : 'desc',
      };

  PaginationParams copyWith({
    int? page,
    int? limit,
    String? sortBy,
    bool? ascending,
  }) {
    return PaginationParams(
      page: page ?? this.page,
      limit: limit ?? this.limit,
      sortBy: sortBy ?? this.sortBy,
      ascending: ascending ?? this.ascending,
    );
  }

  /// Next page
  PaginationParams nextPage() => copyWith(page: page + 1);

  /// Reset to first page
  PaginationParams reset() => copyWith(page: 1);
}

/// ID param - Dùng cho get by ID
class IdParam extends Params {
  final String id;

  const IdParam(this.id);

  @override
  List<Object?> get props => [id];

  @override
  Map<String, dynamic> toJson() => {'id': id};
}

/// Search params - Dùng cho search APIs
class SearchParams extends Params {
  final String? keyword;
  final int page;
  final int limit;
  final Map<String, dynamic>? filters;

  const SearchParams({
    this.keyword,
    this.page = 1,
    this.limit = 20,
    this.filters,
  });

  @override
  List<Object?> get props => [keyword, page, limit, filters];

  @override
  Map<String, dynamic> toJson() => {
        if (keyword != null && keyword!.isNotEmpty) 'keyword': keyword,
        'page': page,
        'limit': limit,
        if (filters != null) ...filters!,
      };

  SearchParams copyWith({
    String? keyword,
    int? page,
    int? limit,
    Map<String, dynamic>? filters,
  }) {
    return SearchParams(
      keyword: keyword ?? this.keyword,
      page: page ?? this.page,
      limit: limit ?? this.limit,
      filters: filters ?? this.filters,
    );
  }

  /// Next page
  SearchParams nextPage() => copyWith(page: page + 1);

  /// Clear search
  SearchParams clear() => const SearchParams();
}

/// Date range params - Dùng cho filter by date
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

  /// Check if has valid range
  bool get hasValidRange => startDate != null && endDate != null;

  /// Duration of range
  Duration? get duration {
    if (!hasValidRange) return null;
    return endDate!.difference(startDate!);
  }
}
