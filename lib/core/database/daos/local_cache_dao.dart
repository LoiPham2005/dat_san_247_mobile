// ════════════════════════════════════════════════════════════════
// 📁 lib/core/database/daos/local_cache_dao.dart
// ════════════════════════════════════════════════════════════════
import 'dart:convert';

import 'package:dat_san_247_mobile/core/database/app_database.dart';
import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';

import '../../utils/logger.dart';

/// 🗄️ DAO for local key-value cache with TTL support
///
/// Uses Drift/SQLite for ACID-compliant persistent caching.
/// Supports:
/// - Key-value storage with optional TTL (Time-To-Live)
/// - Auto-expiry on read
/// - Batch operations
/// - Pattern-based key queries
/// - JSON serialization helpers
@lazySingleton
class LocalCacheDao {
  final AppDatabase _db;

  LocalCacheDao(this._db);

  // ═══════════════════════════════════════════════════════════════
  // WRITE Operations
  // ═══════════════════════════════════════════════════════════════

  /// Put raw bytes into cache with optional TTL
  Future<void> put(String key, Uint8List data, {Duration? ttl}) async {
    try {
      final expiry = ttl != null ? DateTime.now().add(ttl).millisecondsSinceEpoch : null;

      await _db
          .into(_db.localCacheItems)
          .insertOnConflictUpdate(
            LocalCacheItemsCompanion.insert(key: key, data: data, expiry: Value(expiry)),
          );
    } catch (e, stack) {
      Logger.error(
        '❌ Cache put failed for key: $key',
        error: e,
        stackTrace: stack,
        tag: 'CACHE_DAO',
      );
    }
  }

  /// Put a JSON-serializable object into cache
  Future<void> putJson(String key, Map<String, dynamic> json, {Duration? ttl}) async {
    final encoded = utf8.encode(jsonEncode(json));
    await put(key, Uint8List.fromList(encoded), ttl: ttl);
  }

  /// Put a String value into cache
  Future<void> putString(String key, String value, {Duration? ttl}) async {
    final encoded = utf8.encode(value);
    await put(key, Uint8List.fromList(encoded), ttl: ttl);
  }

  /// Put a list of JSON objects into cache
  Future<void> putJsonList(String key, List<Map<String, dynamic>> jsonList, {Duration? ttl}) async {
    final encoded = utf8.encode(jsonEncode(jsonList));
    await put(key, Uint8List.fromList(encoded), ttl: ttl);
  }

  // ═══════════════════════════════════════════════════════════════
  // READ Operations
  // ═══════════════════════════════════════════════════════════════

  /// Get raw bytes from cache (returns null if not found or expired)
  Future<Uint8List?> get(String key) async {
    try {
      final query = _db.select(_db.localCacheItems)..where((t) => t.key.equals(key));

      final item = await query.getSingleOrNull();
      if (item == null) return null;

      // Check expiry
      if (_isExpired(item.expiry)) {
        await delete(key);
        return null;
      }

      return item.data;
    } catch (e, stack) {
      Logger.error(
        '❌ Cache get failed for key: $key',
        error: e,
        stackTrace: stack,
        tag: 'CACHE_DAO',
      );
      return null;
    }
  }

  /// Get a JSON object from cache
  Future<Map<String, dynamic>?> getJson(String key) async {
    final data = await get(key);
    if (data == null) return null;

    try {
      final decoded = utf8.decode(data);
      return jsonDecode(decoded) as Map<String, dynamic>;
    } catch (e) {
      Logger.warning('⚠️ Cache JSON decode failed for key: $key', tag: 'CACHE_DAO');
      await delete(key);
      return null;
    }
  }

  /// Get a String value from cache
  Future<String?> getString(String key) async {
    final data = await get(key);
    if (data == null) return null;

    try {
      return utf8.decode(data);
    } catch (e) {
      Logger.warning('⚠️ Cache String decode failed for key: $key', tag: 'CACHE_DAO');
      await delete(key);
      return null;
    }
  }

  /// Get a list of JSON objects from cache
  Future<List<Map<String, dynamic>>?> getJsonList(String key) async {
    final data = await get(key);
    if (data == null) return null;

    try {
      final decoded = utf8.decode(data);
      final list = jsonDecode(decoded) as List;
      return list.cast<Map<String, dynamic>>();
    } catch (e) {
      Logger.warning('⚠️ Cache JSON list decode failed for key: $key', tag: 'CACHE_DAO');
      await delete(key);
      return null;
    }
  }

  /// Check if a key exists and is not expired
  Future<bool> has(String key) async {
    final data = await get(key);
    return data != null;
  }

  // ═══════════════════════════════════════════════════════════════
  // DELETE Operations
  // ═══════════════════════════════════════════════════════════════

  /// Delete a specific key
  Future<void> delete(String key) async {
    try {
      await (_db.delete(_db.localCacheItems)..where((t) => t.key.equals(key))).go();
    } catch (e, stack) {
      Logger.error(
        '❌ Cache delete failed for key: $key',
        error: e,
        stackTrace: stack,
        tag: 'CACHE_DAO',
      );
    }
  }

