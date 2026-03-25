import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/features/venue_staff/dashboard/data/models/staff_dashboard_models.dart';
import 'package:dat_san_247_mobile/features/venue_staff/dashboard/presentation/widgets/notification_card.dart';
import 'package:dat_san_247_mobile/features/venue_staff/dashboard/presentation/widgets/notification_date_separator.dart';
import 'package:dat_san_247_mobile/features/venue_staff/dashboard/presentation/widgets/notification_filter_chip.dart';
import 'package:dat_san_247_mobile/routes/base/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ══════════════════════════════════════════════════════════════════════════════
// Staff Notifications Page
// DB: notifications (user_id=me), type filter for staff-relevant types
// ══════════════════════════════════════════════════════════════════════════════
@route
class StaffNotificationsPage extends StatefulWidget {
  const StaffNotificationsPage({super.key});

  @override
  State<StaffNotificationsPage> createState() => _StaffNotificationsPageState();
}

class _StaffNotificationsPageState extends State<StaffNotificationsPage> {
  static const Color _brand = Color(0xFF7C3AED);
  StaffNotifType? _filter;

  final List<StaffNotificationModel> _notifs = _buildMock();

  static List<StaffNotificationModel> _buildMock() {
    final now = DateTime.now();
    return [
      StaffNotificationModel(
          id: 'n1',
          title: 'Booking mới vừa đặt',
          body: 'Nguyễn Văn An đặt Sân A, 18:00–19:30 hôm nay',
          type: StaffNotifType.newBooking,
          referenceId: 'b3',
          isRead: false,
          createdAt: now.subtract(const Duration(minutes: 5))),
      StaffNotificationModel(
          id: 'n2',
          title: 'Khách chưa check-in',
          body: 'Booking DS24799104 – Lê Hoàng Dũng, Sân A 20:00. Quá giờ 15 phút.',
          type: StaffNotifType.checkInAlert,
          referenceId: 'b4',
          isRead: false,
          createdAt: now.subtract(const Duration(minutes: 22))),
      StaffNotificationModel(
          id: 'n3',
          title: 'Booking bị huỷ',
          body: 'Trần Thị Bình đã huỷ booking DS24799102 tại Sân A',
          type: StaffNotifType.bookingCancelled,
          referenceId: 'b2',
          isRead: false,
          createdAt: now.subtract(const Duration(hours: 1))),
      StaffNotificationModel(
          id: 'n4',
          title: '🔧 Bảo trì khẩn cấp',
          body: 'Sân CL cần bảo trì khẩn: hệ thống đèn hỏng. Liên hệ quản lý.',
          type: StaffNotifType.maintenanceAlert,
          isRead: true,
          createdAt: now.subtract(const Duration(hours: 3))),
      StaffNotificationModel(
          id: 'n5',
          title: 'Booking mới – Sân B',
          body: 'Vũ Văn Phúc đặt Sân B, 17:00–18:00 hôm nay',
          type: StaffNotifType.newBooking,
          isRead: true,
          createdAt: now.subtract(const Duration(hours: 5))),
      StaffNotificationModel(
          id: 'n6',
          title: 'Cập nhật hệ thống',
          body: 'Phiên bản 2.4.1 đã phát hành. Các lỗi nhỏ đã được sửa.',
          type: StaffNotifType.systemAlert,
          isRead: true,
          createdAt: now.subtract(const Duration(days: 1))),
      StaffNotificationModel(
          id: 'n7',
          title: 'Khách đánh giá mới',
          body: 'Nguyễn Thị C để lại đánh giá 5⭐ cho Sân A',
          type: StaffNotifType.reviewReply,
          isRead: true,
          createdAt: now.subtract(const Duration(days: 2))),
    ];
  }

  List<StaffNotificationModel> get _filtered =>
      _filter == null ? _notifs : _notifs.where((n) => n.type == _filter).toList();

  int get _unreadCount => _notifs.where((n) => !n.isRead).length;

  void _markAllRead() {
    HapticFeedback.selectionClick();
    setState(() {
      for (int i = 0; i < _notifs.length; i++) {
        /* mark read via API */
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      body: CustomScrollView(
        slivers: [
          // ── AppBar ──
          SliverAppBar(
            pinned: true,
            backgroundColor: _brand,
            automaticallyImplyLeading: false,
            title: const Text('Thông báo hệ thống',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
            actions: [
              if (_unreadCount > 0)
                TextButton(
                  onPressed: _markAllRead,
                  child:
                      const Text('Đọc hết', style: TextStyle(color: Colors.white70, fontSize: 12)),
                ),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(40),
              child: Container(
                color: _brand,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
                  child: Row(children: [
                    NotificationFilterChip(
                        label: 'Tất cả',
                        selected: _filter == null,
                        onTap: () => setState(() => _filter = null),
                        brand: _brand),
                    ..._typeFilters.map((t) => NotificationFilterChip(
                          label: t.label,
                          selected: _filter == t,
                          onTap: () => setState(() => _filter = t),
                          brand: _brand,
                          count: _notifs.where((n) => n.type == t && !n.isRead).length,
                        )),
                  ]),
                ),
              ),
            ),
          ),

          // ── List ──
          _filtered.isEmpty
              ? const SliverFillRemaining(
                  child: Center(
                      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Icon(Icons.notifications_off_outlined, size: 48, color: AppColors.textHint),
                    SizedBox(height: 12),
                    Text('Không có thông báo', style: TextStyle(color: AppColors.textHint)),
                  ])),
                )
              : SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (_, i) {
                      // Date separators
                      final notif = _filtered[i];
                      final showDate =
                          i == 0 || !_sameDay(_filtered[i - 1].createdAt, notif.createdAt);
                      return Column(children: [
                        if (showDate) NotificationDateSeparator(date: notif.createdAt),
                        NotificationCard(
                          notif: notif,
                          onTap: () => setState(() {
                            /* mark read */
                          }),
                        ),
                      ]);
                    },
                    childCount: _filtered.length,
                  ),
                ),

          const SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),
    );
  }

  bool _sameDay(DateTime a, DateTime b) => a.year == b.year && a.month == b.month && a.day == b.day;

  static const _typeFilters = [
    StaffNotifType.newBooking,
    StaffNotifType.checkInAlert,
    StaffNotifType.bookingCancelled,
    StaffNotifType.maintenanceAlert,
    StaffNotifType.systemAlert,
  ];
}
