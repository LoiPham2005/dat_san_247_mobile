// ════════════════════════════════════════════════════════════════
// 📁 lib/core/cache/app_cache_manager.dart
// ════════════════════════════════════════════════════════════════
import 'dart:io';

import 'package:dat_san_247_mobile/core/cache/cache_config.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_cache_interceptor_db_store/dio_cache_interceptor_db_store.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:injectable/injectable.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../database/daos/local_cache_dao.dart';
import '../utils/logger.dart';
import 'models/cache_stats.dart';

/// 🎯 Unified Cache Manager
///
/// Manages 3 cache layers:
/// 1. **API Cache** (SQLite via dio_cache_interceptor) — HTTP response caching
/// 2. **File Cache** (flutter_cache_manager) — Images, videos, documents
/// 3. **Local Cache** (Drift/SQLite via LocalCacheDao) — Key-value data caching
@lazySingleton
class AppCacheManager {
  // ═══════════════════════════════════════════════════════════════
  // Dependencies
  // ═══════════════════════════════════════════════════════════════

  final LocalCacheDao _localCacheDao;

  AppCacheManager(this._localCacheDao);

  // ═══════════════════════════════════════════════════════════════
  // Cache keys (constants)
  // ═══════════════════════════════════════════════════════════════
  static const String _imageCacheKey = 'imageCache';
  static const String _videoCacheKey = 'videoCache';
  static const String _docCacheKey = 'docCache';

  // ═══════════════════════════════════════════════════════════════
  // Stores
  // ═══════════════════════════════════════════════════════════════

  late final CacheStore _apiCacheStore;
  late final CacheManager _imageCacheManager;
  late final CacheManager _videoCacheManager;
  late final CacheManager _documentCacheManager;

  // ═══════════════════════════════════════════════════════════════
  // Stats
  // ═══════════════════════════════════════════════════════════════

  int _hits = 0;
  int _misses = 0;
  DateTime? _lastCleared;

  int get hits => _hits;
  int get misses => _misses;
  double get hitRate => (_hits + _misses == 0) ? 0 : _hits / (_hits + _misses);

  // ═══════════════════════════════════════════════════════════════
  // Initialization
  // ═══════════════════════════════════════════════════════════════

  /// Initialize all caches (call once at app startup)
  Future<void> initialize() async {
    try {
      final sw = Stopwatch()..start();

      // 1. Initialize API cache (SQLite)
      await _initApiCache();

      // 2. Initialize file caches
      _initFileCaches();

      // 3. Auto cleanup expired entries on startup
      await _autoCleanup();

      sw.stop();
      Logger.success('✅ Cache initialized in ${sw.elapsedMilliseconds}ms');
    } catch (e, stack) {
      Logger.error('❌ Cache init failed', error: e, stackTrace: stack);
      rethrow;
    }
  }

  /// Initialize API cache with SQL backend (SQLite)
  Future<void> _initApiCache() async {
    try {
      // Get database directory
      final docDir = await getApplicationDocumentsDirectory();
      final dbPath = p.join(docDir.path, 'app_cache.db');

      // Create SQL cache store (SQLite) - ACID compliant
      _apiCacheStore = DbCacheStore(databasePath: dbPath);

      // Register with CacheConfig
      CacheConfig.initialize(_apiCacheStore);

      Logger.success('✅ API cache (SQLite) ready');
    } catch (e) {
      Logger.warning('⚠️ SQLite failed, using MemCache: $e');
      _apiCacheStore = MemCacheStore();
      CacheConfig.initialize(_apiCacheStore);
    }
  }

  /// Initialize file caches (images, videos, documents)
  void _initFileCaches() {
    _imageCacheManager = CacheManager(
      Config(_imageCacheKey, stalePeriod: const Duration(days: 30), maxNrOfCacheObjects: 500),
    );

    _videoCacheManager = CacheManager(
      Config(_videoCacheKey, stalePeriod: const Duration(days: 60), maxNrOfCacheObjects: 100),
    );

    _documentCacheManager = CacheManager(
      Config(_docCacheKey, stalePeriod: const Duration(days: 90), maxNrOfCacheObjects: 100),
    );

    Logger.success('✅ File caches ready');
  }

