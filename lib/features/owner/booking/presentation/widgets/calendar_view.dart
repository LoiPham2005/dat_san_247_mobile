import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';

class CalendarView extends StatelessWidget {
  final DateTime focusedDay, selectedDay;
  final Set<DateTime> daysWithBookings, daysWithPending;
  final void Function(DateTime, DateTime) onDaySelected;
  final void Function(DateTime) onPageChanged;
  const CalendarView(
      {super.key,
      required this.focusedDay,
      required this.selectedDay,
      required this.daysWithBookings,
      required this.daysWithPending,
      required this.onDaySelected,
      required this.onPageChanged});

  @override
  Widget build(BuildContext context) {
    const brand = Color(0xFF0891B2);
    final firstDayOfMonth = DateTime(focusedDay.year, focusedDay.month, 1);
    final daysInMonth = DateTime(focusedDay.year, focusedDay.month + 1, 0).day;
    final startWeekday = firstDayOfMonth.weekday % 7;
    final days = ['CN', 'T2', 'T3', 'T4', 'T5', 'T6', 'T7'];
    return Column(children: [
      // Month navigation
      Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(children: [
            GestureDetector(
                onTap: () => onPageChanged(DateTime(focusedDay.year, focusedDay.month - 1)),
                child: const Icon(Icons.chevron_left_rounded, color: Color(0xFF0891B2))),
            Expanded(
                child: Text(DateFormat('MMMM yyyy', 'vi').format(focusedDay),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold))),
            GestureDetector(
                onTap: () => onPageChanged(DateTime(focusedDay.year, focusedDay.month + 1)),
                child: const Icon(Icons.chevron_right_rounded, color: Color(0xFF0891B2))),
          ])),
      // Day headers
      Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
              children: days
                  .map((d) => Expanded(
                      child: Center(
                          child: Text(d,
                              style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textHint)))))
                  .toList())),
      const SizedBox(height: 6),
      // Day cells
      Padding(
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 10),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7, mainAxisSpacing: 4, crossAxisSpacing: 2, childAspectRatio: 1.1),
            itemCount: startWeekday + daysInMonth,
            itemBuilder: (_, idx) {
              if (idx < startWeekday) return const SizedBox();
              final day = idx - startWeekday + 1;
              final date = DateTime(focusedDay.year, focusedDay.month, day);
              final dateKey = DateTime(date.year, date.month, date.day);
              final isSelected = date.day == selectedDay.day &&
                  date.month == selectedDay.month &&
                  date.year == selectedDay.year;
              final isToday = date.day == DateTime.now().day &&
                  date.month == DateTime.now().month &&
                  date.year == DateTime.now().year;
              final hasBooking = daysWithBookings.contains(dateKey);
              final hasPending = daysWithPending.contains(dateKey);
              return GestureDetector(
                onTap: () => onDaySelected(date, date),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  decoration: BoxDecoration(
                      color: isSelected
                          ? brand
                          : isToday
                              ? brand.withOpacity(0.1)
                              : Colors.transparent,
                      shape: BoxShape.circle),
                  child: Stack(alignment: Alignment.center, children: [
                    Center(
                        child: Text('$day',
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: isSelected || isToday ? FontWeight.bold : FontWeight.normal,
                                color: isSelected
                                    ? Colors.white
                                    : isToday
                                        ? brand
                                        : AppColors.textPrimary))),
                    if (hasBooking && !isSelected)
                      Positioned(
                          bottom: 2,
                          child: Row(mainAxisSize: MainAxisSize.min, children: [
                            Container(
                                width: 4,
                                height: 4,
                                decoration: BoxDecoration(
                                    color: hasPending ? AppColors.warning : AppColors.info,
                                    shape: BoxShape.circle)),
                          ])),
                  ]),
                ),
              );
            },
          )),
    ]);
  }
}
