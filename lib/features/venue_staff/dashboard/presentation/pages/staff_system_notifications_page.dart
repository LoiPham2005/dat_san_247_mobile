import 'package:dat_san_247_mobile/features/venue_staff/dashboard/presentation/widgets/system_notification_card.dart';
import 'package:dat_san_247_mobile/features/venue_staff/dashboard/presentation/widgets/system_notification_date_label.dart';
import 'package:dat_san_247_mobile/features/venue_staff/dashboard/presentation/widgets/system_notification_type_chip.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/features/venue_staff/pricing/data/models/pricing_models.dart';
import 'package:dat_san_247_mobile/routes/base/annotations.dart';

// ══════════════════════════════════════════════════════════════════════════════
// VS-11: Thông Báo — Staff Notification Centre
// DB: notifications { id, user_id, type, channel, title, message,
//     reference_id, reference_type, is_read, read_at, created_at }
// ══════════════════════════════════════════════════════════════════════════════
@route
class StaffSystemNotificationsPage extends StatefulWidget {
  const StaffSystemNotificationsPage({super.key});

  @override
  State<StaffSystemNotificationsPage> createState() => _StaffSystemNotificationsPageState();
}

class _StaffSystemNotificationsPageState extends State<StaffSystemNotificationsPage> {
  static const Color _brand = Color(0xFF7C3AED);
  StaffSystemNotifType? _typeFilter;
  bool _unreadOnly = false;

  late List<StaffSystemNotificationModel> _notifs = _buildMock();

  static List<StaffSystemNotificationModel> _buildMock() {
    final now = DateTime.now();
    return [
      StaffSystemNotificationModel(
          id: 'sn1',
          userId: 'u1',
          type: StaffSystemNotifType.BOOKING_CONFIRMED,
          channel: StaffNotifChannel.IN_APP,
          title: 'Booking mới xác nhận',
          message: 'Nguyễn Văn An — Sân A, 18:00–19:30, hôm nay. Khách đã thanh toán đủ.',
          referenceId: 'b3',
          referenceType: StaffNotifReferenceType.BOOKING,
          isRead: false,
          createdAt: now.subtract(const Duration(minutes: 4))),
      StaffSystemNotificationModel(
          id: 'sn2',
          userId: 'u1',
          type: StaffSystemNotifType.BOOKING_REMINDER,
          channel: StaffNotifChannel.PUSH,
          title: 'Nhắc booking sắp tới',
          message: 'Trần Thị Bình — Sân A, 20:00–21:30 (còn 30 phút). Đã xác nhận, chưa check-in.',
          referenceId: 'b4',
          referenceType: StaffNotifReferenceType.BOOKING,
          isRead: false,
          createdAt: now.subtract(const Duration(minutes: 30))),
      StaffSystemNotificationModel(
          id: 'sn3',
          userId: 'u1',
          type: StaffSystemNotifType.BOOKING_CANCELLED,
          channel: StaffNotifChannel.IN_APP,
          title: 'Booking bị huỷ',
          message: 'Phạm Văn Cường đã huỷ Sân B, 17:00–18:00. Lý do: Bận việc đột xuất.',
          referenceId: 'b5',
          referenceType: StaffNotifReferenceType.BOOKING,
          isRead: false,
          createdAt: now.subtract(const Duration(hours: 1))),
      StaffSystemNotificationModel(
          id: 'sn4',
          userId: 'u1',
          type: StaffSystemNotifType.SHIFT_REMINDER,
          channel: StaffNotifChannel.PUSH,
          title: 'Nhắc ca làm việc',
          message: 'Ca của bạn bắt đầu lúc 14:00 hôm nay (còn 2 giờ). Sân K34 Phạm Văn Đồng.',
          isRead: false,
          createdAt: now.subtract(const Duration(hours: 2))),
      StaffSystemNotificationModel(
          id: 'sn5',
          userId: 'u1',
          type: StaffSystemNotifType.MAINTENANCE_ALERT,
          channel: StaffNotifChannel.IN_APP,
          title: '⚠️ Cảnh báo bảo trì',
          message: 'Sân CL: Hệ thống đèn cần sửa khẩn. Liên hệ quản lý ngay.',
          referenceType: StaffNotifReferenceType.COURT,
          isRead: true,
          createdAt: now.subtract(const Duration(hours: 3))),
      StaffSystemNotificationModel(
          id: 'sn6',
          userId: 'u1',
          type: StaffSystemNotifType.PAYMENT_SUCCESS,
          channel: StaffNotifChannel.IN_APP,
          title: 'Thanh toán thành công',
          message: 'Booking DS24799101 — Thuần toán 300,000đ qua Ví điện tử.',
          referenceId: 'b1',
          referenceType: StaffNotifReferenceType.PAYMENT,
          isRead: true,
          createdAt: now.subtract(const Duration(hours: 5))),
      StaffSystemNotificationModel(
          id: 'sn7',
          userId: 'u1',
          type: StaffSystemNotifType.NEW_REVIEW,
          channel: StaffNotifChannel.IN_APP,
          title: 'Đánh giá mới 5⭐',
          message: 'Lê Hoàng Dũng: "Sân sạch đẹp, nhân viên thân thiện, sẽ quay lại."',
          referenceType: StaffNotifReferenceType.VENUE,
          isRead: true,
          createdAt: now.subtract(const Duration(days: 1))),
      StaffSystemNotificationModel(
          id: 'sn8',
          userId: 'u1',
          type: StaffSystemNotifType.SYSTEM_ANNOUNCEMENT,
          channel: StaffNotifChannel.IN_APP,
          title: 'Cập nhật hệ thống v2.5',
          message: 'Phiên bản mới có tính năng: QR check-in nhanh hơn, báo cáo nâng cao.',
          isRead: true,
          createdAt: now.subtract(const Duration(days: 2))),
    ];
  }

