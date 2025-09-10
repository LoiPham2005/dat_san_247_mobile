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

  // === Lỗi nâng cao ===
  @override String get errorUnsupportedMediaType => 'Định dạng dữ liệu không được hỗ trợ';
  @override String get errorTooManyRequests => 'Bạn đã gửi quá nhiều yêu cầu, vui lòng thử lại sau';
  @override String get errorServiceUnavailable => 'Dịch vụ hiện tại không khả dụng';
  @override String get errorFailedDependency => 'Một dịch vụ phụ thuộc đã thất bại';
  @override String get errorInsufficientStorage => 'Không đủ dung lượng để xử lý yêu cầu';
  @override String get errorNetworkAuthRequired => 'Cần xác thực mạng trước khi tiếp tục';

  // === Lỗi ngoài HTTP ===
  @override String get errorParse => 'Không thể xử lý dữ liệu phản hồi từ máy chủ';
  @override String get errorConnectTimeout => 'Kết nối tới máy chủ quá lâu, vui lòng thử lại';
  @override String get errorReceiveTimeout => 'Máy chủ không phản hồi kịp thời, vui lòng thử lại';
  @override String get errorSendTimeout => 'Gửi dữ liệu lên máy chủ quá lâu, vui lòng thử lại';
  @override String get errorSSLHandshake => 'Lỗi chứng chỉ bảo mật SSL';
  @override String get errorCanceled => 'Yêu cầu đã bị hủy';
  @override String get errorNoInternet => 'Không có kết nối Internet, vui lòng kiểm tra mạng';

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
  @override String get dialog => 'Hộp thoại';
  @override String get nameApp => "Đặt Sân 247";
}
