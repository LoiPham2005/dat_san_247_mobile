// lib/core/localization/jp.dart
// import 'locale_keys.dart';


import 'package:dat_san_247_mobile/core/localization/locale_keys.dart';

class JpLocale extends LocaleKeys {
  @override String get errorNetwork => 'ネットワークエラー';
  @override String get errorBadRequest => '不正なリクエスト';
  @override String get errorUnauthorized => '認証されていません';
  @override String get errorForbidden => 'アクセス禁止';
  @override String get errorNotFound => '見つかりません';
  @override String get errorMethodNotAllowed => '許可されていないメソッド';
  @override String get errorRequestTimeout => 'リクエストタイムアウト';
  @override String get errorConflict => '競合';
  @override String get errorInternalServerError => 'サーバー内部エラー';
  @override String get errorServerUnavailable => 'サーバー利用不可';
  @override String get errorGatewayTimeout => 'ゲートウェイタイムアウト';
  @override String get errorUnknown => '不明なエラー';

  @override String get hello => 'こんにちは';
  @override String get welcome => 'アプリへようこそ';
  @override String get login => 'ログイン';
  @override String get account => 'アカウント';
  @override String get theme => 'テーマ';
  @override String get language => '言語';
  @override String get confirmLogout => 'ログアウトを確認';
  @override String get confirmLogoutMessage => '本当にログアウトしますか？';
  @override String get cancel => 'キャンセル';
  @override String get logoutSuccess => 'ログアウト成功';
  @override String get logout => 'ログアウト';
  
  @override
  String get dialog => throw UnimplementedError();
  
  @override
  // TODO: implement nameApp
  String get nameApp => "デッサン247";

}
