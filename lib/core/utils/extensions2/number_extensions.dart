// lib/extensions/number_extensions.dart
import 'package:intl/intl.dart';

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