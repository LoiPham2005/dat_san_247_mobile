// lib/core/localization/en.dart
// import 'locale_keys.dart';

import 'package:dat_san_247_mobile/core/localization/locale_keys.dart';

class EnLocale extends LocaleKeys {
  @override String get errorNetwork => 'Network error';
  @override String get errorBadRequest => 'Bad request';
  @override String get errorUnauthorized => 'Unauthorized';
  @override String get errorForbidden => 'Forbidden';
  @override String get errorNotFound => 'Not found';
  @override String get errorMethodNotAllowed => 'Method not allowed';
  @override String get errorRequestTimeout => 'Request timeout';
  @override String get errorConflict => 'Conflict';
  @override String get errorInternalServerError => 'Internal server error';
  @override String get errorServerUnavailable => 'Server unavailable';
  @override String get errorGatewayTimeout => 'Gateway timeout';
  @override String get errorUnknown => 'Unknown error';

  // === Advanced errors ===
  @override String get errorUnsupportedMediaType => 'Unsupported media type';
  @override String get errorTooManyRequests => 'Too many requests, please try again later';
  @override String get errorServiceUnavailable => 'Service currently unavailable';
  @override String get errorFailedDependency => 'A dependent service has failed';
  @override String get errorInsufficientStorage => 'Insufficient storage to process the request';
  @override String get errorNetworkAuthRequired => 'Network authentication required before proceeding';

  // === Non-HTTP errors ===
  @override String get errorParse => 'Failed to process response from server';
  @override String get errorConnectTimeout => 'Connection to server timed out, please try again';
  @override String get errorReceiveTimeout => 'Server did not respond in time, please try again';
  @override String get errorSendTimeout => 'Sending data to server took too long, please try again';
  @override String get errorSSLHandshake => 'SSL certificate error';
  @override String get errorCanceled => 'Request has been canceled';
  @override String get errorNoInternet => 'No internet connection, please check your network';

  @override String get hello => 'Hello';
  @override String get welcome => 'Welcome to the app';
  @override String get login => 'Login';
  @override String get account => 'Account';
  @override String get theme => 'Theme';
  @override String get language => 'Language';
  @override String get confirmLogout => 'Confirm Logout';
  @override String get confirmLogoutMessage => 'Are you sure you want to logout?';
  @override String get cancel => 'Cancel';
  @override String get logoutSuccess => 'Logout successful';
  @override String get logout => 'Logout';
  @override String get dialog => 'Dialog';
  @override String get nameApp => "Dat San 247";
}

