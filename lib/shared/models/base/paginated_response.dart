import 'package:equatable/equatable.dart';

/// Response phân trang chuẩn
class PaginatedResponse<T> extends Equatable {
  const PaginatedResponse({
    required this.data,
    required this.pagination,
  });

  final List<T> data;
  final PaginationMeta pagination;

  /// Factory từ JSON với custom parser
  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    return PaginatedResponse(
      data: (json['data'] as List<dynamic>?)
              ?.map((e) => fromJsonT(e as Map<String, dynamic>))
              .toList() ??
          [],
      pagination: PaginationMeta.fromJson(
        json['pagination'] ?? json['meta'] ?? {},
      ),
    );
  }

  bool get isEmpty => data.isEmpty;
  bool get isNotEmpty => data.isNotEmpty;
  bool get hasMore => pagination.hasMore;
  int get total => pagination.total;

  /// Merge với response khác (cho load more)
  PaginatedResponse<T> merge(PaginatedResponse<T> other) {
    return PaginatedResponse(
      data: [...data, ...other.data],
      pagination: other.pagination,
    );
  }

  @override
  List<Object?> get props => [data, pagination];
}

/// Metadata phân trang
class PaginationMeta extends Equatable {
  const PaginationMeta({
    this.currentPage = 1,
    this.lastPage = 1,
    this.perPage = 20,
    this.total = 0,
  });

  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  factory PaginationMeta.fromJson(Map<String, dynamic> json) {
    return PaginationMeta(
      currentPage: json['current_page'] ?? json['page'] ?? 1,
      lastPage: json['last_page'] ?? json['total_pages'] ?? 1,
      perPage: json['per_page'] ?? json['limit'] ?? 20,
      total: json['total'] ?? 0,
    );
  }

  bool get hasMore => currentPage < lastPage;
  bool get isFirstPage => currentPage == 1;
  bool get isLastPage => currentPage >= lastPage;
  int get nextPage => currentPage + 1;

  @override
  List<Object?> get props => [currentPage, lastPage, perPage, total];
}
