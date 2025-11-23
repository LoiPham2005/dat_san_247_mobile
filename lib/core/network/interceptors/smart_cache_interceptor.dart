// ════════════════════════════════════════════════════════════════
// 📁 lib/core/cache/smart_cache_interceptor.dart
// ════════════════════════════════════════════════════════════════
import 'package:dio/dio.dart';
import 'package:dat_san_247_mobile/core/cache/cache_config.dart';
import 'package:dat_san_247_mobile/core/cache/cache_strategy.dart';
import 'package:injectable/injectable.dart';


/// 🧠 Smart cache interceptor - Auto-apply cache strategies
@LazySingleton()
class SmartCacheInterceptor extends Interceptor {
  /// Endpoint-specific cache strategies
  static const _strategies = <String, CacheStrategy>{
    // 🚫 No Cache - Auth & Payments
    '/auth/login': CacheStrategy.noCache,
    '/auth/logout': CacheStrategy.noCache,
    '/auth/refresh': CacheStrategy.noCache,
    '/payment': CacheStrategy.noCache,
    '/orders/create': CacheStrategy.noCache,
    '/cart': CacheStrategy.noCache,

    // ⚡ Short-term (5 min) - Frequent changes
    '/products/search': CacheStrategy.shortTerm,
    '/orders/recent': CacheStrategy.shortTerm,
    '/notifications': CacheStrategy.shortTerm,
    '/user/feed': CacheStrategy.shortTerm,

    // ⏱️ Medium-term (1 hour) - Stable data
    '/products': CacheStrategy.mediumTerm,
    '/user/profile': CacheStrategy.mediumTerm,
    '/venues': CacheStrategy.mediumTerm,

    // 📅 Long-term (1 day) - Rarely changes
    '/categories': CacheStrategy.longTerm,
    '/brands': CacheStrategy.longTerm,
    '/config/app': CacheStrategy.longTerm,
    '/sports': CacheStrategy.longTerm,

    // ♾️ Permanent - Static data
    '/config/countries': CacheStrategy.permanent,
    '/config/languages': CacheStrategy.permanent,
    '/config/currencies': CacheStrategy.permanent,
  };

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Skip cache for non-GET methods (unless forced)
    if (options.method != 'GET' &&
        !options.extra.containsKey('cache_strategy')) {
      return handler.next(options);
    }

    // Get strategy: custom > endpoint-specific > default
    final strategy = _getStrategy(options);
    final cacheOptions = CacheConfig.getOptions(strategy);

    // Apply cache options
    options.extra.addAll(cacheOptions.toExtra());

    handler.next(options);
  }

  /// Determine cache strategy for request
  CacheStrategy _getStrategy(RequestOptions options) {
    // 1. Custom strategy from caller (highest priority)
    final custom = options.extra['cache_strategy'] as CacheStrategy?;
    if (custom != null) return custom;

    // 2. Exact endpoint match
    final path = options.path;
    if (_strategies.containsKey(path)) {
      return _strategies[path]!;
    }

    // 3. Partial match (prefix)
    for (final entry in _strategies.entries) {
      if (path.startsWith(entry.key)) {
        return entry.value;
      }
    }

    // 4. Default: medium-term for GET, no-cache for others
    return options.method == 'GET'
        ? CacheStrategy.mediumTerm
        : CacheStrategy.noCache;
  }

  // ═══════════════════════════════════════════════════════════════
  // Helper Methods
  // ═══════════════════════════════════════════════════════════════

  /// Force refresh - Bypass cache
  static Options forceRefresh() {
    return Options(extra: {'cache_strategy': CacheStrategy.noCache});
  }

  /// Use specific cache strategy
  static Options withStrategy(CacheStrategy strategy) {
    return Options(extra: {'cache_strategy': strategy});
  }

  /// Cache first - Prefer cache over network
  static Options cacheFirst() {
    return Options(extra: {'cache_strategy': CacheStrategy.cacheFirst});
  }

  /// Network first - Prefer network, fallback to cache
  static Options networkFirst() {
    return Options(extra: {'cache_strategy': CacheStrategy.networkFirst});
  }
}
