// // ════════════════════════════════════════════════════════════════
// // 📁 lib/core/ads/widgets/ad_native_list_tile.dart
// // ════════════════════════════════════════════════════════════════
//
// import 'package:dat_san_247_mobile/core/di/injection.dart';
// import 'package:flutter/material.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
//
// import '../services/ad_service.dart';
//
// /// Native ad for ListView insertion
// class AdNativeListTile extends StatefulWidget {
//   const AdNativeListTile({super.key, required this.placement, this.height = 320});
//
//   final String placement;
//   final double height;
//
//   @override
//   State<AdNativeListTile> createState() => _AdNativeListTileState();
// }
//
// class _AdNativeListTileState extends State<AdNativeListTile> {
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
//     final ad = await _service.loadNative(
//       widget.placement,
//       templateStyle: NativeTemplateStyle(
//         templateType: TemplateType.medium,
//         mainBackgroundColor: Colors.grey[100]!,
//         cornerRadius: 8.0,
//       ),
//     );
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
//       margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//       decoration: BoxDecoration(
//         color: Colors.grey[50],
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(color: Colors.grey[300]!),
//       ),
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
