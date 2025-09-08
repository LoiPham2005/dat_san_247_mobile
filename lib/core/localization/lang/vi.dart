// lib/core/localization/vi.dart

// import 'locale_keys.dart';

import 'package:dat_san_247_mobile/core/localization/locale_keys.dart';

class ViLocale extends LocaleKeys {
  @override String get errorNetwork => 'Lỗi mạng';
  @override String get errorBadRequest => 'Yêu cầu không hợp lệ';
  @override String get errorUnauthorized => 'Không được phép';
  @override String get errorForbidden => 'Bị cấm';
  @override String get errorNotFound => 'Không tìm thấy';
  @override String get errorMethodNotAllowed => 'Phương thức không được phép';
  @override String get errorRequestTimeout => 'Hết thời gian yêu cầu';
  @override String get errorConflict => 'Xung đột';
  @override String get errorInternalServerError => 'Lỗi máy chủ nội bộ';
  @override String get errorServerUnavailable => 'Máy chủ không khả dụng';
  @override String get errorGatewayTimeout => 'Hết thời gian cổng';
  @override String get errorUnknown => 'Lỗi không xác định';

  @override String get hello => 'Xin chào';
  @override String get welcome => 'Chào mừng đến với ứng dụng';
  @override String get login => 'Đăng nhập';
  @override String get account => 'Tài khoản';
  @override String get theme => 'Chủ đề';
  @override String get language => 'Ngôn ngữ';
  @override String get confirmLogout => 'Xác nhận đăng xuất';
  @override String get confirmLogoutMessage => 'Bạn có chắc chắn muốn đăng xuất không?';
  @override String get cancel => 'Hủy';
  @override String get logoutSuccess => 'Đăng xuất thành công';
  @override String get logout => 'Đăng xuất';
  
  @override
  String get dialog => throw UnimplementedError();
  
  @override
  String get nameApp => "Đặt Sân 247";
}
