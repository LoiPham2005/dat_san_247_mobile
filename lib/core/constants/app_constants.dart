// lib/core/constants/app_constants.dart
class AppConstants {
  AppConstants._();

  // PackageId
  static const String androidPackageId = 'com.example.dat_san_247_mobile';
  static const String iosBundleId = 'com.example.dat_san_247_mobile';
  // App Info
  static const String appName = 'My Flutter App';
  static const String appNameDev = 'Base App (Dev)';
  static const String appNameStg = 'Base App (Stg)';
  static const String appNameProd = 'Base App';

  static const String appVersion = '1.0.0';

  // Timeouts
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // Cache
  static const Duration cacheExpiration = Duration(hours: 24);

  // Animation
  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);

  // Retry Configuration
  static const int maxRetries = 3;
  static const Duration retryDelay = Duration(seconds: 1);
  static const List<int> retryStatusCodes = [408, 500, 502, 503, 504];
}
