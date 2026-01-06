// // ════════════════════════════════════════════════════════════
// // 📁 lib/core/state_management/auth_state.dart (IMPROVED)
// // ════════════════════════════════════════════════════════════

// import 'package:equatable/equatable.dart';
// import 'package:dat_san_247_mobile/core/state_management/bloc/bloc_status.dart';

// /// State chuyên dụng cho Authentication (IMPROVED)
// class AuthState<T> extends Equatable {
//   const AuthState({
//     required this.status,
//     this.user,
//     this.error,
//     this.message,
//     this.exception, // 👈 ✅ THÊM
//     this.isProcessing = false,
//   });

//   final AuthStatus status;
//   final T? user; // 👈 ✅ Generic thay vì dynamic
//   final String? error;
//   final String? message;
//   final Exception? exception; // 👈 ✅ THÊM
//   final bool isProcessing;

//   // ════════════════════════════════════════════════════════════
//   // Factories
//   // ════════════════════════════════════════════════════════════

//   factory AuthState.initial() => const AuthState(
//         status: AuthStatus.unauthenticated,
//       );

//   factory AuthState.authenticating() => const AuthState(
//         status: AuthStatus.authenticating,
//         isProcessing: true,
//       );

//   factory AuthState.authenticated(T user, {String? message}) => AuthState(
//         status: AuthStatus.authenticated,
//         user: user,
//         message: message ?? 'Đăng nhập thành công',
//       );

//   factory AuthState.unauthenticated({String? error}) => AuthState(
//         status: AuthStatus.unauthenticated,
//         error: error,
//       );

//   factory AuthState.unauthorized({String? error, Exception? exception}) =>
//       AuthState(
//         status: AuthStatus.unauthorized,
//         error: error ?? 'Bạn không có quyền truy cập',
//         exception: exception,
//       );

//   factory AuthState.tokenExpired({String? message}) => AuthState(
//         status: AuthStatus.tokenExpired,
//         message: message ?? 'Phiên đăng nhập hết hạn',
//       );

//   factory AuthState.loggedOut({String? message}) => AuthState(
//         status: AuthStatus.loggedOut,
//         message: message ?? 'Đã đăng xuất',
//       );

//   // ════════════════════════════════════════════════════════════
//   // Helpers
//   // ════════════════════════════════════════════════════════════

//   bool get isAuthenticated => status == AuthStatus.authenticated;
//   bool get isUnauthenticated => status == AuthStatus.unauthenticated;
//   bool get isAuthenticating => status == AuthStatus.authenticating;
//   bool get isTokenExpired => status == AuthStatus.tokenExpired;
//   bool get isUnauthorized => status == AuthStatus.unauthorized;
//   bool get isLoggedOut => status == AuthStatus.loggedOut;

//   /// 👈 ✅ THÊM: Có user hay không
//   bool get hasUser => user != null;

//   /// 👈 ✅ THÊM: Có lỗi hay không
//   bool get hasError => error != null || exception != null;

//   /// 👈 ✅ THÊM: Cần đăng nhập lại
//   bool get needsLogin =>
//       isUnauthenticated || isTokenExpired || isLoggedOut || isUnauthorized;

//   // ════════════════════════════════════════════════════════════
//   // CopyWith
//   // ════════════════════════════════════════════════════════════

//   AuthState<T> copyWith({
//     AuthStatus? status,
//     T? user,
//     String? error,
//     String? message,
//     Exception? exception,
//     bool? isProcessing,
//     bool clearError = false, // 👈 ✅ THÊM
//   }) {
//     return AuthState(
//       status: status ?? this.status,
//       user: user ?? this.user,
//       error: clearError ? null : (error ?? this.error),
//       message: message ?? this.message,
//       exception: clearError ? null : (exception ?? this.exception),
//       isProcessing: isProcessing ?? this.isProcessing,
//     );
//   }

//   // ════════════════════════════════════════════════════════════
//   // Equatable
//   // ════════════════════════════════════════════════════════════

//   @override
//   List<Object?> get props => [
//         status,
//         user,
//         error,
//         message,
//         exception,
//         isProcessing,
//       ];

//   @override
//   String toString() {
//     return 'AuthState<$T>('
//         'status: $status, '
//         'hasUser: $hasUser, '
//         'error: $error, '
//         'message: $message'
//         ')';
//   }
// }
