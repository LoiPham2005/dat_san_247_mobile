// import 'package:flutter/material.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';

// class InterstitialAdHelper {
//   static InterstitialAd? _interstitialAd;

//   static void loadAndShowAd({
//     required BuildContext context,
//     required VoidCallback onAdDismissed,
//     required VoidCallback onAdFailed,
//   }) {
//     InterstitialAd.load(
//       adUnitId: 'ca-app-pub-3940256099942544/1033173712', // TODO: Thay bằng ID thật
//       request: const AdRequest(),
//       adLoadCallback: InterstitialAdLoadCallback(
//         onAdLoaded: (ad) {
//           _interstitialAd = ad;
//           _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
//             onAdDismissedFullScreenContent: (ad) {
//               ad.dispose();
//               _interstitialAd = null;
//               onAdDismissed(); // ✅ gọi callback khi đóng
//             },
//             onAdFailedToShowFullScreenContent: (ad, error) {
//               ad.dispose();
//               _interstitialAd = null;
//               onAdFailed(); // ✅ gọi callback khi lỗi
//             },
//           );
//           _interstitialAd!.show(); // ✅ show
//         },
//         onAdFailedToLoad: (error) {
//           debugPrint('InterstitialAd failed to load: $error');
//           onAdFailed(); // ✅ fallback nếu load lỗi
//         },
//       ),
//     );
//   }
// }