  /// Delete all entries matching a key prefix
  /// Example: deleteByPrefix('user_') removes 'user_profile', 'user_settings', etc.
  Future<int> deleteByPrefix(String prefix) async {
    try {
      return await (_db.delete(_db.localCacheItems)..where((t) => t.key.like('$prefix%'))).go();
    } catch (e, stack) {
      Logger.error(
        '❌ Cache deleteByPrefix failed for: $prefix',
        error: e,
        stackTrace: stack,
        tag: 'CACHE_DAO',
      );
      return 0;
    }
  }

  /// Clear all expired entries
  Future<int> clearExpired() async {
    try {
      final now = DateTime.now().millisecondsSinceEpoch;
      final count = await (_db.delete(
        _db.localCacheItems,
      )..where((t) => t.expiry.isNotNull() & t.expiry.isSmallerThanValue(now))).go();

      if (count > 0) {
        Logger.info('🧹 Cleared $count expired cache entries', tag: 'CACHE_DAO');
      }
      return count;
    } catch (e, stack) {
      Logger.error('❌ Cache clearExpired failed', error: e, stackTrace: stack, tag: 'CACHE_DAO');
      return 0;
    }
  }

  /// Clear all cache entries
  Future<int> clearAll() async {
    try {
      final count = await _db.delete(_db.localCacheItems).go();
      Logger.info('🧹 Cleared all $count cache entries', tag: 'CACHE_DAO');
      return count;
    } catch (e, stack) {
      Logger.error('❌ Cache clearAll failed', error: e, stackTrace: stack, tag: 'CACHE_DAO');
      return 0;
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // STATS & UTILITY
  // ═══════════════════════════════════════════════════════════════

  /// Get total number of cache entries (excluding expired)
  Future<int> count() async {
    try {
      final now = DateTime.now().millisecondsSinceEpoch;
      final query = _db.selectOnly(_db.localCacheItems)
        ..where(
          _db.localCacheItems.expiry.isNull() |
              _db.localCacheItems.expiry.isBiggerOrEqualValue(now),
        )
        ..addColumns([countAll()]);

      final result = await query.getSingle();
      return result.read(countAll()) ?? 0;
    } catch (e) {
      return 0;
    }
  }

  /// Get all cache keys (excluding expired)
  Future<List<String>> getAllKeys() async {
    try {
      final now = DateTime.now().millisecondsSinceEpoch;
      final query = _db.select(_db.localCacheItems)
        ..where((t) => t.expiry.isNull() | t.expiry.isBiggerOrEqualValue(now));

      final items = await query.get();
      return items.map((e) => e.key).toList();
    } catch (e) {
      return [];
    }
  }

  /// Get cache keys matching a prefix
  Future<List<String>> getKeysByPrefix(String prefix) async {
    try {
      final now = DateTime.now().millisecondsSinceEpoch;
      final query = _db.select(_db.localCacheItems)
        ..where(
          (t) => t.key.like('$prefix%') & (t.expiry.isNull() | t.expiry.isBiggerOrEqualValue(now)),
        );

      final items = await query.get();
      return items.map((e) => e.key).toList();
    } catch (e) {
      return [];
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // GET OR FETCH Pattern
  // ═══════════════════════════════════════════════════════════════

  /// Get from cache, or fetch from [fetcher] if not cached
  ///
  /// This is the most powerful pattern for caching:
  /// ```dart
  /// final data = await cacheDao.getOrFetch(
  ///   key: 'categories',
  ///   ttl: Duration(hours: 1),
  ///   fetcher: () => api.getCategories(),
  ///   toJson: (data) => data.toJson(),
  ///   fromJson: (json) => CategoryModel.fromJson(json),
  /// );
  /// ```
  Future<T?> getOrFetch<T>({
    required String key,
    required Future<T> Function() fetcher,
    required Map<String, dynamic> Function(T data) toJson,
    required T Function(Map<String, dynamic> json) fromJson,
    Duration? ttl,
  }) async {
    // 1. Try cache first
    final cached = await getJson(key);
    if (cached != null) {
      try {
        return fromJson(cached);
      } catch (_) {
        await delete(key);
      }
    }

    // 2. Fetch from source
    try {
      final data = await fetcher();
      await putJson(key, toJson(data), ttl: ttl);
      return data;
    } catch (e) {
      Logger.error('❌ Cache getOrFetch failed for key: $key', error: e, tag: 'CACHE_DAO');
      return null;
    }
  }

  /// Get list from cache, or fetch from [fetcher] if not cached
  Future<List<T>?> getOrFetchList<T>({
    required String key,
    required Future<List<T>> Function() fetcher,
    required Map<String, dynamic> Function(T item) toJson,
    required T Function(Map<String, dynamic> json) fromJson,
    Duration? ttl,
  }) async {
    // 1. Try cache first
    final cached = await getJsonList(key);
    if (cached != null) {
      try {
        return cached.map((e) => fromJson(e)).toList();
      } catch (_) {
        await delete(key);
      }
    }

    // 2. Fetch from source
    try {
      final list = await fetcher();
      await putJsonList(key, list.map((e) => toJson(e)).toList(), ttl: ttl);
      return list;
    } catch (e) {
      Logger.error('❌ Cache getOrFetchList failed for key: $key', error: e, tag: 'CACHE_DAO');
      return null;
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // PRIVATE Helpers
  // ═══════════════════════════════════════════════════════════════

  /// Check if an expiry timestamp has passed
  bool _isExpired(int? expiryMs) {
    if (expiryMs == null) return false; // No expiry = permanent
    return DateTime.now().millisecondsSinceEpoch > expiryMs;
  }
}
