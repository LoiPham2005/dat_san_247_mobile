import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/features/venue_staff/dashboard/data/models/staff_dashboard_models.dart';

// ══════════════════════════════════════════════════════════════════════════════
// Staff Notifications Page
// DB: notifications (user_id=me), type filter for staff-relevant types
// ══════════════════════════════════════════════════════════════════════════════
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
      StaffNotificationModel(id: 'n1', title: 'Booking mới vừa đặt', body: 'Nguyễn Văn An đặt Sân A, 18:00–19:30 hôm nay', type: StaffNotifType.newBooking, referenceId: 'b3', isRead: false, createdAt: now.subtract(const Duration(minutes: 5))),
      StaffNotificationModel(id: 'n2', title: 'Khách chưa check-in', body: 'Booking DS24799104 – Lê Hoàng Dũng, Sân A 20:00. Quá giờ 15 phút.', type: StaffNotifType.checkInAlert, referenceId: 'b4', isRead: false, createdAt: now.subtract(const Duration(minutes: 22))),
      StaffNotificationModel(id: 'n3', title: 'Booking bị huỷ', body: 'Trần Thị Bình đã huỷ booking DS24799102 tại Sân A', type: StaffNotifType.bookingCancelled, referenceId: 'b2', isRead: false, createdAt: now.subtract(const Duration(hours: 1))),
      StaffNotificationModel(id: 'n4', title: '🔧 Bảo trì khẩn cấp', body: 'Sân CL cần bảo trì khẩn: hệ thống đèn hỏng. Liên hệ quản lý.', type: StaffNotifType.maintenanceAlert, isRead: true, createdAt: now.subtract(const Duration(hours: 3))),
      StaffNotificationModel(id: 'n5', title: 'Booking mới – Sân B', body: 'Vũ Văn Phúc đặt Sân B, 17:00–18:00 hôm nay', type: StaffNotifType.newBooking, isRead: true, createdAt: now.subtract(const Duration(hours: 5))),
      StaffNotificationModel(id: 'n6', title: 'Cập nhật hệ thống', body: 'Phiên bản 2.4.1 đã phát hành. Các lỗi nhỏ đã được sửa.', type: StaffNotifType.systemAlert, isRead: true, createdAt: now.subtract(const Duration(days: 1))),
      StaffNotificationModel(id: 'n7', title: 'Khách đánh giá mới', body: 'Nguyễn Thị C để lại đánh giá 5⭐ cho Sân A', type: StaffNotifType.reviewReply, isRead: true, createdAt: now.subtract(const Duration(days: 2))),
    ];
  }

  List<StaffNotificationModel> get _filtered =>
      _filter == null ? _notifs : _notifs.where((n) => n.type == _filter).toList();

  int get _unreadCount => _notifs.where((n) => !n.isRead).length;

  void _markAllRead() {
    HapticFeedback.selectionClick();
    setState(() {
      for (int i = 0; i < _notifs.length; i++) { /* mark read via API */ }
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
            title: Row(children: [
              const Text('Thông Báo', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
                TextButton(
                  onPressed: _markAllRead,
                  child: const Text('Đọc hết', style: TextStyle(color: Colors.white70, fontSize: 12)),
                ),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(46),
              child: Container(
                color: _brand,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
                  child: Row(children: [
                    _FilterChip(label: 'Tất cả', selected: _filter == null, onTap: () => setState(() => _filter = null), brand: _brand),
                    ..._typeFilters.map((t) => _FilterChip(
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
                  child: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
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
                      final showDate = i == 0 || !_sameDay(_filtered[i - 1].createdAt, notif.createdAt);
                      return Column(children: [
                        if (showDate) _DateSeparator(date: notif.createdAt),
                        _NotifCard(
                          notif: notif,
                          onTap: () => setState(() { /* mark read */ }),
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

  bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  static const _typeFilters = [
    StaffNotifType.newBooking,
    StaffNotifType.checkInAlert,
    StaffNotifType.bookingCancelled,
    StaffNotifType.maintenanceAlert,
    StaffNotifType.systemAlert,
  ];
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Color brand;
  final int count;
  const _FilterChip({required this.label, required this.selected, required this.onTap, required this.brand, this.count = 0});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: () { HapticFeedback.selectionClick(); onTap(); },
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: const EdgeInsets.only(right: 6),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: selected ? Colors.white : Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: selected ? brand : Colors.white70)),
        if (count > 0) ...[
          const SizedBox(width: 4),
          Container(width: 16, height: 16, decoration: BoxDecoration(color: AppColors.error, shape: BoxShape.circle),
            child: Center(child: Text('$count', style: const TextStyle(fontSize: 9, color: Colors.white, fontWeight: FontWeight.bold)))),
        ],
      ]),
    ),
  );
}

class _DateSeparator extends StatelessWidget {
  final DateTime date;
  const _DateSeparator({required this.date});

  String _label() {
    final now = DateTime.now();
    final d = DateTime(date.year, date.month, date.day);
    final today = DateTime(now.year, now.month, now.day);
    if (d == today) return 'Hôm nay';
    if (d == today.subtract(const Duration(days: 1))) return 'Hôm qua';
    return DateFormat('dd/MM/yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(14, 14, 14, 6),
    child: Row(children: [
      Expanded(child: Divider(color: AppColors.borderLight, height: 1)),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Text(_label(), style: const TextStyle(fontSize: 11, color: AppColors.textHint, fontWeight: FontWeight.bold)),
      ),
      Expanded(child: Divider(color: AppColors.borderLight, height: 1)),
    ]),
  );
}

class _NotifCard extends StatelessWidget {
  final StaffNotificationModel notif;
  final VoidCallback onTap;
  const _NotifCard({required this.notif, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final (color, icon) = _typeStyle;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: notif.isRead ? Colors.white : color.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: notif.isRead ? AppColors.borderLight : color.withOpacity(0.3)),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 6)],
        ),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            width: 38, height: 38,
            decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, size: 20, color: color),
          ),
          const SizedBox(width: 10),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              if (!notif.isRead)
                Container(width: 6, height: 6, margin: const EdgeInsets.only(right: 6), decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
              Expanded(child: Text(notif.title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis)),
            ]),
            const SizedBox(height: 3),
            Text(notif.body, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary, height: 1.4), maxLines: 2, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 4),
            Text(_relativeTime, style: const TextStyle(fontSize: 10, color: AppColors.textHint)),
          ])),
        ]),
      ),
    );
  }

  (Color, IconData) get _typeStyle => switch (notif.type) {
    StaffNotifType.newBooking        => (AppColors.success, Icons.event_available_rounded),
    StaffNotifType.bookingCancelled  => (AppColors.error, Icons.event_busy_rounded),
    StaffNotifType.checkInAlert      => (const Color(0xFF7C3AED), Icons.qr_code_scanner_rounded),
    StaffNotifType.maintenanceAlert  => (AppColors.warning, Icons.build_rounded),
    StaffNotifType.systemAlert       => (AppColors.info, Icons.info_outline_rounded),
    StaffNotifType.reviewReply       => (AppColors.warning, Icons.star_rounded),
  };

  String get _relativeTime {
    final diff = DateTime.now().difference(notif.createdAt);
    if (diff.inMinutes < 1) return 'Vừa xong';
    if (diff.inMinutes < 60) return '${diff.inMinutes} phút trước';
    if (diff.inHours < 24) return '${diff.inHours} giờ trước';
    return '${diff.inDays} ngày trước';
  }
}
