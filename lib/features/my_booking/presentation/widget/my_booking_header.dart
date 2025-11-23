import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class MyBookingHeader extends StatelessWidget {
  const MyBookingHeader({super.key});

  void _showCalendarView(
    BuildContext context,
    Map<DateTime, List<String>> events,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return CalendarBottomSheet(events: events);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Ví dụ các ngày đã có booking (demo). Khi tích hợp backend, thay bằng dữ liệu thật.
    final Map<DateTime, List<String>> sampleEvents = {
      DateTime.utc(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day + 2,
      ): [
        'Sân A — 18:00 - 20:00',
      ],
      DateTime.utc(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day + 5,
      ): [
        'Sân B — 07:00 - 09:00',
      ],
      DateTime.utc(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day - 1,
      ): [
        'Sân C — 20:00 - 22:00',
      ],
    };

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  theme.primaryColor,
                  theme.primaryColor.withOpacity(0.7),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: theme.primaryColor.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.calendar_month,
              color: Colors.white,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Đặt Sân Của Tôi',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3748),
                  ),
                ),
                Text(
                  'Quản lý lịch đặt sân',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              _showCalendarView(context, sampleEvents);
            },
            icon: Icon(Icons.calendar_view_month, color: theme.primaryColor),
            style: IconButton.styleFrom(
              backgroundColor: theme.primaryColor.withOpacity(0.1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CalendarBottomSheet extends StatefulWidget {
  final Map<DateTime, List<String>> events;
  const CalendarBottomSheet({Key? key, required this.events}) : super(key: key);

  @override
  State<CalendarBottomSheet> createState() => _CalendarBottomSheetState();
}

class _CalendarBottomSheetState extends State<CalendarBottomSheet> {
  late final ValueNotifier<List<String>> _selectedEvents;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  // Normalize key to midnight UTC (or local) so map lookup matches
  DateTime _normalizeDate(DateTime d) => DateTime.utc(d.year, d.month, d.day);

  List<String> _getEventsForDay(DateTime day) {
    final key = _normalizeDate(day);
    return widget.events[key] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.85,
      maxChildSize: 0.95,
      builder: (_, controller) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              width: 60,
              height: 6,
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Lịch đặt sân',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: theme.primaryColorDark,
                    ),
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    // ví dụ: nhảy tới hôm nay
                    setState(() {
                      _focusedDay = DateTime.now();
                      _selectedDay = _focusedDay;
                      _selectedEvents.value = _getEventsForDay(_selectedDay!);
                    });
                  },
                  icon: const Icon(Icons.today),
                  label: const Text('Hôm nay'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Column(
                children: [
                  TableCalendar<String>(
                    firstDay: DateTime.utc(2020, 1, 1),
                    lastDay: DateTime.utc(2035, 12, 31),
                    focusedDay: _focusedDay,
                    selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                    eventLoader: _getEventsForDay,
                    headerStyle: HeaderStyle(
                      titleCentered: true,
                      formatButtonVisible: false,
                      titleTextStyle: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: theme.primaryColor,
                      ),
                      leftChevronIcon: Icon(
                        Icons.chevron_left,
                        color: theme.primaryColor,
                      ),
                      rightChevronIcon: Icon(
                        Icons.chevron_right,
                        color: theme.primaryColor,
                      ),
                    ),
                    calendarStyle: CalendarStyle(
                      markerDecoration: BoxDecoration(
                        color: Colors.orange,
                        shape: BoxShape.circle,
                      ),
                      todayDecoration: BoxDecoration(
                        color: theme.primaryColor,
                        shape: BoxShape.circle,
                      ),
                      selectedDecoration: BoxDecoration(
                        color: Colors.deepOrange,
                        shape: BoxShape.circle,
                      ),
                      outsideDaysVisible: false,
                    ),
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                        _selectedEvents.value = _getEventsForDay(selectedDay);
                      });
                    },
                    onPageChanged: (focusedDay) {
                      _focusedDay = focusedDay;
                    },
                    calendarBuilders: CalendarBuilders(
                      markerBuilder: (context, date, events) {
                        if (events.isNotEmpty) {
                          return Positioned(
                            bottom: 4,
                            child: Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: Colors.orange,
                                shape: BoxShape.circle,
                              ),
                            ),
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.all(12),
                      child: ValueListenableBuilder<List<String>>(
                        valueListenable: _selectedEvents,
                        builder: (context, value, _) {
                          if (value.isEmpty) {
                            return Center(
                              child: Text(
                                'Không có lịch trong ngày ${DateFormat.yMMMd('vi').format(_selectedDay ?? DateTime.now())}',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            );
                          }
                          return ListView.separated(
                            itemCount: value.length,
                            separatorBuilder: (_, __) => const Divider(),
                            itemBuilder: (context, index) {
                              final ev = value[index];
                              return ListTile(
                                leading: const Icon(Icons.sports_soccer),
                                title: Text(ev),
                                trailing: ElevatedButton(
                                  onPressed: () {
                                    // navigate to booking detail / re-book
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Mở chi tiết: $ev'),
                                      ),
                                    );
                                  },
                                  child: const Text('Chi tiết'),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:table_calendar/table_calendar.dart';
// import 'package:intl/intl.dart';

// class MyBookingHeader extends StatelessWidget {
//   const MyBookingHeader({super.key});

//   void _showCalendarView(
//     BuildContext context,
//     Map<DateTime, List<String>> events,
//   ) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (context) {
//         return CalendarBottomSheet(events: events);
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final size = MediaQuery.of(context).size;

//     // Ví dụ các ngày đã có booking (demo). Khi tích hợp backend, thay bằng dữ liệu thật.
//     final Map<DateTime, List<String>> sampleEvents = {
//       DateTime.utc(
//         DateTime.now().year,
//         DateTime.now().month,
//         DateTime.now().day + 2,
//       ): [
//         'Sân A — 18:00 - 20:00',
//       ],
//       DateTime.utc(
//         DateTime.now().year,
//         DateTime.now().month,
//         DateTime.now().day + 5,
//       ): [
//         'Sân B — 07:00 - 09:00',
//       ],
//       DateTime.utc(
//         DateTime.now().year,
//         DateTime.now().month,
//         DateTime.now().day - 1,
//       ): [
//         'Sân C — 20:00 - 22:00',
//       ],
//     };

//     return Container(
//       padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           // User info row
//           Row(
//             children: [
//               // Avatar with badge
//               Stack(
//                 children: [
//                   Container(
//                     width: 45,
//                     height: 45,
//                     decoration: BoxDecoration(
//                       gradient: LinearGradient(
//                         colors: [
//                           theme.primaryColor,
//                           theme.primaryColor.withOpacity(0.8),
//                         ],
//                       ),
//                       borderRadius: BorderRadius.circular(15),
//                       border: Border.all(color: Colors.white, width: 2),
//                       boxShadow: [
//                         BoxShadow(
//                           color: theme.primaryColor.withOpacity(0.3),
//                           blurRadius: 8,
//                           offset: const Offset(0, 4),
//                         ),
//                       ],
//                     ),
//                     child: const Icon(
//                       Icons.sports_soccer,
//                       color: Colors.white,
//                       size: 24,
//                     ),
//                   ),
//                   Positioned(
//                     right: 0,
//                     bottom: 0,
//                     child: Container(
//                       padding: const EdgeInsets.all(4),
//                       decoration: BoxDecoration(
//                         color: Colors.orange,
//                         shape: BoxShape.circle,
//                         border: Border.all(color: Colors.white, width: 2),
//                       ),
//                       child: const Text(
//                         "3",
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 10,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(width: 15),

//               // Title and subtitle
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       'Lịch Đặt Sân',
//                       style: TextStyle(
//                         fontSize: 24,
//                         fontWeight: FontWeight.bold,
//                         letterSpacing: 0.5,
//                         color: Color(0xFF2D3748),
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       'Xem và quản lý lịch đặt sân của bạn',
//                       style: TextStyle(fontSize: 13, color: Colors.grey[600]),
//                     ),
//                   ],
//                 ),
//               ),

//               // Calendar button
//               Container(
//                 decoration: BoxDecoration(
//                   color: theme.primaryColor.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: IconButton(
//                   onPressed: () => _showCalendarView(context, sampleEvents),
//                   icon: Icon(
//                     Icons.calendar_month_rounded,
//                     color: theme.primaryColor,
//                     size: 24,
//                   ),
//                   tooltip: 'Xem lịch',
//                 ),
//               ),
//             ],
//           ),

//           // Quick stats row
//           Container(
//             margin: const EdgeInsets.only(top: 16),
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [
//                   theme.primaryColor.withOpacity(0.1),
//                   theme.primaryColor.withOpacity(0.05),
//                 ],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),
//               borderRadius: BorderRadius.circular(16),
//               border: Border.all(color: theme.primaryColor.withOpacity(0.1)),
//             ),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 _buildQuickStat(
//                   icon: Icons.sports_soccer,
//                   label: 'Tuần này',
//                   value: '3 sân',
//                   theme: theme,
//                 ),
//                 _buildDivider(),
//                 _buildQuickStat(
//                   icon: Icons.timer_outlined,
//                   label: 'Sắp tới',
//                   value: '2 giờ',
//                   theme: theme,
//                 ),
//                 _buildDivider(),
//                 _buildQuickStat(
//                   icon: Icons.star_rounded,
//                   label: 'Đánh giá',
//                   value: '4.8',
//                   theme: theme,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildQuickStat({
//     required IconData icon,
//     required String label,
//     required String value,
//     required ThemeData theme,
//   }) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Icon(icon, color: theme.primaryColor, size: 22),
//         const SizedBox(height: 6),
//         Text(
//           value,
//           style: TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.bold,
//             color: theme.primaryColor,
//           ),
//         ),
//         Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
//       ],
//     );
//   }

//   Widget _buildDivider() {
//     return Container(height: 30, width: 1, color: Colors.grey.withOpacity(0.2));
//   }
// }

// class CalendarBottomSheet extends StatefulWidget {
//   final Map<DateTime, List<String>> events;
//   const CalendarBottomSheet({Key? key, required this.events}) : super(key: key);

//   @override
//   State<CalendarBottomSheet> createState() => _CalendarBottomSheetState();
// }

// class _CalendarBottomSheetState extends State<CalendarBottomSheet> {
//   late final ValueNotifier<List<String>> _selectedEvents;
//   DateTime _focusedDay = DateTime.now();
//   DateTime? _selectedDay;

//   @override
//   void initState() {
//     super.initState();
//     _selectedDay = _focusedDay;
//     _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
//   }

//   @override
//   void dispose() {
//     _selectedEvents.dispose();
//     super.dispose();
//   }

//   // Normalize key to midnight UTC (or local) so map lookup matches
//   DateTime _normalizeDate(DateTime d) => DateTime.utc(d.year, d.month, d.day);

//   List<String> _getEventsForDay(DateTime day) {
//     final key = _normalizeDate(day);
//     return widget.events[key] ?? [];
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     return DraggableScrollableSheet(
//       expand: false,
//       initialChildSize: 0.85,
//       maxChildSize: 0.95,
//       builder: (_, controller) => Container(
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.2),
//               blurRadius: 20,
//               offset: const Offset(0, -4),
//             ),
//           ],
//         ),
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             Container(
//               width: 60,
//               height: 6,
//               margin: const EdgeInsets.only(bottom: 12),
//               decoration: BoxDecoration(
//                 color: Colors.grey[300],
//                 borderRadius: BorderRadius.circular(12),
//               ),
//             ),
//             Row(
//               children: [
//                 Expanded(
//                   child: Text(
//                     'Lịch đặt sân',
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                       color: theme.primaryColorDark,
//                     ),
//                   ),
//                 ),
//                 TextButton.icon(
//                   onPressed: () {
//                     // ví dụ: nhảy tới hôm nay
//                     setState(() {
//                       _focusedDay = DateTime.now();
//                       _selectedDay = _focusedDay;
//                       _selectedEvents.value = _getEventsForDay(_selectedDay!);
//                     });
//                   },
//                   icon: const Icon(Icons.today),
//                   label: const Text('Hôm nay'),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 8),
//             Expanded(
//               child: Column(
//                 children: [
//                   TableCalendar<String>(
//                     firstDay: DateTime.utc(2020, 1, 1),
//                     lastDay: DateTime.utc(2035, 12, 31),
//                     focusedDay: _focusedDay,
//                     selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
//                     eventLoader: _getEventsForDay,
//                     headerStyle: HeaderStyle(
//                       titleCentered: true,
//                       formatButtonVisible: false,
//                       titleTextStyle: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.w600,
//                         color: theme.primaryColor,
//                       ),
//                       leftChevronIcon: Icon(
//                         Icons.chevron_left,
//                         color: theme.primaryColor,
//                       ),
//                       rightChevronIcon: Icon(
//                         Icons.chevron_right,
//                         color: theme.primaryColor,
//                       ),
//                     ),
//                     calendarStyle: CalendarStyle(
//                       markerDecoration: BoxDecoration(
//                         color: Colors.orange,
//                         shape: BoxShape.circle,
//                       ),
//                       todayDecoration: BoxDecoration(
//                         color: theme.primaryColor,
//                         shape: BoxShape.circle,
//                       ),
//                       selectedDecoration: BoxDecoration(
//                         color: Colors.deepOrange,
//                         shape: BoxShape.circle,
//                       ),
//                       outsideDaysVisible: false,
//                     ),
//                     onDaySelected: (selectedDay, focusedDay) {
//                       setState(() {
//                         _selectedDay = selectedDay;
//                         _focusedDay = focusedDay;
//                         _selectedEvents.value = _getEventsForDay(selectedDay);
//                       });
//                     },
//                     onPageChanged: (focusedDay) {
//                       _focusedDay = focusedDay;
//                     },
//                     calendarBuilders: CalendarBuilders(
//                       markerBuilder: (context, date, events) {
//                         if (events.isNotEmpty) {
//                           return Positioned(
//                             bottom: 4,
//                             child: Container(
//                               width: 6,
//                               height: 6,
//                               decoration: BoxDecoration(
//                                 color: Colors.orange,
//                                 shape: BoxShape.circle,
//                               ),
//                             ),
//                           );
//                         }
//                         return const SizedBox();
//                       },
//                     ),
//                   ),
//                   const SizedBox(height: 12),
//                   Expanded(
//                     child: Container(
//                       width: double.infinity,
//                       decoration: BoxDecoration(
//                         color: Colors.grey[50],
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       padding: const EdgeInsets.all(12),
//                       child: ValueListenableBuilder<List<String>>(
//                         valueListenable: _selectedEvents,
//                         builder: (context, value, _) {
//                           if (value.isEmpty) {
//                             return Center(
//                               child: Text(
//                                 'Không có lịch trong ngày ${DateFormat.yMMMd('vi').format(_selectedDay ?? DateTime.now())}',
//                                 style: TextStyle(color: Colors.grey[600]),
//                               ),
//                             );
//                           }
//                           return ListView.separated(
//                             itemCount: value.length,
//                             separatorBuilder: (_, __) => const Divider(),
//                             itemBuilder: (context, index) {
//                               final ev = value[index];
//                               return ListTile(
//                                 leading: const Icon(Icons.sports_soccer),
//                                 title: Text(ev),
//                                 trailing: ElevatedButton(
//                                   onPressed: () {
//                                     // navigate to booking detail / re-book
//                                     Navigator.pop(context);
//                                     ScaffoldMessenger.of(context).showSnackBar(
//                                       SnackBar(
//                                         content: Text('Mở chi tiết: $ev'),
//                                       ),
//                                     );
//                                   },
//                                   child: const Text('Chi tiết'),
//                                 ),
//                               );
//                             },
//                           );
//                         },
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
