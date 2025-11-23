
// ════════════════════════════════════════════════════════════════
// 📁 lib/core/cache/cache_strategy.dart
// ════════════════════════════════════════════════════════════════
/// Cache strategies cho từng loại data
enum CacheStrategy {
  /// 🚫 Không cache - Realtime/sensitive data
  noCache,

  /// ⚡ 5 phút - Data thay đổi thường xuyên
  shortTerm,

  /// ⏱️ 1 giờ - Data ổn định
  mediumTerm,

  /// 📅 1 ngày - Data ít thay đổi
  longTerm,

  /// ♾️ Vĩnh viễn - Static data
  permanent,

  /// 🔄 Network first, fallback cache
  networkFirst,

  /// 💾 Cache first, fallback network
  cacheFirst,
}
