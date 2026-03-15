// // ════════════════════════════════════════════════════════════════
// // 📁 lib/core/network/interceptors/error_interceptor.dart (SIMPLIFIED)
// // ════════════════════════════════════════════════════════════════
// import 'package:dio/dio.dart';
// import 'package:injectable/injectable.dart';

// import '../../utils/logger.dart';

// /// ✅ SIMPLIFIED: Chỉ log error, KHÔNG parse
// /// Việc parse error đã được xử lý trong ApiClient._handleError()
// @LazySingleton()
// class ErrorInterceptor extends Interceptor {
//   @override
//   void onError(DioException err, ErrorInterceptorHandler handler) {
//     // Skip log cho cancelled requests
//     if (err.type != DioExceptionType.cancel) {
//       _logError(err);
//     }

//     // Pass error as-is, ApiClient sẽ handle
//     handler.next(err);
//   }

//   void _logError(DioException err) {
//     final method = err.requestOptions.method;
//     final path = err.requestOptions.path;
//     final statusCode = err.response?.statusCode;

//     Logger.error(
//       '[$method] $path${statusCode != null ? ' ($statusCode)' : ''}',
//       error: err.message,
//       tag: 'HTTP',
//     );
//   }
// }
