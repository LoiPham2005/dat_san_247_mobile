import 'package:flutter/cupertino.dart';

extension IntX on int? {
  Widget get withHeight => SizedBox(
        height: (this ?? 0).toDouble(),
      );

  Widget get withWidth => SizedBox(
        width: (this ?? 0).toDouble(),
      );

  Widget get withSize => SizedBox(
        height: (this ?? 0).toDouble(),
        width: (this ?? 0).toDouble(),
      );

  Widget get height => SizedBox(height: this?.toDouble());
  Widget get width => SizedBox(width: this?.toDouble());

  int validator({int? value}) {
    return this ?? value ?? 0;
  }

  String toHHmm() {
    final hours = ((this ?? 0) ~/ 3600);
    final minutes = (((this ?? 0) % 3600) ~/ 60);
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
  }
}

extension DoubleX on double {
  Widget get withHeight => SizedBox(height: this);
  Widget get withWidth => SizedBox(width: this);
  Widget get withSize => SizedBox(height: this, width: this);
}
