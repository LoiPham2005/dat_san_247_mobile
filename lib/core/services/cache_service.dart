// ════════════════════════════════════════════════════════════════
// 🧠 5. Cache Service
// ════════════════════════════════════════════════════════════════
// lib/core/services/cache_service.dart
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:injectable/injectable.dart';
import '../network/cache/cache_config.dart';

@LazySingleton()
class CacheService {
  Future<void> clearAll() async {
    await CacheConfig.cacheStore.clean();
  }

  Future<void> clearByPattern(String pattern) async {
    await CacheConfig.cacheStore.clean(
      staleOnly: false,
      priorityOrBelow: CachePriority.high,
    );
  }

  Future<void> clearExpired() async {
    await CacheConfig.cacheStore.clean(staleOnly: true);
  }

  Future<void> deleteByKey(String key) async {
    await CacheConfig.cacheStore.delete(key);
  }
}
