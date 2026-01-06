// import 'package:equatable/equatable.dart';

// /// Response wrapper chuẩn từ API
// class ApiResponse<T> extends Equatable {
//   const ApiResponse({
//     required this.success,
//     this.data,
//     this.message,
//     this.errors,
//     this.statusCode,
//   });

//   final bool success;
//   final T? data;
//   final String? message;
//   final Map<String, List<String>>? errors;
//   final int? statusCode;

//   factory ApiResponse.fromJson(
//     Map<String, dynamic> json,
//     T Function(dynamic)? fromJsonT,
//   ) {
//     final success = json['success'] ?? json['status'] == 'success';
//     final rawData = json['data'];

//     return ApiResponse(
//       success: success,
//       data: rawData != null && fromJsonT != null ? fromJsonT(rawData) : rawData,
//       message: json['message'] as String?,
//       errors: _parseErrors(json['errors']),
//       statusCode: json['status_code'] as int?,
//     );
//   }

//   static Map<String, List<String>>? _parseErrors(dynamic errors) {
//     if (errors == null) return null;
//     if (errors is Map<String, dynamic>) {
//       return errors.map((key, value) {
//         if (value is List) {
//           return MapEntry(key, value.cast<String>());
//         }
//         return MapEntry(key, [value.toString()]);
//       });
//     }
//     return null;
//   }

//   /// Lấy error message đầu tiên
//   String? get firstError {
//     if (errors == null || errors!.isEmpty) return message;
//     final firstKey = errors!.keys.first;
//     final firstErrors = errors![firstKey];
//     return firstErrors?.isNotEmpty == true ? firstErrors!.first : message;
//   }

//   /// Lấy tất cả errors dạng list
//   List<String> get allErrors {
//     if (errors == null) return message != null ? [message!] : [];
//     return errors!.values.expand((e) => e).toList();
//   }

//   @override
//   List<Object?> get props => [success, data, message, errors, statusCode];
// }
