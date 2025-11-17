import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension IntExtensions on int {
  // ✅ SizedBox helpers
  SizedBox get height => SizedBox(height: toDouble());
  SizedBox get width => SizedBox(width: toDouble());

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

  // Times
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
  // ✅ SizedBox helpers
  SizedBox get height => SizedBox(height: this);
  SizedBox get width => SizedBox(width: this);

  // Round to decimal places
  double roundTo(int decimals) {
    final mod = pow(10, decimals);
    return (this * mod).round() / mod;
  }

  // Currency with decimals
  String toCurrency({String symbol = '₫', int decimals = 0}) {
    final formatter = NumberFormat('#,###${decimals > 0 ? '.${"#" * decimals}' : ''}');
    return '${formatter.format(this)}$symbol';
  }

  // Percentage
  String toPercentage({int decimals = 0}) {
    return '${(this * 100).toStringAsFixed(decimals)}%';
  }
}

extension NumExtensions on num {
  // ✅ SizedBox helpers
  SizedBox get height => SizedBox(height: toDouble());
  SizedBox get width => SizedBox(width: toDouble());
  SizedBox get square => SizedBox(width: toDouble(), height: toDouble());

  // Padding helpers
  EdgeInsets get paddingAll => EdgeInsets.all(toDouble());
  
  // BorderRadius helpers
  BorderRadius get radius => BorderRadius.circular(toDouble());
  Radius get circularRadius => Radius.circular(toDouble());

  // Universal currency formatter
  String formatCurrency({String symbol = '₫', int decimals = 0}) {
    return this is int 
      ? (this as int).toCurrency(symbol: symbol)
      : (this as double).toCurrency(symbol: symbol, decimals: decimals);
  }

  // Universal number formatter
  String formatNumber({int decimals = 0}) {
    final formatter = NumberFormat('#,###${decimals > 0 ? '.${"#" * decimals}' : ''}');
    return formatter.format(this);
  }
}