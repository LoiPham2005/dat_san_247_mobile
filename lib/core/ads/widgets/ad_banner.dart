// // ════════════════════════════════════════════════════════════════
// // 📁 lib/core/ads/widgets/ad_banner.dart
// // ════════════════════════════════════════════════════════════════
//
// import 'package:dat_san_247_mobile/core/di/injection.dart';
// import 'package:flutter/material.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
//
// import '../services/ad_service.dart';
//
// class AdBanner extends StatefulWidget {
//   const AdBanner({super.key, required this.placement, this.size});
//
//   final String placement;
//   final AdSize? size;
//
//   @override
//   State<AdBanner> createState() => _AdBannerState();
// }
//
// class _AdBannerState extends State<AdBanner> {
//   final _service = getIt<AdService>();
//   BannerAd? _ad;
//   bool _isLoaded = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _load();
//   }
//
//   Future<void> _load() async {
//     final ad = await _service.loadBanner(widget.placement, size: widget.size);
//
//     if (mounted && ad != null) {
//       setState(() {
//         _ad = ad;
//         _isLoaded = true;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (!_isLoaded || _ad == null) {
//       return const SizedBox.shrink();
//     }
//
//     return Container(
//       alignment: Alignment.center,
//       width: _ad!.size.width.toDouble(),
//       height: _ad!.size.height.toDouble(),
//       child: AdWidget(ad: _ad!),
//     );
//   }
//
//   @override
//   void dispose() {
//     _service.disposeBanner(widget.placement);
//     super.dispose();
//   }
// }
