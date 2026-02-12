class PaginationModel<T> {
  final List<T> items;
  final int totalItems;
  final int currentPage;
  final int totalPages;
  final bool hasNextPage;

  PaginationModel({
    required this.items,
    required this.totalItems,
    required this.currentPage,
    required this.totalPages,
    required this.hasNextPage,
  });

  factory PaginationModel.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    return PaginationModel(
      items: (json['items'] as List).map((e) => fromJsonT(e)).toList(),
      totalItems: json['totalItems'] as int? ?? 0,
      currentPage: json['currentPage'] as int? ?? 1,
      totalPages: json['totalPages'] as int? ?? 1,
      hasNextPage: json['hasNextPage'] as bool? ?? false,
    );
  }
}
