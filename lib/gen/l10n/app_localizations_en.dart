// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'My App';

  @override
  String get hello => 'Hello';

  @override
  String welcome(String name) {
    return 'Welcome $name';
  }

  @override
  String get name => 'Name';

  @override
  String get full_name => 'Full name';

  @override
  String get ads => 'Ads';

  @override
  String get settings => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get appearance => 'Appearance';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get systemDefault => 'System Default';

  @override
  String get on => 'On';

  @override
  String get off => 'Off';

  @override
  String get primaryColor => 'Primary Color';
}
