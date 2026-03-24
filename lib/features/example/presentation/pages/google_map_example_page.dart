// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

// class GoogleMapExamplePage extends StatefulWidget {
//   const GoogleMapExamplePage({super.key});

//   @override
//   State<GoogleMapExamplePage> createState() => _GoogleMapExamplePageState();
// }

// class _GoogleMapExamplePageState extends State<GoogleMapExamplePage> {
//   final Completer<GoogleMapController> _controller =
//       Completer<GoogleMapController>();

//   static const CameraPosition _kGooglePlex = CameraPosition(
//     target: LatLng(10.762622, 106.660172), // TP.HCM
//     zoom: 14.4746,
//   );

//   static const CameraPosition _kLake = CameraPosition(
//       bearing: 192.8334901395799,
//       target: LatLng(10.7769, 106.7009),
//       tilt: 59.440717697143555,
//       zoom: 19.151926040649414);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Google Maps Example'),
//       ),
//       body: GoogleMap(
//         mapType: MapType.normal,
//         initialCameraPosition: _kGooglePlex,
//         onMapCreated: (GoogleMapController controller) {
//           _controller.complete(controller);
//         },
//         markers: {
//           const Marker(
//             markerId: MarkerId('hcm_city'),
//             position: LatLng(10.762622, 106.660172),
//             infoWindow: InfoWindow(title: 'TP. Hồ Chí Minh'),
//           ),
//         },
//       ),
//       floatingActionButton: FloatingActionButton.extended(
//         onPressed: _goToTheLake,
//         label: const Text('To the Bitexco!'),
//         icon: const Icon(Icons.location_city),
//       ),
//     );
//   }

//   Future<void> _goToTheLake() async {
//     final GoogleMapController controller = await _controller.future;
//     await controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
//   }
// }
