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



class ApiMeta {
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  ApiMeta({
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  factory ApiMeta.fromJson(Map<String, dynamic> json) {
    return ApiMeta(
      total: json['total'] ?? 0,
      page: json['page'] ?? 1,
      limit: json['limit'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'page': page,
      'limit': limit,
      'totalPages': totalPages,
    };
  }
}