  List<StaffSystemNotificationModel> get _filtered {
    var list = _notifs.where((n) => _typeFilter == null || n.type == _typeFilter).toList();
    if (_unreadOnly) list = list.where((n) => !n.isRead).toList();
    return list;
  }

  int get _unreadCount => _notifs.where((n) => !n.isRead).length;

  void _markRead(String id) => setState(() {
        final idx = _notifs.indexWhere((n) => n.id == id);
        if (idx >= 0) {
          final old = _notifs[idx];
          _notifs[idx] = StaffSystemNotificationModel(
            id: old.id,
            userId: old.userId,
            type: old.type,
            channel: old.channel,
            title: old.title,
            message: old.message,
            referenceId: old.referenceId,
            referenceType: old.referenceType,
            isRead: true,
            readAt: DateTime.now(),
            createdAt: old.createdAt,
          );
        }
      });

  void _markAllRead() {
    HapticFeedback.selectionClick();
    setState(() {
      for (int i = 0; i < _notifs.length; i++) {
        final old = _notifs[i];
        _notifs[i] = StaffSystemNotificationModel(
          id: old.id,
          userId: old.userId,
          type: old.type,
          channel: old.channel,
          title: old.title,
          message: old.message,
          referenceId: old.referenceId,
          referenceType: old.referenceType,
          isRead: true,
          readAt: DateTime.now(),
          createdAt: old.createdAt,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      body: CustomScrollView(
        slivers: [
          // ── AppBar ──
          SliverAppBar(
            pinned: true,
            backgroundColor: _brand,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white, size: 18),
              onPressed: () => Navigator.pop(context),
            ),
            title: Row(children: [
              const Text('Thông Báo',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              if (_unreadCount > 0) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                  decoration:
                      BoxDecoration(color: AppColors.error, borderRadius: BorderRadius.circular(20)),
                  child: Text('$_unreadCount',
                      style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                ),
              ],
            ]),
            actions: [
              if (_unreadCount > 0)
                TextButton(
                    onPressed: _markAllRead,
                    child: const Text('Đọc hết', style: TextStyle(color: Colors.white70, fontSize: 12))),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(88),
              child: Container(
                color: _brand,
                child: Column(children: [
                  // Type filter
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
                    child: Row(children: [
                      SystemNotificationTypeChip(
                          label: 'Tất cả',
                          selected: _typeFilter == null,
                          brand: _brand,
                          onTap: () => setState(() => _typeFilter = null),
                          count: _notifs.where((n) => !n.isRead).length),
                      ..._priorityTypes.map((t) => SystemNotificationTypeChip(
                            label: t.label,
                            selected: _typeFilter == t,
                            brand: _brand,
                            icon: _typeIcon(t),
                            onTap: () => setState(() => _typeFilter = _typeFilter == t ? null : t),
                            count: _notifs.where((n) => n.type == t && !n.isRead).length,
                          )),
                    ]),
                  ),
                  // Unread only toggle
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
                    child: GestureDetector(
                      onTap: () {
                        HapticFeedback.selectionClick();
                        setState(() => _unreadOnly = !_unreadOnly);
                      },
                      child: Row(children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            color: _unreadOnly ? Colors.white : Colors.transparent,
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: Colors.white70),
                          ),
                          child: _unreadOnly ? Icon(Icons.check_rounded, size: 12, color: _brand) : null,
                        ),
                        const SizedBox(width: 8),
                        const Text('Chỉ hiện chưa đọc',
                            style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w600)),
                      ]),
                    ),
                  ),
                ]),
              ),
            ),
          ),

          // ── Notification list ──
          filtered.isEmpty
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
                      final notif = filtered[i];
                      final showDate =
                          i == 0 || !_sameDay(filtered[i - 1].createdAt, notif.createdAt);
                      return Column(children: [
                        if (showDate) SystemNotificationDateLabel(date: notif.createdAt),
                        SystemNotificationCard(notif: notif, onTap: () => _markRead(notif.id)),
                      ]);
                    },
                    childCount: filtered.length,
                  ),
                ),

          const SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),
    );
  }

  bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  IconData _typeIcon(StaffSystemNotifType t) => switch (t) {
        StaffSystemNotifType.BOOKING_CONFIRMED => Icons.event_available_rounded,
        StaffSystemNotifType.BOOKING_CANCELLED => Icons.event_busy_rounded,
        StaffSystemNotifType.BOOKING_REMINDER => Icons.schedule_rounded,
        StaffSystemNotifType.PAYMENT_SUCCESS => Icons.payment_rounded,
        StaffSystemNotifType.NEW_REVIEW => Icons.star_rounded,
        StaffSystemNotifType.MAINTENANCE_ALERT => Icons.build_rounded,
        StaffSystemNotifType.SYSTEM_ANNOUNCEMENT => Icons.campaign_rounded,
        StaffSystemNotifType.SHIFT_REMINDER => Icons.work_history_rounded,
      };

  static const _priorityTypes = [
    StaffSystemNotifType.BOOKING_CONFIRMED,
    StaffSystemNotifType.BOOKING_REMINDER,
    StaffSystemNotifType.BOOKING_CANCELLED,
    StaffSystemNotifType.MAINTENANCE_ALERT,
    StaffSystemNotifType.SHIFT_REMINDER,
  ];
}
