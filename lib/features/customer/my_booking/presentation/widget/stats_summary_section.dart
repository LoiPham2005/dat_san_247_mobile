import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../pages/my_booking_page.dart';
import '../utils/booking_const.dart';

class StatsSummarySection extends StatelessWidget {
  final List<BookingModel> bookings;

  const StatsSummarySection({
    super.key,
    required this.bookings,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final upcomingCount = bookings.where((b) =>
      b.date.isAfter(DateTime.now()) &&
      (b.status == BookingStatus.confirmed ||
       b.status == BookingStatus.pending),
    ).length;

    final completedCount = bookings
        .where((b) => b.status == BookingStatus.completed)
        .length;

    final totalSpent = bookings
        .where((b) => b.status == BookingStatus.completed && b.isPaid)
        .fold(0.0, (sum, b) => sum + b.price);

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 8, 20, 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [theme.primaryColor, theme.primaryColor.withOpacity(0.8)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: theme.primaryColor.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildStatItem(Icons.upcoming, upcomingCount.toString(), 'Sắp tới'),
          _buildDivider(),
          _buildStatItem(Icons.check_circle, completedCount.toString(), 'Đã hoàn thành'),
          _buildDivider(),
          _buildStatItem(
            Icons.account_balance_wallet,
            '${NumberFormat('#,##0').format(totalSpent)}đ',
            'Đã chi tiêu',
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String value, String label) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: Colors.white.withOpacity(0.9), size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      width: 1,
      height: 40,
      color: Colors.white.withOpacity(0.3),
    );
  }
}
