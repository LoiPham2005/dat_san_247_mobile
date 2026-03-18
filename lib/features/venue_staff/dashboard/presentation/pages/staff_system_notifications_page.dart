import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/features/venue_staff/pricing/data/models/pricing_models.dart';

// ══════════════════════════════════════════════════════════════════════════════
// VS-11: Thông Báo — Staff Notification Centre
// DB: notifications { id, user_id, type, channel, title, message,
//     reference_id, reference_type, is_read, read_at, created_at }
// ══════════════════════════════════════════════════════════════════════════════
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
      StaffSystemNotificationModel(id:'sn1', userId:'u1', type:StaffSystemNotifType.BOOKING_CONFIRMED, channel:StaffNotifChannel.IN_APP, title:'Booking mới xác nhận', message:'Nguyễn Văn An — Sân A, 18:00–19:30, hôm nay. Khách đã thanh toán đủ.', referenceId:'b3', referenceType:StaffNotifReferenceType.BOOKING, isRead:false, createdAt:now.subtract(const Duration(minutes: 4))),
      StaffSystemNotificationModel(id:'sn2', userId:'u1', type:StaffSystemNotifType.BOOKING_REMINDER, channel:StaffNotifChannel.PUSH, title:'Nhắc booking sắp tới', message:'Trần Thị Bình — Sân A, 20:00–21:30 (còn 30 phút). Đã xác nhận, chưa check-in.', referenceId:'b4', referenceType:StaffNotifReferenceType.BOOKING, isRead:false, createdAt:now.subtract(const Duration(minutes: 30))),
      StaffSystemNotificationModel(id:'sn3', userId:'u1', type:StaffSystemNotifType.BOOKING_CANCELLED, channel:StaffNotifChannel.IN_APP, title:'Booking bị huỷ', message:'Phạm Văn Cường đã huỷ Sân B, 17:00–18:00. Lý do: Bận việc đột xuất.', referenceId:'b5', referenceType:StaffNotifReferenceType.BOOKING, isRead:false, createdAt:now.subtract(const Duration(hours: 1))),
      StaffSystemNotificationModel(id:'sn4', userId:'u1', type:StaffSystemNotifType.SHIFT_REMINDER, channel:StaffNotifChannel.PUSH, title:'Nhắc ca làm việc', message:'Ca của bạn bắt đầu lúc 14:00 hôm nay (còn 2 giờ). Sân K34 Phạm Văn Đồng.', isRead:false, createdAt:now.subtract(const Duration(hours: 2))),
      StaffSystemNotificationModel(id:'sn5', userId:'u1', type:StaffSystemNotifType.MAINTENANCE_ALERT, channel:StaffNotifChannel.IN_APP, title:'⚠️ Cảnh báo bảo trì', message:'Sân CL: Hệ thống đèn cần sửa khẩn. Liên hệ quản lý ngay.', referenceType:StaffNotifReferenceType.COURT, isRead:true, createdAt:now.subtract(const Duration(hours: 3))),
      StaffSystemNotificationModel(id:'sn6', userId:'u1', type:StaffSystemNotifType.PAYMENT_SUCCESS, channel:StaffNotifChannel.IN_APP, title:'Thanh toán thành công', message:'Booking DS24799101 — Thuần toán 300,000đ qua Ví điện tử.', referenceId:'b1', referenceType:StaffNotifReferenceType.PAYMENT, isRead:true, createdAt:now.subtract(const Duration(hours: 5))),
      StaffSystemNotificationModel(id:'sn7', userId:'u1', type:StaffSystemNotifType.NEW_REVIEW, channel:StaffNotifChannel.IN_APP, title:'Đánh giá mới 5⭐', message:'Lê Hoàng Dũng: "Sân sạch đẹp, nhân viên thân thiện, sẽ quay lại."', referenceType:StaffNotifReferenceType.VENUE, isRead:true, createdAt:now.subtract(const Duration(days: 1))),
      StaffSystemNotificationModel(id:'sn8', userId:'u1', type:StaffSystemNotifType.SYSTEM_ANNOUNCEMENT, channel:StaffNotifChannel.IN_APP, title:'Cập nhật hệ thống v2.5', message:'Phiên bản mới có tính năng: QR check-in nhanh hơn, báo cáo nâng cao.', isRead:true, createdAt:now.subtract(const Duration(days: 2))),
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
        id: old.id, userId: old.userId, type: old.type, channel: old.channel,
        title: old.title, message: old.message, referenceId: old.referenceId,
        referenceType: old.referenceType, isRead: true, readAt: DateTime.now(),
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
          id: old.id, userId: old.userId, type: old.type, channel: old.channel,
          title: old.title, message: old.message, referenceId: old.referenceId,
          referenceType: old.referenceType, isRead: true, readAt: DateTime.now(),
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
              const Text('Thông Báo', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              if (_unreadCount > 0) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(color: AppColors.error, borderRadius: BorderRadius.circular(20)),
                  child: Text('$_unreadCount', style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                ),
              ],
            ]),
            actions: [
              if (_unreadCount > 0)
                TextButton(onPressed: _markAllRead, child: const Text('Đọc hết', style: TextStyle(color: Colors.white70, fontSize: 12))),
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
                      _TypeChip(label: 'Tất cả', selected: _typeFilter == null, brand: _brand, onTap: () => setState(() => _typeFilter = null),
                        count: _notifs.where((n) => !n.isRead).length),
                      ..._priorityTypes.map((t) => _TypeChip(
                        label: t.label, selected: _typeFilter == t, brand: _brand,
                        icon: _typeIcon(t), onTap: () => setState(() => _typeFilter = _typeFilter == t ? null : t),
                        count: _notifs.where((n) => n.type == t && !n.isRead).length,
                      )),
                    ]),
                  ),
                  // Unread only toggle
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
                    child: GestureDetector(
                      onTap: () { HapticFeedback.selectionClick(); setState(() => _unreadOnly = !_unreadOnly); },
                      child: Row(children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          width: 16, height: 16,
                          decoration: BoxDecoration(
                            color: _unreadOnly ? Colors.white : Colors.transparent,
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: Colors.white70),
                          ),
                          child: _unreadOnly ? Icon(Icons.check_rounded, size: 12, color: _brand) : null,
                        ),
                        const SizedBox(width: 8),
                        const Text('Chỉ hiện chưa đọc', style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w600)),
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
                  child: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Icon(Icons.notifications_off_outlined, size: 48, color: AppColors.textHint),
                    SizedBox(height: 12),
                    Text('Không có thông báo', style: TextStyle(color: AppColors.textHint)),
                  ])),
                )
              : SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (_, i) {
                      final notif = filtered[i];
                      final showDate = i == 0 || !_sameDay(filtered[i-1].createdAt, notif.createdAt);
                      return Column(children: [
                        if (showDate) _DateLabel(date: notif.createdAt),
                        _SysNotifCard(notif: notif, onTap: () => _markRead(notif.id)),
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
    StaffSystemNotifType.BOOKING_CONFIRMED  => Icons.event_available_rounded,
    StaffSystemNotifType.BOOKING_CANCELLED  => Icons.event_busy_rounded,
    StaffSystemNotifType.BOOKING_REMINDER   => Icons.schedule_rounded,
    StaffSystemNotifType.PAYMENT_SUCCESS    => Icons.payment_rounded,
    StaffSystemNotifType.NEW_REVIEW         => Icons.star_rounded,
    StaffSystemNotifType.MAINTENANCE_ALERT  => Icons.build_rounded,
    StaffSystemNotifType.SYSTEM_ANNOUNCEMENT=> Icons.campaign_rounded,
    StaffSystemNotifType.SHIFT_REMINDER     => Icons.work_history_rounded,
  };

  static const _priorityTypes = [
    StaffSystemNotifType.BOOKING_CONFIRMED,
    StaffSystemNotifType.BOOKING_REMINDER,
    StaffSystemNotifType.BOOKING_CANCELLED,
    StaffSystemNotifType.MAINTENANCE_ALERT,
    StaffSystemNotifType.SHIFT_REMINDER,
  ];
}

class _TypeChip extends StatelessWidget {
  final String label; final bool selected; final Color brand; final VoidCallback onTap; final int count; final IconData? icon;
  const _TypeChip({required this.label, required this.selected, required this.brand, required this.onTap, this.count = 0, this.icon});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: () { HapticFeedback.selectionClick(); onTap(); },
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: const EdgeInsets.only(right: 6),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(color: selected ? Colors.white : Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(20)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        if (icon != null) ...[Icon(icon, size: 11, color: selected ? brand : Colors.white70), const SizedBox(width: 4)],
        Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: selected ? brand : Colors.white70)),
        if (count > 0) ...[
          const SizedBox(width: 4),
          Container(width: 14, height: 14, decoration: BoxDecoration(color: AppColors.error, shape: BoxShape.circle),
            child: Center(child: Text('$count', style: const TextStyle(fontSize: 8, color: Colors.white, fontWeight: FontWeight.bold)))),
        ],
      ]),
    ),
  );
}

