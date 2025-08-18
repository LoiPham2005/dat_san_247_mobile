

import 'package:dat_san_247_mobile/core/api/api_path.dart';

extension StringX on String? {

  bool get isEmptyOrNull =>
      this == null ||
          (this != null && this!.isEmpty) ||
          (this != null && this! == 'null');

  // Check null string, return given value if null
  String validate({String value = ''}) {
    if (isEmptyOrNull) {
      return value;
    } else {
      return this!;
    }
  }

  bool isDigit() {
    if (validate().isEmpty) {
      return false;
    }
    if (validate().length > 1) {
      for (var r in this!.runes) {
        if (r ^ 0x30 > 9) {
          return false;
        }
      }
      return true;
    } else {
      return this!.runes.first ^ 0x30 <= 9;
    }
  }

  int toInt({int defaultValue = 0}) {
    if (this == null) return defaultValue;
    if (isDigit()) {
      return int.parse(this!);
    } else {
      return defaultValue;
    }
  }

  String toImage() {
    if (this == null) return '';
    return ApiPath.domainImage + this!;
  }

  /// Return double value of given string
  double toDouble({double defaultValue = 0.0}) {
    if (this == null) return defaultValue;

    try {
      return double.parse(this!);
    } catch (e) {
      return defaultValue;
    }
  }

}