// // ════════════════════════════════════════════════════════════════
// // 📁 lib/core/ads/widgets/ad_sticky_banner.dart
// // ════════════════════════════════════════════════════════════════
//
// import 'package:dat_san_247_mobile/core/di/injection.dart';
// import 'package:flutter/material.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
//
// import '../services/ad_service.dart';
//
// class AdStickyBanner extends StatefulWidget {
//   const AdStickyBanner({super.key, required this.placement, this.showCloseButton = false});
//
//   final String placement;
//   final bool showCloseButton;
//
//   @override
//   State<AdStickyBanner> createState() => _AdStickyBannerState();
// }
//
// class _AdStickyBannerState extends State<AdStickyBanner> {
//   final _service = getIt<AdService>();
//   BannerAd? _ad;
//   bool _isLoaded = false;
//   bool _isClosed = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _load();
//   }
//
//   Future<void> _load() async {
//     final ad = await _service.loadBanner(widget.placement);
//
//     if (mounted && ad != null) {
//       setState(() {
//         _ad = ad;
//         _isLoaded = true;
//       });
//     }
//   }
//
//   void _close() {
//     setState(() => _isClosed = true);
//     _service.disposeBanner(widget.placement);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (_isClosed || !_isLoaded || _ad == null) {
//       return const SizedBox.shrink();
//     }
//
//     return SafeArea(
//       child: Stack(
//         children: [
//           Container(
//             alignment: Alignment.center,
//             width: double.infinity,
//             height: _ad!.size.height.toDouble(),
//             color: Colors.white,
//             child: AdWidget(ad: _ad!),
//           ),
//           if (widget.showCloseButton)
//             Positioned(
//               right: 0,
//               top: 0,
//               child: IconButton(
//                 icon: const Icon(Icons.close, size: 18),
//                 onPressed: _close,
//                 padding: EdgeInsets.zero,
//                 constraints: const BoxConstraints(),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     _service.disposeBanner(widget.placement);
//     super.dispose();
//   }
// }
