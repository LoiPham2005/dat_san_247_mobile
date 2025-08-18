import 'package:flutter/material.dart';
import 'package:dat_san_247_mobile/core/common/db_keys_local.dart';
import 'package:dat_san_247_mobile/core/common/function/share_pref.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

class Const {
  static final format = NumberFormat("#,##0.##", "vi");

  static const image_host = 'https://admin.golf18.vn/storage';

  static const api_host = 'https://admin.golf18.vn/api';

  static List<String> image_types = [
    'jpg',
    'jpeg',
    'jfif',
    'pjpeg',
    'pjp',
    'png',
    'svg',
    'gif',
    'apng',
    'webp',
    'avif'
  ];

  static checkLogin(BuildContext context, {required Function nextPage}) async {
    bool isLogin = await SharedPrefs.getBool(DbKeysLocal.isLogin);
    if (isLogin) {
      nextPage();
    } else {}
  }
  static formatTimeString(time, {String? format}) {
    if (time == null) {
      return "";
    }
    DateTime dateTime = DateTime.parse(time);
    return DateFormat(format ?? 'dd/MM/yyyy  HH:mm:ss', 'vi_VN').format(
      DateTime(dateTime.year, dateTime.month, dateTime.day, dateTime.hour + 7,
          dateTime.minute, dateTime.second),
    );
  }
  static formatTimeStringWithoutHour(time, {String? format}) {
    if (time == null) {
      return "";
    }
    DateTime dateTime = DateTime.parse(time);
    return DateFormat(format ?? 'dd/MM/yyyy', 'en_US').format(
      DateTime(dateTime.year, dateTime.month, dateTime.day, dateTime.hour  + 7,
          dateTime.minute, dateTime.second),
    );
  }

  static convertTime(DateTime time, {String? format}) {
    return DateFormat(format ?? 'dd/MM/yyyy - HH:mm:ss', 'en_US').format(time.add(Duration(hours: 7)));
  }

  static bool isTimestampExpired(int timestamp) {
    DateTime currentTime = DateTime.now();
    DateTime expirationTime = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);

    return currentTime.isAfter(expirationTime);
  }

  static formatTime(time, {String? format, bool isSecond = true, }) {
    if (time == null) {
      return "";
    }
    if (isSecond) {
      return DateFormat(format ?? 'dd/MM/yyyy HH:mm:ss', 'en_US')
          .format(DateTime.fromMillisecondsSinceEpoch(time * 1000));
    }
    return DateFormat(format ?? 'dd/MM/yyyy HH:mm:ss', 'en_US')
        .format(DateTime.fromMillisecondsSinceEpoch(time));
  }
  static formatTimeWithoutHour(time, {String? format, bool isSecond = true, }) {
    if (time == null) {
      return "";
    }
    if (isSecond) {
      return DateFormat(format ?? 'dd/MM/yyyy', 'en_US')
          .format(DateTime.fromMillisecondsSinceEpoch(time * 1000));
    }
    return DateFormat(format ?? 'dd/MM/yyyy', 'en_US')
        .format(DateTime.fromMillisecondsSinceEpoch(time));
  }

  static convertPrice(
    dynamic price,
  ) {
    var res = isNumeric(price.toString());
    if (res) {
      return format.format(double.parse(price.toString())).toString();
    }
    return "0";
  }

  static convertPhone(String? phone,
      {bool check = false, bool isHint = false}) {
    if (phone == "null" || phone == "" || phone == null) {
      if (check) {
        return "";
      }
      return "Chưa cập nhật";
    }

    if (isHint) {
      return "${phone.substring(0, 4)}***${phone.substring(7, phone.length)}";
    }

    return "${phone.substring(0, 4)} ${phone.substring(4, 7)} ${phone.substring(7, 10)}";
  }


  static double? convertNumberNull(dynamic data) {
    var res = isNumeric(data.toString());
    if (res) {
      return double.parse(data.toString());
    }
    return null;
  }

  static convertContact(
    String? value,
  ) {
    if (value != null) {
      String data = value.replaceAll(" ", '');
      String data1 = data.replaceAll("-", '');
      String data2 = data1.replaceAll("+", '');
      if (data2.startsWith("84")) {
        return "0${data2.substring(2, data2.length)}";
      }
      return data2;
    }
    return "";
  }

  static double convertNumber(dynamic data) {
    var res = isNumeric(data.toString());
    if (res) {
      return double.parse(data.toString());
    }
    return 0;
  }

  static bool isNumeric(String result) {
    if (result == null) {
      return false;
    }
    return double.tryParse(result) != null;
  }

  static checkImage(String link) {
    bool check = false;
    for (var element in image_types) {
      if (link.contains(element)) {
        check = true;
      }
    }
    return check;
  }

  static callLaunch(url) async {
    if (!await launch(url)) {
      throw 'Could not launch $url';
    }
  }

}

extension HexColor on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}


List<String> timeFilter(String time) {
  DateTime now = DateTime.now();
  DateTime dayStart, dayEnd;

  switch (time) {
    case "Hôm nay":
      dayStart = DateTime(now.year, now.month, now.day);
      dayEnd = DateTime(now.year, now.month, now.day, 23, 59, 59);
      break;
    case "Hôm qua":
      dayStart = DateTime(now.year, now.month, now.day - 1);
      dayEnd = DateTime(now.year, now.month, now.day - 1, 23, 59, 59);
      break;
    case "Tháng này":
      dayStart = DateTime(now.year, now.month, 1);
      dayEnd = DateTime(now.year, now.month + 1, 0, 23, 59, 59);
      break;
    case "Tháng trước":
      dayStart = DateTime(now.year, now.month - 1, 1);
      dayEnd = DateTime(now.year, now.month, 0, 23, 59, 59);
      break;
    case "30 ngày":
      dayStart = now.subtract(Duration(days: 30));
      dayEnd = DateTime(now.year, now.month, now.day, 23, 59, 59);
      break;
    case "Năm nay":
      dayStart = DateTime(now.year, 1, 1);
      dayEnd = DateTime(now.year, 12, 31, 23, 59, 59);
      break;
    default:
      return [];
  }

  int sTimestamp = (dayStart.millisecondsSinceEpoch / 1000).round();
  int eTimestamp = (dayEnd.millisecondsSinceEpoch / 1000).round();
  return [sTimestamp.toString(), eTimestamp.toString()];
}