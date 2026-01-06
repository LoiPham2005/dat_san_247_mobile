// // ════════════════════════════════════════════════════════════════
// // 📁 lib/core/ads/widgets/ad_native.dart
// // ════════════════════════════════════════════════════════════════
//
// import 'package:dat_san_247_mobile/core/di/injection.dart';
// import 'package:flutter/material.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
//
// import '../services/ad_service.dart';
//
// class AdNative extends StatefulWidget {
//   const AdNative({super.key, required this.placement, this.height = 300, this.templateStyle});
//
//   final String placement;
//   final double height;
//   final NativeTemplateStyle? templateStyle;
//
//   @override
//   State<AdNative> createState() => _AdNativeState();
// }
//
// class _AdNativeState extends State<AdNative> {
//   final _service = getIt<AdService>();
//   NativeAd? _ad;
//   bool _isLoaded = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _load();
//   }
//
//   Future<void> _load() async {
//     final ad = await _service.loadNative(widget.placement, templateStyle: widget.templateStyle);
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
//       height: widget.height,
//       alignment: Alignment.center,
//       child: AdWidget(ad: _ad!),
//     );
//   }
//
//   @override
//   void dispose() {
//     _service.disposeNative(widget.placement);
//     super.dispose();
//   }
// }
