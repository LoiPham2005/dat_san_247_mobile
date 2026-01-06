// import 'package:intl/intl.dart';
//
// /// Formatters cho các loại dữ liệu
// class Formatters {
//   Formatters._();
//
//   // ═══════════════════════════════════════════════════════════════
//   // DATE TIME
//   // ═══════════════════════════════════════════════════════════════
//
//   static final _dateFormat = DateFormat('dd/MM/yyyy');
//   static final _timeFormat = DateFormat('HH:mm');
//   static final _dateTimeFormat = DateFormat('dd/MM/yyyy HH:mm');
//   static final _monthYearFormat = DateFormat('MM/yyyy');
//
//   /// Format date: 01/01/2024
//   static String date(DateTime? date) {
//     if (date == null) return '';
//     return _dateFormat.format(date);
//   }
//
//   /// Format time: 14:30
//   static String time(DateTime? date) {
//     if (date == null) return '';
//     return _timeFormat.format(date);
//   }
//
//   /// Format datetime: 01/01/2024 14:30
//   static String dateTime(DateTime? date) {
//     if (date == null) return '';
//     return _dateTimeFormat.format(date);
//   }
//
//   /// Format month year: 01/2024
//   static String monthYear(DateTime? date) {
//     if (date == null) return '';
//     return _monthYearFormat.format(date);
//   }
//
//   /// Time ago: 5 phút trước, 2 giờ trước...
//   static String timeAgo(DateTime date) {
//     final difference = DateTime.now().difference(date);
//
//     if (difference.inDays > 365) {
//       return '${(difference.inDays / 365).floor()} năm trước';
//     } else if (difference.inDays > 30) {
//       return '${(difference.inDays / 30).floor()} tháng trước';
//     } else if (difference.inDays > 0) {
//       return '${difference.inDays} ngày trước';
//     } else if (difference.inHours > 0) {
//       return '${difference.inHours} giờ trước';
//     } else if (difference.inMinutes > 0) {
//       return '${difference.inMinutes} phút trước';
//     } else {
//       return 'Vừa xong';
//     }
//   }
//
//   // ═══════════════════════════════════════════════════════════════
//   // NUMBER
//   // ═══════════════════════════════════════════════════════════════
//
//   static final _currencyFormat = NumberFormat.currency(
//     locale: 'vi_VN',
//     symbol: '₫',
//     decimalDigits: 0,
//   );
//
//   static final _numberFormat = NumberFormat('#,###', 'vi_VN');
//   static final _percentFormat = NumberFormat.percentPattern('vi_VN');
//
//   /// Format currency: 1.000.000 ₫
//   static String currency(num? amount) {
//     if (amount == null) return '0 ₫';
//     return _currencyFormat.format(amount);
//   }
//
//   /// Format number: 1,000,000
//   static String number(num? value) {
//     if (value == null) return '0';
//     return _numberFormat.format(value);
//   }
//
//   /// Format percent: 50%
//   static String percent(num? value, {int decimals = 0}) {
//     if (value == null) return '0%';
//     return '${value.toStringAsFixed(decimals)}%';
//   }
//
//   /// Compact number: 1K, 1M, 1B
//   static String compact(num? value) {
//     if (value == null) return '0';
//     return NumberFormat.compact().format(value);
//   }
//
//   // ═══════════════════════════════════════════════════════════════
//   // STRING
//   // ═══════════════════════════════════════════════════════════════
//
//   /// Truncate string với ellipsis
//   static String truncate(String? text, int maxLength) {
//     if (text == null || text.length <= maxLength) return text ?? '';
//     return '${text.substring(0, maxLength)}...';
//   }
//
//   /// Capitalize first letter
//   static String capitalize(String? text) {
//     if (text == null || text.isEmpty) return '';
//     return text[0].toUpperCase() + text.substring(1).toLowerCase();
//   }
//
//   /// Mask phone: 0912***345
//   static String maskPhone(String? phone) {
//     if (phone == null || phone.length < 7) return phone ?? '';
//     return '${phone.substring(0, 4)}***${phone.substring(phone.length - 3)}';
//   }
//
//   /// Mask email: a***@gmail.com
//   static String maskEmail(String? email) {
//     if (email == null || !email.contains('@')) return email ?? '';
//     final parts = email.split('@');
//     final name = parts[0];
//     final domain = parts[1];
//     if (name.length <= 2) return email;
//     return '${name[0]}***@$domain';
//   }
// }
