// // ════════════════════════════════════════════════════════════════
// // 📁 lib/core/ads/ad_frequency.dart
// // ════════════════════════════════════════════════════════════════
//
// /// Manages ad frequency to prevent spam
// class AdFrequency {
//   final Map<String, DateTime> _lastShown = {};
//   final Map<String, int> _showCount = {};
//
//   bool canShow(
//     String placement, {
//     Duration? minInterval,
//     int? maxPerSession,
//   }) {
//     // Check minimum interval
//     if (minInterval != null) {
//       final lastShown = _lastShown[placement];
//       if (lastShown != null) {
//         final elapsed = DateTime.now().difference(lastShown);
//         if (elapsed < minInterval) return false;
//       }
//     }
//
//     // Check max per session
//     if (maxPerSession != null) {
//       final count = _showCount[placement] ?? 0;
//       if (count >= maxPerSession) return false;
//     }
//
//     return true;
//   }
//
//   void markShown(String placement) {
//     _lastShown[placement] = DateTime.now();
//     _showCount[placement] = (_showCount[placement] ?? 0) + 1;
//   }
//
//   void reset() {
//     _lastShown.clear();
//     _showCount.clear();
//   }
//
//   void resetPlacement(String placement) {
//     _lastShown.remove(placement);
//     _showCount.remove(placement);
//   }
// }
