// // ════════════════════════════════════════════════════════════════
// // 📱 5. Smart Banner Widget
// // ════════════════════════════════════════════════════════════════
// // lib/core/ads/widgets/smart_banner_ad_widget.dart

// import 'package:flutter/material.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
// import 'package:flutter_base_template/core/di/injection.dart';
// import '../services/ad_service.dart';
// import '../services/ad_manager.dart';

// class SmartBannerAdWidget extends StatefulWidget {
//   const SmartBannerAdWidget({super.key, required this.screenName});
//   final String screenName;

//   @override
//   State<SmartBannerAdWidget> createState() => _SmartBannerAdWidgetState();
// }

// class _SmartBannerAdWidgetState extends State<SmartBannerAdWidget> {
//   final _adService = getIt<AdService>();
//   final _adManager = getIt<AdManager>();
//   BannerAd? _bannerAd;
//   bool _isLoaded = false;

//   @override
//   void initState() {
//     super.initState();
//     _loadAd();
//   }

//   void _loadAd() {
//     // ✅ Check placement
//     if (!_adManager.shouldShowBanner(widget.screenName)) return;

//     _adService.loadBannerAd(
//       onAdLoaded: (ad) => setState(() {
//         _bannerAd = ad;
//         _isLoaded = true;
//       }),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (!_isLoaded || _bannerAd == null) return const SizedBox.shrink();
//     return SizedBox(
//       width: _bannerAd!.size.width.toDouble(),
//       height: _bannerAd!.size.height.toDouble(),
//       child: AdWidget(ad: _bannerAd!),
//     );
//   }

//   @override
//   void dispose() {
//     _adService.dispose();
//     super.dispose();
//   }
// }
