import 'package:flutter/material.dart';
import 'package:dat_san_247_mobile/core/config/environment_config.dart';
import 'package:dat_san_247_mobile/features/my_app.dart';

import 'core/config/app_initializer.dart';

void mainCommon(Environment env) async {
  WidgetsFlutterBinding.ensureInitialized();
  EnvironmentConfig.setEnvironment(env);
  await AppInitializer.initialize();
  runApp(const MyApp());
}
