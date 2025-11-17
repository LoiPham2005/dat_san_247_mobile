// ════════════════════════════════════════════════════════════════
// 🧠 3. Smart Cache Interceptor
// ════════════════════════════════════════════════════════════════
// lib/core/network/interceptors/smart_cache_interceptor.dart
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../cache/cache_strategy.dart';
import '../cache/cache_config.dart';

@LazySingleton()
class SmartCacheInterceptor extends Interceptor {
  final Map<String, CacheStrategy> _endpointStrategies = {
    // 🚫 No Cache
    '/auth/login': CacheStrategy.noCache,
    '/auth/logout': CacheStrategy.noCache,
    '/auth/refresh': CacheStrategy.noCache,
    '/cart': CacheStrategy.noCache,
    '/orders/create': CacheStrategy.noCache,
    '/payment': CacheStrategy.noCache,

    // ⏱️ Short-term (5 min)
    '/products/search': CacheStrategy.shortTerm,
    '/orders/recent': CacheStrategy.shortTerm,
    '/notifications': CacheStrategy.shortTerm,

    // ⏳ Medium-term (1 hour)
    '/products': CacheStrategy.mediumTerm,
    '/user/profile': CacheStrategy.mediumTerm,

    // 📅 Long-term (1 day)
    '/categories': CacheStrategy.longTerm,
    '/brands': CacheStrategy.longTerm,
    '/config/app': CacheStrategy.longTerm,

    // ♾️ Permanent
    '/config/countries': CacheStrategy.permanent,
    '/config/languages': CacheStrategy.permanent,
  };

  CacheStrategy _getStrategyForPath(String path, String method) {
    // Exact match
    if (_endpointStrategies.containsKey(path)) {
      return _endpointStrategies[path]!;
    }

    // Partial match
    for (var entry in _endpointStrategies.entries) {
      if (path.startsWith(entry.key)) {
        return entry.value;
      }
    }

    // Default: medium-term cho GET, no-cache cho POST/PUT/DELETE
    return method == 'GET'
        ? CacheStrategy.mediumTerm
        : CacheStrategy.noCache;
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Skip cache cho non-GET methods (trừ khi force)
    if (options.method != 'GET' &&
        options.extra['cache_strategy'] == null) {
      return handler.next(options);
    }

    // Custom strategy từ caller
    final customStrategy = options.extra['cache_strategy'] as CacheStrategy?;
    final strategy = customStrategy ?? _getStrategyForPath(
      options.path,
      options.method,
    );

    // Apply cache options
    final cacheOptions = CacheConfig.getOptions(strategy);
    options.extra.addAll(cacheOptions.toExtra());

    handler.next(options);
  }

  /// Force refresh (bỏ qua cache)
  static Options forceRefresh() {
    return Options(
      extra: {'cache_strategy': CacheStrategy.noCache},
    );
  }

  /// Override cache strategy
  static Options withStrategy(CacheStrategy strategy) {
    return Options(
      extra: {'cache_strategy': strategy},
    );
  }
}