  /// Auto cleanup on startup
  Future<void> _autoCleanup() async {
    try {
      // Clean expired API cache
      await _apiCacheStore.clean(staleOnly: true);

      // Clean expired local cache entries
      final expiredCount = await _localCacheDao.clearExpired();

      if (expiredCount > 0) {
        Logger.info(
          '🧹 Auto-cleanup: removed $expiredCount expired local cache entries',
          tag: 'CACHE',
        );
      }
    } catch (e) {
      Logger.warning('⚠️ Auto-cleanup failed: $e', tag: 'CACHE');
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // Public Getters
  // ═══════════════════════════════════════════════════════════════

  CacheManager get imageCache => _imageCacheManager;
  CacheManager get videoCache => _videoCacheManager;
  CacheManager get documentCache => _documentCacheManager;

  /// Access local cache DAO for key-value caching
  LocalCacheDao get localCache => _localCacheDao;

  // ═══════════════════════════════════════════════════════════════
  // Cache Operations
  // ═══════════════════════════════════════════════════════════════

  void recordHit() => _hits++;
  void recordMiss() => _misses++;
  void resetStats() {
    _hits = 0;
    _misses = 0;
  }

  // ═══════════════════════════════════════════════════════════════
  // Clear Operations
  // ═══════════════════════════════════════════════════════════════

  /// Clear API cache only
  Future<void> clearApiCache() async {
    try {
      await _apiCacheStore.clean();
      _lastCleared = DateTime.now();
      Logger.success('✅ API cache cleared');
    } catch (e) {
      Logger.error('❌ Clear API cache failed: $e');
    }
  }

  /// Clear all file caches
  Future<void> clearFileCaches() async {
    try {
      await Future.wait([
        _imageCacheManager.emptyCache(),
        _videoCacheManager.emptyCache(),
        _documentCacheManager.emptyCache(),
      ]);
      Logger.success('✅ File caches cleared');
    } catch (e) {
      Logger.error('❌ Clear file caches failed: $e');
    }
  }

  /// Clear local cache (Drift key-value)
  Future<void> clearLocalCache() async {
    try {
      final count = await _localCacheDao.clearAll();
      Logger.success('✅ Local cache cleared ($count entries)');
    } catch (e) {
      Logger.error('❌ Clear local cache failed: $e');
    }
  }

  /// Clear everything
  Future<void> clearAll() async {
    await Future.wait([clearApiCache(), clearFileCaches(), clearLocalCache()]);
    resetStats();
    _lastCleared = DateTime.now();
    Logger.success('✅ All caches cleared');
  }

  /// Clear by pattern (with priority filter)
  Future<void> clearByPattern({CachePriority? priorityOrBelow}) async {
    try {
      await _apiCacheStore.clean(
        staleOnly: false,
        priorityOrBelow: priorityOrBelow ?? CachePriority.high,
      );
      Logger.success('✅ Cache cleared by pattern');
    } catch (e) {
      Logger.error('❌ Clear by pattern failed: $e');
    }
  }

  /// Clear expired cache entries only (all layers)
  Future<void> clearExpired() async {
    try {
      await Future.wait([_apiCacheStore.clean(staleOnly: true), _localCacheDao.clearExpired()]);
      Logger.success('✅ Expired cache cleared');
    } catch (e) {
      Logger.error('❌ Clear expired failed: $e');
    }
  }

  /// Delete cache by specific key (API cache)
  Future<void> deleteByKey(String key) async {
    try {
      await _apiCacheStore.delete(key);
      Logger.success('✅ Cache deleted: $key');
    } catch (e) {
      Logger.error('❌ Delete by key failed: $e');
    }
  }

  /// Smart clear - Remove old entries only
  Future<void> clearStale({Duration maxAge = const Duration(days: 7)}) async {
    try {
      if (_lastCleared == null || DateTime.now().difference(_lastCleared!) > maxAge) {
        await clearApiCache();
      }
      Logger.success('✅ Stale cache cleared');
    } catch (e) {
      Logger.error('❌ Clear stale failed: $e');
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // Statistics & Monitoring
  // ═══════════════════════════════════════════════════════════════

  /// Get comprehensive cache statistics
  Future<CacheStats> getStats() async {
    try {
      final results = await Future.wait([
        _countCacheFilesByKey(_imageCacheKey),
        _countCacheFilesByKey(_videoCacheKey),
        _countCacheFilesByKey(_docCacheKey),
        _localCacheDao.count(),
        _getApiCacheSizeBytes(),
        _getFileCacheSizeBytes(),
      ]);

      final imageCount = results[0];
      final videoCount = results[1];
      final docCount = results[2];
      final localCacheCount = results[3];
      final apiCacheSize = results[4];
      final fileCacheSize = results[5];

      return CacheStats(
        imageCount: imageCount,
        videoCount: videoCount,
        docCount: docCount,
        totalFileCount: imageCount + videoCount + docCount,
        localCacheCount: localCacheCount,
        hits: _hits,
        misses: _misses,
        hitRate: hitRate,
        apiCacheSizeBytes: apiCacheSize,
        fileCacheSizeBytes: fileCacheSize,
        totalSizeBytes: apiCacheSize + fileCacheSize,
        lastCleared: _lastCleared,
      );
    } catch (e) {
      Logger.error('❌ Get stats failed: $e');
      return CacheStats.empty();
    }
  }

  /// Get API cache database size in bytes
  Future<int> _getApiCacheSizeBytes() async {
    try {
      final docDir = await getApplicationDocumentsDirectory();
      final dbFile = File(p.join(docDir.path, 'app_cache.db'));
      return dbFile.existsSync() ? await dbFile.length() : 0;
    } catch (_) {
      return 0;
    }
  }

  /// Get total file cache size in bytes
  Future<int> _getFileCacheSizeBytes() async {
    try {
      int totalSize = 0;
      final baseCacheDir = await getTemporaryDirectory();

      for (final key in [_imageCacheKey, _videoCacheKey, _docCacheKey]) {
        final cacheDir = Directory('${baseCacheDir.path}/flutter_cache_manager/$key');

        if (await cacheDir.exists()) {
          await for (final entity in cacheDir.list(recursive: true)) {
            if (entity is File) {
              totalSize += await entity.length();
            }
          }
        }
      }

      return totalSize;
    } catch (_) {
      return 0;
    }
  }

  /// Count cache files by key
  Future<int> _countCacheFilesByKey(String cacheKey) async {
    try {
      final baseCacheDir = await getTemporaryDirectory();
      final cacheDir = Directory('${baseCacheDir.path}/flutter_cache_manager/$cacheKey');

      if (await cacheDir.exists()) {
        final files = await cacheDir
            .list(recursive: true)
            .where((entity) => entity is File)
            .toList();
        return files.length;
      }

      return 0;
    } catch (e) {
      Logger.warning('⚠️ Error counting cache files for $cacheKey: $e');
      return 0;
    }
  }

  /// Print statistics to console
  Future<void> printStats() async {
    final stats = await getStats();
    const borderWidth = 55;
    String pad(String text) => text.padRight(borderWidth - 2);

    final info = [
      '📊 CACHE STATISTICS',
      '📷 Images:       ${stats.imageCount} files',
      '🎬 Videos:       ${stats.videoCount} files',
      '📄 Documents:    ${stats.docCount} files',
      '🗄️ Local Cache:  ${stats.localCacheCount} entries',
      '────────────────────────────────────────',
      '📦 Total Files:  ${stats.totalFileCount}',
      '💾 API Cache:    ${stats.formattedApiCacheSize}',
      '📁 File Cache:   ${stats.formattedFileCacheSize}',
      '📊 Total Size:   ${stats.formattedTotalSize}',
      '────────────────────────────────────────',
      '🎯 Hit Rate:     ${(stats.hitRate * 100).toStringAsFixed(1)}%',
      '💚 Hits:         ${stats.hits}',
      '❌ Misses:       ${stats.misses}',
      if (stats.lastCleared != null) '🕐 Last cleared: ${stats.lastCleared}',
    ];

    final buffer = StringBuffer()..writeln('╔${'═' * (borderWidth - 1)}');
    for (final line in info) {
      buffer.writeln('║ ${pad(line)}');
      if (line.startsWith('📊 CACHE')) {
        buffer.writeln('╠${'═' * (borderWidth - 1)}');
      }
    }
    buffer.writeln('╚${'═' * (borderWidth - 1)}');

    Logger.info('\n${buffer.toString()}', tag: 'CACHE');
  }
}
