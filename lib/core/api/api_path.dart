class ApiPath {
  // static const String domain = 'http://localhost:3000/api/';
  static const String domain = 'http://192.168.1.31:3000/api/';
  // static const String domain = 'http://192.168.1.53:3000/api/';
  // static const String domain = 'https://backend-doantotnghiep-1.onrender.com/api';
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
