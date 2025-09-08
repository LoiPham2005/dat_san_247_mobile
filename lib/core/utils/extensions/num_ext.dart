import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

extension NumX on num? {
  Widget withWidth() {
    return SizedBox(
      width: (this ?? 0).toDouble(),
    );
  }

  Widget withHeight() {
    return SizedBox(
      height: (this ?? 0).toDouble(),
    );
  }

  Widget withSize() {
    return SizedBox(
      height: (this ?? 0).toDouble(),
      width: (this ?? 0).toDouble(),
    );
  }

  num toValidator({int? value}) {
    return this ?? value ?? 0;
  }

  String formatPrice({String? value, String? validate}) {
    if (this == null) {
      return validate ?? "-";
    }
    var formatCurrency =
    NumberFormat.currency(locale: 'en_US', decimalDigits: 0, symbol: this! > 0 ? '' : '-');
    String format = formatCurrency.format(this).replaceAll(',', '.');
    return this! > 0 ? format : format.substring(1, format.length);
  }


}

extension DoubleApproximateCompare on double {
  bool approximatelyEqualTo(double other, [double epsilon = 1e-10]) {
    return (this - other).abs() < epsilon;
  }
}
String formatTimeStamp(int timestamp) {
  if(timestamp.toString().isEmpty){
    return "Đang cập nhật";
  }
  var date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
  var d12 = DateFormat('dd/MM/yyyy hh:mm a').format(date);
  return d12;
}