import 'package:dat_san_247_mobile/features/my_booking/presentation/utils/booking_const.dart';
import 'package:flutter/material.dart';

class BookingStatusUtils {
  static String getStatusText(BookingStatus status) {
    switch (status) {
    case BookingStatus.pending:
      return 'Chờ xác nhận';
    case BookingStatus.confirmed:
      return 'Đã xác nhận';
    case BookingStatus.completed:
      return 'Đã hoàn thành';
    case BookingStatus.cancelled:
      return 'Đã hủy';
    case BookingStatus.noShow:
      return 'Khách không đến';
  }
  }

  static Color getStatusColor(BookingStatus status) {
    switch (status) {
    case BookingStatus.pending:
      return Colors.orange;
    case BookingStatus.confirmed:
      return Colors.blue;
    case BookingStatus.completed:
      return Colors.green;
    case BookingStatus.cancelled:
      return Colors.red;
    case BookingStatus.noShow:
      return Colors.grey;
  }
  }

  static IconData getStatusIcon(BookingStatus status) {
      switch (status) {
    case BookingStatus.pending:
      return Icons.hourglass_empty;
    case BookingStatus.confirmed:
      return Icons.check_circle;
    case BookingStatus.completed:
      return Icons.done_all;
    case BookingStatus.cancelled:
      return Icons.cancel;
          case BookingStatus.noShow:
      return Icons.event_busy;
  }
  }
}