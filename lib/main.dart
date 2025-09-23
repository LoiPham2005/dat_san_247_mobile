import 'package:dat_san_247_mobile/core/di/bindings/initial_binding.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dat_san_247_mobile/my_app.dart';
import 'package:intl/date_symbol_data_local.dart'; 

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await InitialBinding().dependencies();

  await initializeDateFormatting('vi_VN', null); 

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
