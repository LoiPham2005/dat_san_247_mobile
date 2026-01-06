// ════════════════════════════════════════════════════════════
// 📁 lib/core/state_management/bloc/bloc_status.dart (OPTIMIZED)
// ════════════════════════════════════════════════════════════

/// Status cho data operations (CRUD, API calls)
enum BlocStatus {
  /// Trạng thái ban đầu
  initial,

  /// Đang tải dữ liệu (lần đầu)
  loading,

  /// Đang refresh (pull-to-refresh) - vẫn hiển thị data cũ
  refreshing,

  /// Đang load more (pagination)
  loadingMore,

  /// Đã load thành công và có data
  loaded,

  /// Đã load thành công nhưng không có data
  empty,

  /// Có lỗi xảy ra
  failure,

  /// Đang thực hiện mutation (create/update/delete)
  submitting,

  /// Mutation thành công
  success,

  // ❌ BỎ: validating, searching, cancelling, cancelled
  // → Dùng loading + metadata thay thế
}

/// Status cho authentication
enum AuthStatus {
  /// Chưa xác thực (chưa đăng nhập)
  unauthenticated,

  /// Đang xác thực
  authenticating,

  /// Đã xác thực (đã đăng nhập)
  authenticated,

  /// Token expired, cần refresh
  tokenExpired,

  /// Không có quyền truy cập
  unauthorized,

  /// Đăng xuất
  loggedOut,
}
