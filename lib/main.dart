import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dat_san_247_mobile/my_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MyApp());
}
