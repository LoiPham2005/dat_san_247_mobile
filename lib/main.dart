import 'package:dat_san_247_mobile/core/di/bindings/initial_binding.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dat_san_247_mobile/my_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Wait for dependencies initialization
  await InitialBinding().dependencies();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(
    // DevicePreview(
    //   builder: (context) =>
       const MyApp(),
    // ),
  );
}
