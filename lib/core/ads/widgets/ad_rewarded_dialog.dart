// // ════════════════════════════════════════════════════════════════
// // 📁 lib/core/ads/widgets/ad_rewarded_dialog.dart
// // ════════════════════════════════════════════════════════════════
//
// import 'package:dat_san_247_mobile/core/di/injection.dart';
// import 'package:flutter/material.dart';
//
// import '../services/ad_manager.dart';
//
// class AdRewardedDialog {
//   static Future<bool> show({
//     required BuildContext context,
//     required String placement,
//     required String title,
//     required String description,
//     required VoidCallback onRewarded,
//   }) async {
//     final confirmed = await showDialog<bool>(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text(title),
//         content: Text(description),
//         actions: [
//           TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
//           ElevatedButton(
//             onPressed: () => Navigator.pop(context, true),
//             child: const Text('Watch Ad'),
//           ),
//         ],
//       ),
//     );
//
//     if (confirmed != true) return false;
//
//     // Show loading
//     if (context.mounted) {
//       showDialog(
//         context: context,
//         barrierDismissible: false,
//         builder: (_) => const Center(child: CircularProgressIndicator()),
//       );
//     }
//
//     final manager = getIt<AdManager>();
//     final earned = await manager.showRewardedAd(placement: placement, onRewarded: onRewarded);
//
//     if (context.mounted) Navigator.pop(context);
//
//     if (!earned && context.mounted) {
//       _showError(context);
//     }
//
//     return earned;
//   }
//
//   static void _showError(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Ad Not Available'),
//         content: const Text('Please try again later.'),
//         actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK'))],
//       ),
//     );
//   }
// }
