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

  // === 高度なエラー ===
  @override String get errorUnsupportedMediaType => 'サポートされていないデータ形式';
  @override String get errorTooManyRequests => 'リクエストが多すぎます。後でもう一度お試しください';
  @override String get errorServiceUnavailable => '現在サービスは利用できません';
  @override String get errorFailedDependency => '依存しているサービスが失敗しました';
  @override String get errorInsufficientStorage => 'リクエストを処理するためのストレージが不足しています';
  @override String get errorNetworkAuthRequired => '続行する前にネットワーク認証が必要です';

  // === HTTP以外のエラー ===
  @override String get errorParse => 'サーバーからの応答を処理できません';
  @override String get errorConnectTimeout => 'サーバーへの接続がタイムアウトしました。もう一度お試しください';
  @override String get errorReceiveTimeout => 'サーバーからの応答がありません。もう一度お試しください';
  @override String get errorSendTimeout => 'サーバーへのデータ送信が長すぎます。もう一度お試しください';
  @override String get errorSSLHandshake => 'SSL証明書エラー';
  @override String get errorCanceled => 'リクエストがキャンセルされました';
  @override String get errorNoInternet => 'インターネット接続がありません。ネットワークを確認してください';

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
  @override String get dialog => 'ダイアログ';
  @override String get nameApp => "デッサン247";
}
