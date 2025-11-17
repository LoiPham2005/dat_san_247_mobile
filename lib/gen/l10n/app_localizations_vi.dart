// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appTitle => 'My App';

  @override
  String get ddd => 'gggg';

  @override
  String get hello => 'Hello';

  @override
  String get ccccc => 'cccc';

  @override
  String welcome(String name) {
    return 'Welcome $name';
  }

  @override
  String get her => 'her';

  @override
  String get map => 'map';
}
