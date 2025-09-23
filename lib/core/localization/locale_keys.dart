abstract class LocaleKeys {
  // === Network error messages ===
  String get errorNetwork;
  String get errorBadRequest;
  String get errorUnauthorized;
  String get errorForbidden;
  String get errorNotFound;
  String get errorMethodNotAllowed;
  String get errorRequestTimeout;
  String get errorConflict;
  String get errorInternalServerError;
  String get errorServerUnavailable;
  String get errorGatewayTimeout;
  String get errorUnknown;

  // === Lỗi nâng cao (HTTP) ===
  String get errorUnsupportedMediaType;   // 415
  String get errorTooManyRequests;        // 429
  String get errorFailedDependency;       // 424
  String get errorInsufficientStorage;    // 507
  String get errorNetworkAuthRequired;    // 511
  String get errorServiceUnavailable;     // 503

  // === Lỗi HTTP bổ sung hay gặp ===
  String get errorPaymentRequired;        // 402
  String get errorNotAcceptable;          // 406
  String get errorGone;                   // 410
  String get errorPreconditionFailed;     // 412
  String get errorPayloadTooLarge;        // 413
  String get errorUnprocessableEntity;    // 422
  String get errorLocked;                 // 423
  String get errorNotImplemented;         // 501
  String get errorBadGateway;             // 502

  // === Lỗi ngoài HTTP ===
  String get errorParse;
  String get errorConnectTimeout;
  String get errorReceiveTimeout;
  String get errorSendTimeout;
  String get errorSSLHandshake;
  String get errorCanceled;
  String get errorNoInternet;

  // === Common ===
  String get nameApp;
  String get hello;
  String get welcome;
  String get login;
  String get account;
  String get theme;
  String get language;
  String get confirmLogout;
  String get confirmLogoutMessage;
  String get cancel;
  String get logoutSuccess;
  String get logout;
  String get dialog;
  String get logoutFailed;
  String get notiSnackbar;

}
