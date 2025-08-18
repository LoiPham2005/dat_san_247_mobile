import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final di = GetIt.instance;

Future<void> initializeDependencies() async {
  await _dependencyExternal();
  // injectorRepo();
}

_dependencyExternal() async {
  final preferences = await SharedPreferences.getInstance();
  di.registerSingleton<SharedPreferences>(
    preferences,
  );
}
