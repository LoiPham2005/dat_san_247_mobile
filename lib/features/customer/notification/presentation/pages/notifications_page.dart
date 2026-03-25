import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/features/customer/notification/data/models/notification_model.dart';
import '../widgets/notification_tile.dart';
import '../widgets/notification_section_header.dart';

// ──────────────────────────────────────────────────────────────────────────
// C-19: Thông Báo
// ──────────────────────────────────────────────────────────────────────────
class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final List<NotificationModel> _notifications = [
    NotificationModel(
      id: 'n1', userId: 'u1', type: NotificationType.BOOKING_CONFIRMED,
      channel: NotificationChannel.IN_APP,
      title: 'Đặt sân thành công! 🎉',
      message: 'Booking DS24701234 tại Sân K34 Phạm Văn Đồng đã được xác nhận. Hẹn gặp bạn lúc 18:00 ngày mai!',
      referenceId: 'b1', referenceType: NotificationReferenceType.BOOKING,
      isRead: false, createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
    ),
    NotificationModel(
      id: 'n2', userId: 'u1', type: NotificationType.PAYMENT_SUCCESS,
      channel: NotificationChannel.IN_APP,
      title: 'Thanh toán thành công 💳',
      message: 'Bạn đã thanh toán 150.000đ cho booking DS24701234. Số dư ví còn 1.250.000đ.',
      referenceId: 'p1', referenceType: NotificationReferenceType.PAYMENT,
      isRead: false, createdAt: DateTime.now().subtract(const Duration(hours: 1)),
    ),
    NotificationModel(
      id: 'n3', userId: 'u1', type: NotificationType.WAITLIST_AVAILABLE,
      channel: NotificationChannel.IN_APP,
      title: 'Có slot trống! 🎉',
      message: 'Sân A - 5 người tại K34 Phạm Văn Đồng đã có chỗ trống vào 19:00 ngày 25/03. Đặt ngay trước khi hết!',
      referenceId: 'w1', referenceType: NotificationReferenceType.WAITLIST,
      isRead: false, createdAt: DateTime.now().subtract(const Duration(hours: 3)),
    ),
    NotificationModel(
      id: 'n4', userId: 'u1', type: NotificationType.BOOKING_REMINDER,
      channel: NotificationChannel.IN_APP,
      title: 'Nhắc nhở lịch đặt sân ⏰',
      message: 'Bạn có lịch đá banh vào lúc 18:00 hôm nay tại Sân K34. Đừng quên nhé!',
      referenceId: 'b2', referenceType: NotificationReferenceType.BOOKING,
      isRead: true, readAt: DateTime.now().subtract(const Duration(hours: 4)),
      createdAt: DateTime.now().subtract(const Duration(hours: 6)),
    ),
    NotificationModel(
      id: 'n5', userId: 'u1', type: NotificationType.PROMOTION,
      channel: NotificationChannel.IN_APP,
      title: 'Ưu đãi mới dành cho bạn 🎁',
      message: 'Dùng mã SUMMER20 giảm 20% (tối đa 100K) cho booking tiếp theo. Có hiệu lực đến 31/08/2026.',
      referenceId: 'p2', referenceType: NotificationReferenceType.PROMOTION,
      isRead: true, readAt: DateTime.now().subtract(const Duration(days: 1)),
      createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
    ),
    NotificationModel(
      id: 'n6', userId: 'u1', type: NotificationType.REVIEW_RESPONSE,
      channel: NotificationChannel.IN_APP,
      title: 'Chủ sân đã phản hồi đánh giá ⭐',
      message: 'Sân K34 đã trả lời đánh giá của bạn. Cảm ơn bạn đã chia sẻ!',
      referenceId: 'r1', referenceType: NotificationReferenceType.REVIEW,
      isRead: true, createdAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
    NotificationModel(
      id: 'n7', userId: 'u1', type: NotificationType.BOOKING_CANCELLED,
      channel: NotificationChannel.IN_APP,
      title: 'Đã hủy booking ❌',
      message: 'Booking DS24788002 đã được hủy thành công. Hoàn tiền 150.000đ vào ví trong 5–15 phút.',
      referenceId: 'b3', referenceType: NotificationReferenceType.BOOKING,
      isRead: true, createdAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
  ];

  int get _unreadCount => _notifications.where((n) => !n.isRead).length;

  void _markRead(NotificationModel n) {
    if (n.isRead) return;
    setState(() {
      final i = _notifications.indexOf(n);
      _notifications[i] = NotificationModel(
        id: n.id, userId: n.userId, type: n.type, channel: n.channel,
        title: n.title, message: n.message, referenceId: n.referenceId,
        referenceType: n.referenceType, isRead: true, readAt: DateTime.now(),
        createdAt: n.createdAt,
      );
    });
  }

  void _markAllRead() {
    setState(() {
      for (int i = 0; i < _notifications.length; i++) {
        final n = _notifications[i];
        if (!n.isRead) {
          _notifications[i] = NotificationModel(
            id: n.id, userId: n.userId, type: n.type, channel: n.channel,
            title: n.title, message: n.message, referenceId: n.referenceId,
            referenceType: n.referenceType, isRead: true, readAt: DateTime.now(),
            createdAt: n.createdAt,
          );
        }
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('✅ Đã đánh dấu tất cả là đã đọc'),
        backgroundColor: AppColors.primaryLightBrand,
        duration: Duration(seconds: 2)));
  }

  void _onTap(NotificationModel n) {
    _markRead(n);
    // Deep link theo reference type
    switch (n.referenceType) {
      case NotificationReferenceType.BOOKING:
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('→ Chi tiết booking ${n.referenceId?.substring(0, 6)}')));
        break;
      case NotificationReferenceType.PROMOTION:
        context.push('/promotions');
        break;
      case NotificationReferenceType.WAITLIST:
        context.push('/my-waitlist');
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final unread = _notifications.where((n) => !n.isRead).toList();
    final read = _notifications.where((n) => n.isRead).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: Row(children: [
          const Text('Thông báo',
              style: TextStyle(
                  fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
          if (_unreadCount > 0) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
              decoration:
                  BoxDecoration(color: AppColors.error, borderRadius: BorderRadius.circular(12)),
              child: Text('$_unreadCount',
                  style:
                      const TextStyle(color: AppColors.white, fontSize: 11, fontWeight: FontWeight.bold)),
            ),
          ],
        ]),
        actions: [
          if (_unreadCount > 0)
            TextButton(
              onPressed: _markAllRead,
              child: const Text('Đọc tất cả',
                  style: TextStyle(
                      color: AppColors.primaryLightBrand, fontSize: 13, fontWeight: FontWeight.w600)),
            ),
        ],
      ),
      body: _notifications.isEmpty ? _buildEmpty() : _buildList(unread, read),
    );
  }

  Widget _buildList(List<NotificationModel> unread, List<NotificationModel> read) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: [
        if (unread.isNotEmpty) ...[
          NotificationSectionHeader(label: 'Chưa đọc', count: unread.length),
          ...unread.map((n) => NotificationTile(notif: n, onTap: () => _onTap(n))),
          const SizedBox(height: 6),
        ],
        if (read.isNotEmpty) ...[
          const NotificationSectionHeader(label: 'Đã đọc'),
          ...read.map((n) => NotificationTile(notif: n, onTap: () => _onTap(n))),
        ],
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildEmpty() => const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.notifications_none_rounded, size: 64, color: AppColors.primaryLightBrand),
            SizedBox(height: 12),
            const Text('Không có thông báo nào',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            const Text('Chúng tôi sẽ thông báo khi có cập nhật mới!',
                style: TextStyle(color: AppColors.textHint, fontSize: 13)),
          ],
        ),
      );
}
