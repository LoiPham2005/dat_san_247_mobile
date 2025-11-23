import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  String _selectedTab = 'all';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thông Báo'),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              if (value == 'mark_all_read') {
                // Mark all as read
              } else if (value == 'clear_all') {
                // Clear all notifications
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'mark_all_read',
                child: Row(
                  children: [
                    Icon(Icons.done_all, color: Color(0xFF2E7D32)),
                    SizedBox(width: 12),
                    Text('Đánh dấu đã đọc tất cả'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'clear_all',
                child: Row(
                  children: [
                    Icon(Icons.delete_outline, color: Colors.red),
                    SizedBox(width: 12),
                    Text('Xóa tất cả'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Tab Bar
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                _buildTab('Tất cả', 'all', 12),
                _buildTab('Đặt sân', 'booking', 5),
                _buildTab('Khuyến mãi', 'promotion', 3),
                _buildTab('Hệ thống', 'system', 4),
              ],
            ),
          ),
          const Divider(height: 1),

          // Notifications List
          Expanded(
            child: _selectedTab == 'all'
                ? _buildAllNotifications()
                : _selectedTab == 'booking'
                    ? _buildBookingNotifications()
                    : _selectedTab == 'promotion'
                        ? _buildPromotionNotifications()
                        : _buildSystemNotifications(),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String title, String value, int count) {
    bool isSelected = _selectedTab == value;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedTab = value;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected ? const Color(0xFF2E7D32) : Colors.transparent,
                width: 3,
              ),
            ),
          ),
          child: Column(
            children: [
              Text(
                title,
                style: TextStyle(
                  color: isSelected ? const Color(0xFF2E7D32) : Colors.grey,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  fontSize: 14,
                ),
              ),
              if (count > 0) ...[
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFF2E7D32)
                        : Colors.grey.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '$count',
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.grey,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAllNotifications() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildNotificationCard(
          'booking',
          'Đặt sân thành công',
          'Bạn đã đặt Sân 5 người A vào lúc 15:00 ngày 04/10/2025',
          '5 phút trước',
          true,
          Icons.event_available,
          const Color(0xFF2E7D32),
        ),
        _buildNotificationCard(
          'promotion',
          'Khuyến mãi đặc biệt! 🎉',
          'Giảm 20% cho tất cả sân vào cuối tuần. Nhanh tay đặt sân!',
          '1 giờ trước',
          true,
          Icons.local_offer,
          Colors.orange,
        ),
        _buildNotificationCard(
          'booking',
          'Nhắc nhở đặt sân',
          'Bạn có lịch đặt sân vào 16:00 hôm nay tại Sân 7 người B',
          '2 giờ trước',
          false,
          Icons.notifications_active,
          Colors.blue,
        ),
        _buildNotificationCard(
          'system',
          'Cập nhật hệ thống',
          'Ứng dụng đã có phiên bản mới với nhiều tính năng hấp dẫn',
          '1 ngày trước',
          false,
          Icons.system_update,
          Colors.purple,
        ),
        _buildNotificationCard(
          'booking',
          'Đánh giá sân',
          'Hãy đánh giá trải nghiệm của bạn tại Sân Bóng Thể Thao 247',
          '2 ngày trước',
          false,
          Icons.star_rate,
          Colors.amber,
        ),
        _buildNotificationCard(
          'promotion',
          'Ưu đãi thành viên VIP',
          'Nâng cấp lên VIP để nhận ưu đãi 30% mọi lúc mọi nơi',
          '3 ngày trước',
          false,
          Icons.card_giftcard,
          Colors.red,
        ),
      ],
    );
  }

  Widget _buildBookingNotifications() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildNotificationCard(
          'booking',
          'Đặt sân thành công',
          'Bạn đã đặt Sân 5 người A vào lúc 15:00 ngày 04/10/2025',
          '5 phút trước',
          true,
          Icons.event_available,
          const Color(0xFF2E7D32),
        ),
        _buildNotificationCard(
          'booking',
          'Nhắc nhở đặt sân',
          'Bạn có lịch đặt sân vào 16:00 hôm nay tại Sân 7 người B',
          '2 giờ trước',
          false,
          Icons.notifications_active,
          Colors.blue,
        ),
        _buildNotificationCard(
          'booking',
          'Đánh giá sân',
          'Hãy đánh giá trải nghiệm của bạn tại Sân Bóng Thể Thao 247',
          '2 ngày trước',
          false,
          Icons.star_rate,
          Colors.amber,
        ),
      ],
    );
  }

  Widget _buildPromotionNotifications() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildNotificationCard(
          'promotion',
          'Khuyến mãi đặc biệt! 🎉',
          'Giảm 20% cho tất cả sân vào cuối tuần. Nhanh tay đặt sân!',
          '1 giờ trước',
          true,
          Icons.local_offer,
          Colors.orange,
        ),
        _buildNotificationCard(
          'promotion',
          'Ưu đãi thành viên VIP',
          'Nâng cấp lên VIP để nhận ưu đãi 30% mọi lúc mọi nơi',
          '3 ngày trước',
          false,
          Icons.card_giftcard,
          Colors.red,
        ),
      ],
    );
  }

  Widget _buildSystemNotifications() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildNotificationCard(
          'system',
          'Cập nhật hệ thống',
          'Ứng dụng đã có phiên bản mới với nhiều tính năng hấp dẫn',
          '1 ngày trước',
          false,
          Icons.system_update,
          Colors.purple,
        ),
      ],
    );
  }

  Widget _buildNotificationCard(
    String type,
    String title,
    String message,
    String time,
    bool isUnread,
    IconData icon,
    Color iconColor,
  ) {
    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: isUnread ? const Color(0xFF2E7D32).withOpacity(0.05) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isUnread
                ? const Color(0xFF2E7D32).withOpacity(0.3)
                : Colors.grey[200]!,
            width: isUnread ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.08),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: InkWell(
          onTap: () {
            // Handle notification tap
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: iconColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              style: TextStyle(
                                fontWeight: isUnread ? FontWeight.bold : FontWeight.w600,
                                fontSize: 15,
                                color: isUnread ? const Color(0xFF2E7D32) : Colors.black87,
                              ),
                            ),
                          ),
                          if (isUnread)
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: Color(0xFF2E7D32),
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        message,
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 14,
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 14,
                            color: Colors.grey[500],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            time,
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}