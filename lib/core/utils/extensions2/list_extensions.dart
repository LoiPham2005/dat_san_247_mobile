// lib/extensions/list_extensions.dart

import 'package:flutter/material.dart';

extension ListExtensions<T> on List<T> {
  // Safe access
  T? get firstOrNull => isEmpty ? null : first;
  T? get lastOrNull => isEmpty ? null : last;

  T? elementAtOrNull(int index) {
    if (index < 0 || index >= length) return null;
    return this[index];
  }

  // Kiểm tra
  bool get isNullOrEmpty => isEmpty;
  bool get isNotNullOrEmpty => isNotEmpty;

  // Tách list
  List<List<T>> chunk(int size) {
    final chunks = <List<T>>[];
    for (var i = 0; i < length; i += size) {
      chunks.add(sublist(i, i + size > length ? length : i + size));
    }
    return chunks;
  }

  // Unique
  List<T> get unique => toSet().toList();

  // Distinct by property
  List<T> distinctBy<K>(K Function(T) keySelector) {
    final seen = <K>{};
    return where((item) => seen.add(keySelector(item))).toList();
  }

  // Group by
  Map<K, List<T>> groupBy<K>(K Function(T) keySelector) {
    final map = <K, List<T>>{};
    for (final item in this) {
      final key = keySelector(item);
      (map[key] ??= []).add(item);
    }
    return map;
  }

  // Sum
  num sum(num Function(T) selector) {
    return fold<num>(0, (prev, item) => prev + selector(item));
  }

  // Average
  double average(num Function(T) selector) {
    if (isEmpty) return 0;
    return sum(selector) / length;
  }

  // Max/Min
  T? maxBy<R extends Comparable>(R Function(T) selector) {
    if (isEmpty) return null;
    return reduce((a, b) => selector(a).compareTo(selector(b)) > 0 ? a : b);
  }

  T? minBy<R extends Comparable>(R Function(T) selector) {
    if (isEmpty) return null;
    return reduce((a, b) => selector(a).compareTo(selector(b)) < 0 ? a : b);
  }

  // Shuffle immutable
  List<T> shuffled() {
    final list = List<T>.from(this);
    list.shuffle();
    return list;
  }

  // Take random
  T? random() {
    if (isEmpty) return null;
    return this[(length * (DateTime.now().millisecondsSinceEpoch % length)) ~/ length];
  }

  // Separate with divider (cho widgets)
  List<T> separated(T separator) {
    if (isEmpty) return this;
    final result = <T>[];
    for (var i = 0; i < length; i++) {
      result.add(this[i]);
      if (i < length - 1) {
        result.add(separator);
      }
    }
    return result;
  }
}

extension WidgetListExtensions on List<Widget> {
  // Thêm spacing giữa các widgets
  List<Widget> withSpacing(double spacing) {
    if (isEmpty) return this;
    final result = <Widget>[];
    for (var i = 0; i < length; i++) {
      result.add(this[i]);
      if (i < length - 1) {
        result.add(SizedBox(width: spacing, height: spacing));
      }
    }
    return result;
  }

  // Thêm divider
  List<Widget> withDivider({
    double height = 1,
    Color? color,
    double indent = 0,
    double endIndent = 0,
  }) {
    if (isEmpty) return this;
    final result = <Widget>[];
    for (var i = 0; i < length; i++) {
      result.add(this[i]);
      if (i < length - 1) {
        result.add(Divider(
          height: height,
          color: color,
          indent: indent,
          endIndent: endIndent,
        ));
      }
    }
    return result;
  }

  // Wrap trong Column
  Column toColumn({
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
    MainAxisSize mainAxisSize = MainAxisSize.max,
  }) {
    return Column(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: mainAxisSize,
      children: this,
    );
  }

  // Wrap trong Row
  Row toRow({
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
    MainAxisSize mainAxisSize = MainAxisSize.max,
  }) {
    return Row(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: mainAxisSize,
      children: this,
    );
  }

  // Wrap trong Wrap
  Wrap toWrap({
    Axis direction = Axis.horizontal,
    WrapAlignment alignment = WrapAlignment.start,
    double spacing = 0.0,
    WrapAlignment runAlignment = WrapAlignment.start,
    double runSpacing = 0.0,
    WrapCrossAlignment crossAxisAlignment = WrapCrossAlignment.start,
  }) {
    return Wrap(
      direction: direction,
      alignment: alignment,
      spacing: spacing,
      runAlignment: runAlignment,
      runSpacing: runSpacing,
      crossAxisAlignment: crossAxisAlignment,
      children: this,
    );
  }
}