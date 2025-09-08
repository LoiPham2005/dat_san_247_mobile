// lib/core/localization/en.dart
// import 'locale_keys.dart';

import 'package:dat_san_247_mobile/core/localization/locale_keys.dart';

class EnLocale extends LocaleKeys {
  @override
  String get errorNetwork => 'Network error';
  @override
  String get errorBadRequest => 'Bad request';
  @override
  String get errorUnauthorized => 'Unauthorized';
  @override
  String get errorForbidden => 'Forbidden';
  @override
  String get errorNotFound => 'Not found';
  @override
  String get errorMethodNotAllowed => 'Method not allowed';
  @override
  String get errorRequestTimeout => 'Request timeout';
  @override
  String get errorConflict => 'Conflict';
  @override
  String get errorInternalServerError => 'Internal server error';
  @override
  String get errorServerUnavailable => 'Server unavailable';
  @override
  String get errorGatewayTimeout => 'Gateway timeout';
  @override
  String get errorUnknown => 'Unknown error';

  @override
  String get hello => 'Hello';
  @override
  String get welcome => 'Welcome to the app';
  @override
  String get login => 'Login';
  @override
  String get account => 'Account';
  @override
  String get theme => 'Theme';
  @override
  String get language => 'Language';
  @override
  String get confirmLogout => 'Confirm Logout';
  @override
  String get confirmLogoutMessage => 'Are you sure you want to logout?';
  @override
  String get cancel => 'Cancel';
  @override
  String get logoutSuccess => 'Logout successful';
  @override
  String get logout => 'Logout';

  @override
  // TODO: implement dialog
  String get dialog => throw UnimplementedError();

  @override
  // TODO: implement dialog
  String get dialog2 => throw UnimplementedError();
  
  @override
  // TODO: implement nameApp
  String get nameApp => "Dat San 247";
}
