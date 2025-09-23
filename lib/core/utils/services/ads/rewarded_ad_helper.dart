// // lib/widgets/ads/rewarded_ad_helper.dart
// import 'package:flutter/material.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';

// class RewardedAdHelper {
//   static RewardedInterstitialAd? _rewardedInterstitialAd;

//   static void loadAndShowAd({
//     required BuildContext context,
//     required VoidCallback onRewarded, // gọi khi user nhận thưởng
//     required VoidCallback onAdDismissed,
//     required VoidCallback onAdFailed,
//   }) {
//     RewardedInterstitialAd.load(
//       adUnitId:
//           'ca-app-pub-3940256099942544/5354046379', // Test ID full màn hình
//       request: const AdRequest(),
//       rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
//         onAdLoaded: (RewardedInterstitialAd ad) {
//           _rewardedInterstitialAd = ad;

//           _rewardedInterstitialAd!.fullScreenContentCallback =
//               FullScreenContentCallback(
//                 onAdDismissedFullScreenContent: (ad) {
//                   ad.dispose();
//                   _rewardedInterstitialAd = null;
//                   onAdDismissed();
//                 },
//                 onAdFailedToShowFullScreenContent: (ad, error) {
//                   ad.dispose();
//                   _rewardedInterstitialAd = null;
//                   onAdFailed();
//                 },
//               );

//           _rewardedInterstitialAd!.show(
//             onUserEarnedReward: (ad, reward) {
//               debugPrint("✅ Reward earned: ${reward.amount} ${reward.type}");
//               onRewarded();
//             },
//           );
//         },
//         onAdFailedToLoad: (LoadAdError error) {
//           debugPrint("❌ RewardedInterstitialAd failed to load: $error");
//           onAdFailed();
//         },
//       ),
//     );
//   }
// }
