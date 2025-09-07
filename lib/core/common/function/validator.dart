import 'package:get/get.dart';

class ValidatorApp {
  /// Kiểm tra trống hoặc null
  static String? checkNull({
    String? text,
    String? fieldName,
    bool isTextField = true,
  }) {
    if (text == null || text.trim().isEmpty || text == "null") {
      return isTextField ? "$fieldName không được bỏ trống" : "Đang cập nhật";
    }
    return null;
  }

  /// Kiểm tra độ dài tối thiểu
  static String? checkMinLength({
    String? text,
    int minLength = 3,
    String? fieldName,
  }) {
    if (text == null || text.trim().isEmpty) {
      return "$fieldName không được để trống";
    }
    if (text.trim().length < minLength) {
      return "$fieldName phải có ít nhất $minLength ký tự";
    }
    return null;
  }

  /// Kiểm tra email
  static String? checkEmail({
    String? text,
    bool isCheck = true,
  }) {
    final RegExp emailRegex = RegExp(
        r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");

    if (text == null || text.trim().isEmpty) {
      return isCheck ? "Email không được bỏ trống" : null;
    } else if (!emailRegex.hasMatch(text)) {
      return "Email không đúng định dạng";
    }
    return null;
  }

  /// Kiểm tra mật khẩu
  static String? checkPassword({
    String? password,
    String? confirmPassword,
    bool isConfirm = false,
  }) {
    if (password == null || password.trim().isEmpty) {
      return "Vui lòng nhập mật khẩu";
    }
    if (password.length < 6) {
      return "Mật khẩu phải lớn hơn 6 ký tự";
    }
    if (isConfirm && password != confirmPassword) {
      return "Mật khẩu xác nhận không khớp";
    }
    return null;
  }

  /// Kiểm tra số điện thoại
  static String? checkPhone({
    String? text,
    bool isCheck = true,
  }) {
    final RegExp phoneRegex = RegExp(r'(84|0[3|5|7|8|9])+([0-9]{8})\b');

    if (text == null || text.trim().isEmpty) {
      return isCheck ? "Số điện thoại không được bỏ trống" : null;
    }
    if (!phoneRegex.hasMatch(text)) {
      return "Số điện thoại không đúng định dạng";
    }
    return null;
  }

  /// Kiểm tra số tiền nạp/rút
  static String? checkMoney({
    String? text,
    bool isNap = false,
  }) {
    if (text == null || text.trim().isEmpty) {
      return "Vui lòng nhập số tiền";
    }

    int money = int.tryParse(text.replaceAll('.', '')) ?? 0;

    if (isNap && money < 50000) {
      return "Số tiền nạp phải lớn hơn 50.000đ";
    } else if (!isNap && money < 200000) {
      return "Số tiền rút phải lớn hơn 200.000đ";
    }
    return null;
  }

  /// Validate Login
  static String? validateLogin(String email, String password) {
    final emailError = checkEmail(text: email);
    if (emailError != null) return emailError;

    final passwordError = checkPassword(password: password);
    if (passwordError != null) return passwordError;

    return null; // OK
  }

  /// Validate Register
  static String? validateRegister({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
    String? phone,
  }) {
    // Kiểm tra tên
    final nameError = checkMinLength(
      text: name,
      fieldName: "Tên",
      minLength: 3,
    );
    if (nameError != null) return nameError;

    // Kiểm tra email
    final emailError = checkEmail(text: email);
    if (emailError != null) return emailError;

    // Kiểm tra mật khẩu
    final passwordError = checkPassword(password: password);
    if (passwordError != null) return passwordError;

    // Kiểm tra xác nhận mật khẩu
    final confirmError = checkPassword(
      password: password,
      confirmPassword: confirmPassword,
      isConfirm: true,
    );
    if (confirmError != null) return confirmError;

    // Kiểm tra số điện thoại nếu có
    if (phone != null && phone.isNotEmpty) {
      final phoneError = checkPhone(text: phone);
      if (phoneError != null) return phoneError;
    }

    return null; // OK
  }
}
