// // ════════════════════════════════════════════════════════════════
// // 📁 lib/core/ads/widgets/ad_interstitial_helper.dart
// // ════════════════════════════════════════════════════════════════
//
// import 'package:dat_san_247_mobile/core/di/injection.dart';
// import 'package:flutter/material.dart';
//
// import '../services/ad_service.dart';
//
// class AdInterstitialHelper {
//   /// Show interstitial with loading
//   static Future<bool> show({required BuildContext context, required String placement}) async {
//     final service = getIt<AdService>();
//
//     // Show loading
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (_) => const Center(child: CircularProgressIndicator()),
//     );
//
//     // Load if needed
//     await service.loadInterstitial(placement);
//
//     if (context.mounted) Navigator.pop(context);
//
//     // Show
//     return await service.showInterstitial(placement);
//   }
//
//   /// Show with navigation
//   static Future<void> showThenNavigate({
//     required BuildContext context,
//     required String placement,
//     required VoidCallback onNavigate,
//   }) async {
//     await show(context: context, placement: placement);
//     onNavigate();
//   }
// }
