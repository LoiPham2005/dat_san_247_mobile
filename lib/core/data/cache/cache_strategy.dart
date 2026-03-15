// 📁 lib/core/data/cache/cache_strategy.dart
import 'cache_ttl.dart';

/// Các chiến lược cache cho network request.
enum CacheStrategy {
  /// Không dùng cache, luôn fetch từ network.
  noCache(null),

  /// Cache ngắn hạn (5 phút).
  shortTerm(CacheTtl.short),

  /// Cache trung bình (1 giờ).
  mediumTerm(CacheTtl.medium),

  /// Cache dài hạn (1 ngày).
  longTerm(CacheTtl.long),

  /// Cache vĩnh viễn (1 năm).
  permanent(CacheTtl.permanent),

  /// Ưu tiên cache, nếu không có mới fetch.
  cacheFirst(CacheTtl.medium),

  /// Ưu tiên fetch, nếu lỗi mới dùng cache (fallback).
  networkFirst(CacheTtl.medium);

  final Duration? ttl;
  const CacheStrategy(this.ttl);
}
