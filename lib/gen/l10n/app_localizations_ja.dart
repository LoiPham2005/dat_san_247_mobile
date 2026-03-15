// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'マイアプリ';

  @override
  String get hello => 'こんにちは';

  @override
  String welcome(String name) {
    return 'ようこそ $name';
  }

  @override
  String get name => '名前';

  @override
  String get full_name => 'フルネーム';

  @override
  String get ads => '広告';

  @override
  String get settings => '設定';

  @override
  String get language => '言語';

  @override
  String get appearance => '外観';

  @override
  String get darkMode => 'ダークモード';

  @override
  String get systemDefault => 'システムのデフォルト';

  @override
  String get on => 'の上';

  @override
  String get off => 'オフ';

  @override
  String get primaryColor => '原色';
}
