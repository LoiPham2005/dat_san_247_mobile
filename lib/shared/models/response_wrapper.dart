class ResponseWrapper<T> {
  final bool success;
  final String? message;
  final T? data;
  final int? statusCode;

  ResponseWrapper({this.success = true, this.message, this.data, this.statusCode});

  factory ResponseWrapper.fromJson(Map<String, dynamic> json, T Function(Object? json) fromJsonT) {
    return ResponseWrapper(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String?,
      data: json['data'] != null ? fromJsonT(json['data']) : null,
      statusCode: json['statusCode'] as int?,
    );
  }
}
