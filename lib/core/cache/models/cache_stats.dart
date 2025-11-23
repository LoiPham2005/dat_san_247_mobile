// lib/core/cache/models/cache_stats.dart
class CacheStats {
  final int imageCount;
  final int videoCount;
  final int docCount;
  final int totalCount;
  final int hits;
  final int misses;
  final double hitRate;
  final DateTime? lastCleared;

  const CacheStats({
    required this.imageCount,
    required this.videoCount,
    required this.docCount,
    required this.totalCount,
    required this.hits,
    required this.misses,
    required this.hitRate,
    this.lastCleared,
  });

  factory CacheStats.empty() => const CacheStats(
    imageCount: 0,
    videoCount: 0,
    docCount: 0,
    totalCount: 0,
    hits: 0,
    misses: 0,
    hitRate: 0,
  );

  @override
  String toString() =>
      'CacheStats(total: $totalCount, hits: $hits, misses: $misses, '
      'hitRate: ${(hitRate * 100).toStringAsFixed(1)}%)';
}
