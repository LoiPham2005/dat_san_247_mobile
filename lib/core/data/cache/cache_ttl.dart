// 📁 lib/core/data/cache/cache_ttl.dart
// TTL constants dùng chung — thay cho cache_strategy.dart + cache_config.dart
//
// Dùng:
//   await cache.setJson('key', data, ttl: CacheTtl.short);
//   await cache.setJson('key', data, ttl: CacheTtl.day);

abstract final class CacheTtl {
  static const short = Duration(minutes: 5); // data thay đổi thường
  static const medium = Duration(hours: 1); // data ổn định
  static const long = Duration(days: 1); // data ít thay đổi
  static const week = Duration(days: 7);
  static const permanent = Duration(days: 365); // static data
}
