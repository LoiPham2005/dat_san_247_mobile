// lib/core/constants/api_constants.dart
class ApiConstants {
  ApiConstants._();

  // Base URLs
  // static const String baseUrlDev = 'http://192.168.60.102:3000/api';
  // static const String baseUrlStaging = 'http://192.168.60.103:3000/api';
  // static const String baseUrlProd = 'http://192.168.60.103:3000/api';

  // Headers
  // static const String headerContentType = 'Content-Type';
  // static const String headerAuthorization = 'Authorization';
  // static const String headerAcceptLanguage = 'Accept-Language';

  // Endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String refreshToken = '/auth/refresh-token';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';
  static const String profile = '/user/profile';
  static const String logout = '/auth/logout';


  static const String products = '/products';
  static const String categories = '/categories';

  // 🔓 Danh sách các API public (không cần xác thực)
  static const List<String> publicEndpoints = [
    login,
    register,
    refreshToken,
    forgotPassword,
    resetPassword,
  ];
}
