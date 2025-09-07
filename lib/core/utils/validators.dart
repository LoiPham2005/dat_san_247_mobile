import 'package:get/get.dart';

class Validators {
  /// Kiểm tra email
  static String? validateEmail(String email) {
    if (email.isEmpty) {
      return "Vui lòng nhập email";
    } else if (!GetUtils.isEmail(email)) {
      return "Email không hợp lệ";
    }
    return null;
  }

  /// Kiểm tra mật khẩu
  static String? validatePassword(String password) {
    if (password.isEmpty) {
      return "Vui lòng nhập mật khẩu";
    } else if (GetUtils.isLengthLessThan(password, 6)) {
      return "Mật khẩu phải lớn hơn 6 ký tự";
    }
    return null;
  }

  /// Kiểm tra xác nhận mật khẩu
  static String? validateConfirmPassword(String password, String confirmPassword) {
    if (confirmPassword.isEmpty) {
      return "Vui lòng xác nhận mật khẩu";
    } else if (password != confirmPassword) {
      return "Mật khẩu xác nhận không khớp";
    }
    return null;
  }

  /// Kiểm tra tên người dùng (nếu có yêu cầu)
  static String? validateName(String name) {
    if (name.isEmpty) {
      return "Vui lòng nhập tên";
    } else if (name.length < 3) {
      return "Tên phải có ít nhất 3 ký tự";
    }
    return null;
  }

  /// Kiểm tra số điện thoại (nếu có yêu cầu)
  static String? validatePhone(String phone) {
    if (phone.isEmpty) {
      return "Vui lòng nhập số điện thoại";
    } else if (!GetUtils.isPhoneNumber(phone)) {
      return "Số điện thoại không hợp lệ";
    }
    return null;
  }

  /// Validate Login: Email + Password
  static String? validateLogin(String email, String password) {
    final emailError = validateEmail(email);
    if (emailError != null) return emailError;

    final passwordError = validatePassword(password);
    if (passwordError != null) return passwordError;

    return null;
  }

  /// Validate Register: Email + Password + ConfirmPassword + Phone + Name
  static String? validateRegister({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
    String? phone,
  }) {
    // Check name
    final nameError = validateName(name);
    if (nameError != null) return nameError;

    // Check email
    final emailError = validateEmail(email);
    if (emailError != null) return emailError;

    // Check password
    final passwordError = validatePassword(password);
    if (passwordError != null) return passwordError;

    // Check confirm password
    final confirmError = validateConfirmPassword(password, confirmPassword);
    if (confirmError != null) return confirmError;

    // Check phone nếu có
    if (phone != null && phone.isNotEmpty) {
      final phoneError = validatePhone(phone);
      if (phoneError != null) return phoneError;
    }

    return null; // OK
  }
}
