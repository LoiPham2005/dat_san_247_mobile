// // lib/widgets/ads/banner_ad_widget.dart

// import 'package:flutter/material.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';

// class BannerAdWidget extends StatefulWidget {
//   const BannerAdWidget({super.key});

//   @override
//   State<BannerAdWidget> createState() => _BannerAdWidgetState();
// }

// class _BannerAdWidgetState extends State<BannerAdWidget> {
//   BannerAd? _bannerAd;
//   bool _isAdLoaded = false;

//   @override
//   void initState() {
//     super.initState();
//     _loadAd();
//   }

//   void _loadAd() {
//     _bannerAd = BannerAd(
//       adUnitId: 'ca-app-pub-3940256099942544/6300978111', // Test ID
//       size: AdSize.banner,
//       request: const AdRequest(),
//       listener: BannerAdListener(
//         onAdLoaded: (ad) {
//           setState(() => _isAdLoaded = true);
//         },
//         onAdFailedToLoad: (ad, error) {
//           ad.dispose();
//           debugPrint('BannerAd failed to load: $error');
//         },
//       ),
//     )..load();
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (!_isAdLoaded || _bannerAd == null) return const SizedBox.shrink();

//     return Container(
//       width: _bannerAd!.size.width.toDouble(),
//       height: _bannerAd!.size.height.toDouble(),
//       margin: const EdgeInsets.symmetric(vertical: 10),
//       child: AdWidget(ad: _bannerAd!),
//     );
//   }

//   @override
//   void dispose() {
//     _bannerAd?.dispose();
//     super.dispose();
//   }
// }
