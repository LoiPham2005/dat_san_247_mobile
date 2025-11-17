// ════════════════════════════════════════════════════════════════
// 🧠 1. Cache Strategy Enum
// ════════════════════════════════════════════════════════════════
// lib/core/network/cache/cache_strategy.dart
enum CacheStrategy {
  /// Không cache (realtime data)
  noCache,

  /// Cache ngắn hạn 5 phút (thường xuyên thay đổi)
  shortTerm,

  /// Cache trung hạn 1 giờ (ít thay đổi)
  mediumTerm,

  /// Cache dài hạn 1 ngày (hầu như không đổi)
  longTerm,

  /// Cache vĩnh viễn (static data: config, categories)
  permanent,

  /// Stale-while-revalidate: dùng cache cũ + fetch mới ở background
  staleWhileRevalidate,

  /// Network-first: ưu tiên network, fallback cache khi offline
  networkFirst,

  /// Cache-first: ưu tiên cache, chỉ fetch khi cache hết hạn
  cacheFirst,
}
