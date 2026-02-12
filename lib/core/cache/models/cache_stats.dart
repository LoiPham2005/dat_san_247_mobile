// ════════════════════════════════════════════════════════════════
// 📁 lib/core/cache/models/cache_stats.dart
// ════════════════════════════════════════════════════════════════

/// 📊 Unified cache statistics model
class CacheStats {
  // ─── File cache stats ───
  final int imageCount;
  final int videoCount;
  final int docCount;
  final int totalFileCount;

  // ─── Local DB cache stats ───
  final int localCacheCount;

  // ─── Hit/Miss tracking ───
  final int hits;
  final int misses;
  final double hitRate;

  // ─── Size tracking (bytes) ───
  final int apiCacheSizeBytes;
  final int fileCacheSizeBytes;
  final int totalSizeBytes;

  // ─── Metadata ───
  final DateTime? lastCleared;

  const CacheStats({
    required this.imageCount,
    required this.videoCount,
    required this.docCount,
    required this.totalFileCount,
    this.localCacheCount = 0,
    required this.hits,
    required this.misses,
    required this.hitRate,
    this.apiCacheSizeBytes = 0,
    this.fileCacheSizeBytes = 0,
    this.totalSizeBytes = 0,
    this.lastCleared,
  });

  factory CacheStats.empty() => const CacheStats(
    imageCount: 0,
    videoCount: 0,
    docCount: 0,
    totalFileCount: 0,
    localCacheCount: 0,
    hits: 0,
    misses: 0,
    hitRate: 0,
    apiCacheSizeBytes: 0,
    fileCacheSizeBytes: 0,
    totalSizeBytes: 0,
  );

  /// Get human-readable size string
  String get formattedApiCacheSize => _formatBytes(apiCacheSizeBytes);
  String get formattedFileCacheSize => _formatBytes(fileCacheSizeBytes);
  String get formattedTotalSize => _formatBytes(totalSizeBytes);

  /// Format bytes to human-readable string
  static String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  @override
  String toString() =>
      'CacheStats(files: $totalFileCount, localCache: $localCacheCount, '
      'hits: $hits, misses: $misses, '
      'hitRate: ${(hitRate * 100).toStringAsFixed(1)}%, '
      'totalSize: $formattedTotalSize)';
}