class _DateLabel extends StatelessWidget {
  final DateTime date;
  const _DateLabel({required this.date});

  String get _label {
    final now = DateTime.now();
    final d = DateTime(date.year, date.month, date.day);
    final today = DateTime(now.year, now.month, now.day);
    if (d == today) return 'Hôm nay';
    if (d == today.subtract(const Duration(days: 1))) return 'Hôm qua';
    return DateFormat('EEEE, dd/MM/yyyy', 'vi').format(date);
  }

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(14, 12, 14, 4),
    child: Row(children: [
      Expanded(child: Divider(color: AppColors.borderLight)),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Text(_label, style: const TextStyle(fontSize: 10, color: AppColors.textHint, fontWeight: FontWeight.bold)),
      ),
      Expanded(child: Divider(color: AppColors.borderLight)),
    ]),
  );
}

class _SysNotifCard extends StatelessWidget {
  final StaffSystemNotificationModel notif;
  final VoidCallback onTap;
  const _SysNotifCard({required this.notif, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final (color, icon) = _style;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: notif.isRead ? Colors.white : color.withOpacity(0.04),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: notif.isRead ? AppColors.borderLight : color.withOpacity(0.25)),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 6)],
        ),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, size: 20, color: color),
          ),
          const SizedBox(width: 10),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              if (!notif.isRead)
                Container(width: 7, height: 7, margin: const EdgeInsets.only(right: 5), decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
              Expanded(child: Text(notif.title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis)),
              const SizedBox(width: 6),
              _ChannelBadge(channel: notif.channel),
            ]),
            const SizedBox(height: 3),
            Text(notif.message, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary, height: 1.4), maxLines: 2, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 4),
            Row(children: [
              Text(notif.type.label, style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: color)),
              const Text(' · ', style: TextStyle(color: AppColors.textHint, fontSize: 9)),
              Text(_relTime, style: const TextStyle(fontSize: 9, color: AppColors.textHint)),
            ]),
          ])),
        ]),
      ),
    );
  }

  (Color, IconData) get _style => switch (notif.type) {
    StaffSystemNotifType.BOOKING_CONFIRMED   => (AppColors.success, Icons.event_available_rounded),
    StaffSystemNotifType.BOOKING_CANCELLED   => (AppColors.error, Icons.event_busy_rounded),
    StaffSystemNotifType.BOOKING_REMINDER    => (const Color(0xFF7C3AED), Icons.schedule_rounded),
    StaffSystemNotifType.PAYMENT_SUCCESS     => (AppColors.success, Icons.payment_rounded),
    StaffSystemNotifType.NEW_REVIEW          => (AppColors.warning, Icons.star_rounded),
    StaffSystemNotifType.MAINTENANCE_ALERT   => (AppColors.error, Icons.build_rounded),
    StaffSystemNotifType.SYSTEM_ANNOUNCEMENT => (AppColors.info, Icons.campaign_rounded),
    StaffSystemNotifType.SHIFT_REMINDER      => (const Color(0xFF7C3AED), Icons.work_history_rounded),
  };

  String get _relTime {
    final diff = DateTime.now().difference(notif.createdAt);
    if (diff.inMinutes < 1) return 'Vừa xong';
    if (diff.inMinutes < 60) return '${diff.inMinutes}p trước';
    if (diff.inHours < 24) return '${diff.inHours}h trước';
    return '${diff.inDays}d trước';
  }
}

class _ChannelBadge extends StatelessWidget {
  final StaffNotifChannel channel;
  const _ChannelBadge({required this.channel});

  @override
  Widget build(BuildContext context) {
    final (color, icon) = switch (channel) {
      StaffNotifChannel.PUSH  => (AppColors.info, Icons.notifications_rounded),
      StaffNotifChannel.EMAIL => (AppColors.warning, Icons.email_rounded),
      StaffNotifChannel.SMS   => (AppColors.success, Icons.sms_rounded),
      StaffNotifChannel.IN_APP=> (AppColors.textHint, Icons.app_shortcut_rounded),
    };
    return Icon(icon, size: 12, color: color);
  }
}
