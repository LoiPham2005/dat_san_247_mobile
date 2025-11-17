// lib/extensions/datetime_extensions.dart

import 'package:intl/intl.dart';

extension DateTimeExtensions on DateTime {
  // Format date
  String format([String pattern = 'dd/MM/yyyy']) {
    return DateFormat(pattern).format(this);
  }

  String get toDateString => format('dd/MM/yyyy');
  String get toTimeString => format('HH:mm');
  String get toDateTimeString => format('dd/MM/yyyy HH:mm');
  String get toFullDateTimeString => format('dd/MM/yyyy HH:mm:ss');

  // Kiểm tra
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year &&
        month == yesterday.month &&
        day == yesterday.day;
  }

  bool get isTomorrow {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return year == tomorrow.year &&
        month == tomorrow.month &&
        day == tomorrow.day;
  }

  bool get isPast => isBefore(DateTime.now());
  bool get isFuture => isAfter(DateTime.now());

  // Tính toán
  DateTime get startOfDay => DateTime(year, month, day);
  DateTime get endOfDay => DateTime(year, month, day, 23, 59, 59, 999);

  DateTime get startOfMonth => DateTime(year, month, 1);
  DateTime get endOfMonth => DateTime(year, month + 1, 0, 23, 59, 59, 999);

  int get daysInMonth => DateTime(year, month + 1, 0).day;

  DateTime addDays(int days) => add(Duration(days: days));
  DateTime subtractDays(int days) => subtract(Duration(days: days));

  // Khoảng cách thời gian
  String get timeAgo {
    final difference = DateTime.now().difference(this);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return '$years năm trước';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return '$months tháng trước';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} ngày trước';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} giờ trước';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} phút trước';
    } else {
      return 'Vừa xong';
    }
  }
}

// lib/extensions/number_extensions.dart

extension IntExtensions on int {
  // Duration helpers
  Duration get milliseconds => Duration(milliseconds: this);
  Duration get seconds => Duration(seconds: this);
  Duration get minutes => Duration(minutes: this);
  Duration get hours => Duration(hours: this);
  Duration get days => Duration(days: this);

  // Currency format
  String toCurrency({String symbol = '₫'}) {
    final formatter = NumberFormat('#,###');
    return '${formatter.format(this)}$symbol';
  }

  // Range
  List<int> to(int end, {int step = 1}) {
    if (step == 0) throw ArgumentError('Step cannot be zero');
    if (step > 0 && this > end) return [];
    if (step < 0 && this < end) return [];

    final result = <int>[];
    var current = this;
    
    if (step > 0) {
      while (current <= end) {
        result.add(current);
        current += step;
      }
    } else {
      while (current >= end) {
        result.add(current);
        current += step;
      }
    }
    
    return result;
  }

  // Times (lặp lại)
  void times(void Function(int index) action) {
    for (var i = 0; i < this; i++) {
      action(i);
    }
  }

  // Padding
  String padLeft(int width, [String padding = '0']) {
    return toString().padLeft(width, padding);
  }
}

extension DoubleExtensions on double {
  // Làm tròn
  double roundToDecimal(int places) {
    final mod = 10.0 * places;
    return (this * mod).round().toDouble() / mod;
  }

  // Currency format
  String toCurrency({String symbol = '₫', int decimalDigits = 0}) {
    final formatter = NumberFormat('#,###${decimalDigits > 0 ? '.' : ''}${'#' * decimalDigits}');
    return '${formatter.format(this)}$symbol';
  }

  // Percentage
  String toPercentage({int decimalDigits = 0}) {
    return '${(this * 100).toStringAsFixed(decimalDigits)}%';
  }
}