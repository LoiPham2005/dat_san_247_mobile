// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appTitle => 'Ứng dụng của tôi';

  @override
  String get hello => 'Xin chào';

  @override
  String welcome(String name) {
    return 'Chào mừng $name';
  }

  @override
  String get name => 'Tên';

  @override
  String get full_name => 'Họ và tên';

  @override
  String get ads => 'Quảng cáo';

  @override
  String get settings => 'Cài đặt';

  @override
  String get language => 'Ngôn ngữ';

  @override
  String get appearance => 'Giao diện';

  @override
  String get darkMode => 'Chế độ tối';

  @override
  String get systemDefault => 'Theo hệ thống';

  @override
  String get on => 'Đang bật';

  @override
  String get off => 'Đang tắt';

  @override
  String get primaryColor => 'Màu chủ đạo';
}
