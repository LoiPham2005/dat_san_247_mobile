// lib/core/constants/api_constants.dart
class ApiConstants {
  ApiConstants._();

  // Base URLs
  // static const String baseUrlDev = 'http://192.168.60.102:3000/api';
  // static const String baseUrlStaging = 'http://192.168.60.103:3000/api';
  // static const String baseUrlProd = 'http://192.168.60.103:3000/api';


  // Endpoints
  // static const String login = '/auth/login';
  // static const String register = '/auth/register';
  static const String refreshToken = '/auth/refresh-token';
  static const String forgotPassword = '/auth/forgot-password';
  // static const String resetPassword = '/auth/reset-password';
  static const String profile = '/user/profile';
  // static const String logout = '/auth/logout';


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







  static const String domainImage = 'https://tht.nanoweb.vn/';
  static const String domainVideo = 'https://tht.nanoweb.vn/';
  static const String key = 'key_nanoweb_v2_2021_real';
  static const String startApp = '/api/home/start';

  //auth
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String sendEmail = '/auth/sendOtp';
  static const String sendOtp = '/auth/checkOTP';
  static const String resetPassword = '/auth/reset-password';
  static const String changPassword = '/auth/change-password';
  static const String editInformation = '/auth/edit/';
  static const String deleteOtp = '/auth/deleteOTP/';

  // banner
  static const String banner = '/banners';

  // sport category
  static const String sportCategory = '/sport-categories';

  // venue
  static const String venue = '/venues';

  // staticst
  static const String venueStatistics = '/venue-statistics/quick-stats';

  //location
  static const provinces = '/address/province';
  static const district = '/address/district?province_id=';
  static const ward = '/address/ward?district_id=';
  static const gps = '/positioning-gps';

  //deeplinks
  static const deepLinksAndroid =
      "https://api.vietqr.io/v2/android-app-deeplinks";

  static const deepLinksIos = "https://api.vietqr.io/v2/ios-app-deeplinks";
}
