class ValidatorApp {
  static checkNull({
    String? text,
    bool isTextFiled = false,
    bool isCheck = true,
  }) {
    if (text == "null" || text == null || text == "") {
      if (!isCheck) {
        return null;
      }
      return isTextFiled ? "Không bỏ trống" : "Đang cập nhật";
    } else {
      return null;
    }
  }

  static String? checkMinLength({
    String? text,
    int minLength = 3,
    String? fieldName,
  }) {
    if (text == null || text.trim().isEmpty)
      return "$fieldName không được để trống";
    if (text.trim().length < minLength)
      return "$fieldName phải có ít nhất $minLength ký tự";
    return null;
  }

  static checkMoney({
    String? text,
    bool isTextFiled = false,
    bool isnap = false,
  }) {
    if (text == "null" || text == null || text == "") {
      return isTextFiled ? "Không bỏ trống" : "Đang cập nhật";
    }

    int money = int.tryParse(text.replaceAll('.', '')) ?? 0;

    if (isnap ? money < 50000 : money < 200000) {
      return isnap
          ? "Số tiền nạp phải lớn hơn 50.000đ"
          : "Số tiền rút phải lớn hơn 200.000đ";
    } else {
      return null;
    }
  }

  static checkPass({
    String? text,
    String? text2,
    bool isSign = false,
    bool isText2 = false,
    bool isCheck = true,
  }) {
    // RegExp regex = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{6,}$');
    if (text == "null" || text == "" || text == null) {
      if (!isCheck) {
        return null;
      }
      return "Không bỏ trống";
    } else if (text.length < 6) {
      // return "Mật khẩu phải chứa chữ cái viết hoa, thường số và lớn hơn 6 ký tự";
      return "Mật khẩu phải lớn hơn 6 ký tự";
    } else if (text != text2 && isSign) {
      return "Mật khẩu nhắc lại không khớp";
    } else {
      return null;
    }
  }

  static checkPhone({
    String? text,
    String? msg,
    bool isCheck = true,
  }) {
    try {
      if (text == "null" || text == null || text == "") {
        if (!isCheck) {
          return null;
        }
        return msg ?? "Không bỏ trống";
      }
      int.parse(text);
      if (PhoneChecker.isNotValid(text)) {
        return "Số điện thoại không đúng định dạng";
      } else {
        return null;
      }
    } catch (e) {
      return "Số điện thoại không đúng định dạng";
    }
  }

  static checkEmail({
    String? text,
    bool isCheck = true,
  }) {
    var isEmail = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    if (text == "null" || text == null || text == "") {
      if (!isCheck) {
        return null;
      }
      return "Không bỏ trống";
    } else if (!isEmail.hasMatch(text)) {
      return "Email không đúng định dạng";
    } else {
      return null;
    }
  }
}

class PhoneChecker {
  static bool isNotValid(String phone) {
    // return false;
    print(RegExp(r'(84|0[3|5|7|8|9])+([0-9]{8})\b').hasMatch(phone));
    return !RegExp(r'(84|0[3|5|7|8|9])+([0-9]{8})\b').hasMatch(phone);
  }
}
