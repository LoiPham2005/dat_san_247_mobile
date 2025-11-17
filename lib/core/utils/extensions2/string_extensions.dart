// lib/extensions/string_extensions.dart

extension StringExtensions on String {
  // Kiểm tra null hoặc empty
  bool get isNullOrEmpty => isEmpty;
  
  bool get isNotNullOrEmpty => isNotEmpty;

  // Capitalize first letter
  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }

  // Capitalize mỗi từ
  String get capitalizeWords {
    if (isEmpty) return this;
    return split(' ')
        .map((word) => word.isEmpty ? word : word.capitalize)
        .join(' ');
  }

  // Kiểm tra email hợp lệ
  bool get isValidEmail {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(this);
  }

  // Kiểm tra số điện thoại (VN)
  bool get isValidPhoneVN {
    return RegExp(r'^(0|\+84)[3|5|7|8|9][0-9]{8}$').hasMatch(this);
  }

  // Remove dấu tiếng Việt
  String get removeDiacritics {
    var str = this;
    str = str.replaceAll(RegExp(r'[àáạảãâầấậẩẫăằắặẳẵ]'), 'a');
    str = str.replaceAll(RegExp(r'[èéẹẻẽêềếệểễ]'), 'e');
    str = str.replaceAll(RegExp(r'[ìíịỉĩ]'), 'i');
    str = str.replaceAll(RegExp(r'[òóọỏõôồốộổỗơờớợởỡ]'), 'o');
    str = str.replaceAll(RegExp(r'[ùúụủũưừứựửữ]'), 'u');
    str = str.replaceAll(RegExp(r'[ỳýỵỷỹ]'), 'y');
    str = str.replaceAll(RegExp(r'[đ]'), 'd');
    str = str.replaceAll(RegExp(r'[ÀÁẠẢÃÂẦẤẬẨẪĂẰẮẶẲẴ]'), 'A');
    str = str.replaceAll(RegExp(r'[ÈÉẸẺẼÊỀẾỆỂỄ]'), 'E');
    str = str.replaceAll(RegExp(r'[ÌÍỊỈĨ]'), 'I');
    str = str.replaceAll(RegExp(r'[ÒÓỌỎÕÔỒỐỘỔỖƠỜỚỢỞỠ]'), 'O');
    str = str.replaceAll(RegExp(r'[ÙÚỤỦŨƯỪỨỰỬỮ]'), 'U');
    str = str.replaceAll(RegExp(r'[ỲÝỴỶỸ]'), 'Y');
    str = str.replaceAll(RegExp(r'[Đ]'), 'D');
    return str;
  }

  // Truncate với ellipsis
  String truncate(int maxLength, {String ellipsis = '...'}) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength)}$ellipsis';
  }

  // Parse to int với default value
  int toIntOrDefault([int defaultValue = 0]) {
    return int.tryParse(this) ?? defaultValue;
  }

  // Parse to double với default value
  double toDoubleOrDefault([double defaultValue = 0.0]) {
    return double.tryParse(this) ?? defaultValue;
  }
}