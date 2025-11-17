// lib/core/storage/storage_keys.dart

// ═══════════════════════════════════════════════════════════════
// SENSITIVE DATA KEYS (FlutterSecureStorage)
// ═══════════════════════════════════════════════════════════════
class SecureStorageKeys {
  SecureStorageKeys._(); // Private constructor

  // Tokens (SENSITIVE - phải lưu encrypted)
  static const String accessToken = 'secure_access_token';
  static const String refreshToken = 'secure_refresh_token';

  // Credentials (SENSITIVE)
  static const String password = 'secure_password';
  static const String pin = 'secure_pin';
  static const String biometric = 'secure_biometric';
}

class StorageKeys {
  StorageKeys._(); // Private constructor để không ai có thể tạo instance

  // ═══════════════════════════════════════════════════════════════
  // NON-SENSITIVE DATA (SharedPreferences)
  // ═══════════════════════════════════════════════════════════════

  // Auth
  static const String userProfile = 'user_profile';
  static const String isLogin = 'is_login';

  // App Settings
  static const String isFirstRun = 'is_first_run';
  static const String themeMode = 'theme_mode';
  static const String languageCode = 'language_code';

  static const String hasSeenOnboarding = 'has_seen_onboarding';

  static const String keyThemeColor = 'theme_color';
  static const String keyThemeMode = 'theme_mode';
}
