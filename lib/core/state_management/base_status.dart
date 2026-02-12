// ════════════════════════════════════════════════════════════════
// 📁 lib/core/state_management/base_status.dart
// ════════════════════════════════════════════════════════════════

/// 🎯 Unified status for any state management (Bloc, Cubit, GetX, etc.)
enum BaseStatus {
  /// Initial state, nothing has happened yet
  initial,

  /// First time loading data (Query)
  loading,

  /// Refreshing data while keeping old data (Query/Pull-to-refresh)
  refreshing,

  /// Loading more data for pagination (Query)
  loadingMore,

  /// Data loaded successfully (Query)
  loaded,

  /// Data loaded successfully but result is empty (Query)
  empty,

  /// Operation failed (Query or Mutation)
  failure,

  /// Processing an action (POST/PUT/DELETE - Mutation)
  submitting,

  /// Action completed successfully (Mutation)
  success,
}

/// 🔐 Status for authentication-specific flows
enum AuthStatus {
  /// Not checked yet
  initial,

  /// Not authenticated (not logged in)
  unauthenticated,

  /// Authentication in progress
  authenticating,

  /// Authenticated successfully
  authenticated,

  /// Session expired, needs to re-login or refresh
  tokenExpired,

  /// Logged in but has no permission for current action
  unauthorized,

  /// Logout in progress or done
  loggedOut,
}
