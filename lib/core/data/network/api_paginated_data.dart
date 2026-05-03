// import 'package:json_annotation/json_annotation.dart';

// part 'api_paginated_data.g.dart';

// @JsonSerializable(genericArgumentFactories: true)
// class ApiPaginatedData<T> {
//   @JsonKey(name: 'data')
//   final List<T> data;

//   @JsonKey(name: 'meta')
//   final ApiMeta? meta;

//   ApiPaginatedData({
//     required this.data,
//     this.meta,
//   });

//   factory ApiPaginatedData.fromJson(
//     Map<String, dynamic> json,
//     T Function(Object? json) fromJsonT,
//   ) =>
//       _$ApiPaginatedDataFromJson(json, fromJsonT);

//   Map<String, dynamic> toJson(Object? Function(T value) toJsonT) =>
//       _$ApiPaginatedDataToJson(this, toJsonT);
// }

// @JsonSerializable()
// class ApiMeta {
//   final int total;
//   final int page;
//   final int limit;
//   final int totalPages;

//   ApiMeta({
//     required this.total,
//     required this.page,
//     required this.limit,
//     required this.totalPages,
//   });

//   factory ApiMeta.fromJson(Map<String, dynamic> json) => _$ApiMetaFromJson(json);

//   Map<String, dynamic> toJson() => _$ApiMetaToJson(this);
// }





class ApiPaginatedData<T> {
  final List<T> data;
  final ApiMeta? meta;

  ApiPaginatedData({
    required this.data,
    this.meta,
  });

  factory ApiPaginatedData.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) {
    return ApiPaginatedData<T>(
      data: (json['data'] as List<dynamic>).map((e) => fromJsonT(e)).toList(),
      meta: json['meta'] != null ? ApiMeta.fromJson(json['meta'] as Map<String, dynamic>) : null,
    );
  }

  Map<String, dynamic> toJson(
    Object? Function(T value) toJsonT,
  ) {
    return {
      'data': data.map((e) => toJsonT(e)).toList(),
      'meta': meta?.toJson(),
    };
  }
}



/// 📊 Metadata phân trang từ API
class ApiMeta {
  static const int defaultPage = 1;
  static const int defaultLimit = 10;

  final int total;
  final int page;
  final int limit;
  final int totalPages;

  ApiMeta({required this.total, required this.page, required this.limit, required this.totalPages});

  bool get hasMore => page < totalPages;
  bool get isFirstPage => page == 1;
  int? get nextPage => hasMore ? page + 1 : null;
  int? get prevPage => page > 1 ? page - 1 : null;

  factory ApiMeta.fromJson(Map<String, dynamic> json) {
    return ApiMeta(
      total: (json['total'] as num?)?.toInt() ?? 0,
      page: (json['page'] as num?)?.toInt() ?? defaultPage,
      limit: (json['limit'] as num?)?.toInt() ?? defaultLimit,
      totalPages:
          (json['totalPages'] as num?)?.toInt() ?? (json['total_pages'] as num?)?.toInt() ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {'total': total, 'page': page, 'limit': limit, 'totalPages': totalPages};
  }
}
