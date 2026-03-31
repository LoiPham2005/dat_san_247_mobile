import 'package:json_annotation/json_annotation.dart';

part 'api_paginated_data.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class ApiPaginatedData<T> {
  @JsonKey(name: 'data')
  final List<T> data;
  
  @JsonKey(name: 'meta')
  final ApiMeta? meta;

  ApiPaginatedData({
    required this.data,
    this.meta,
  });

  factory ApiPaginatedData.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      _$ApiPaginatedDataFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) =>
      _$ApiPaginatedDataToJson(this, toJsonT);
}

@JsonSerializable()
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

  factory ApiMeta.fromJson(Map<String, dynamic> json) => _$ApiMetaFromJson(json);

  Map<String, dynamic> toJson() => _$ApiMetaToJson(this);
}
