import 'package:flutter/material.dart';

class OwnerProfileScreen extends StatelessWidget {
  const OwnerProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cá Nhân'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFF2E7D32),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: Column(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 4),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.person,
                      size: 60,
                      color: Color(0xFF2E7D32),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Nguyễn Văn A',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Chủ sân',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.verified,
                          color: Colors.white,
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Đã xác thực',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Quick Stats
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: _buildQuickStat('Tổng sân', '4', Icons.sports_soccer),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildQuickStat('Đánh giá', '4.8 ⭐', Icons.star),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildQuickStat('Năm KN', '3 năm', Icons.calendar_today),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Menu Options
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  _buildMenuSection(
                    'Thông tin tài khoản',
                    [
                      _buildMenuItem(
                        Icons.person_outline,
                        'Thông tin cá nhân',
                        'Cập nhật thông tin của bạn',
                        () {},
                      ),
                      _buildMenuItem(
                        Icons.business_outlined,
                        'Thông tin sân',
                        'Quản lý thông tin sân của bạn',
                        () {},
                      ),
                      _buildMenuItem(
                        Icons.location_on_outlined,
                        'Địa chỉ',
                        'Cập nhật địa chỉ sân',
                        () {},
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  _buildMenuSection(
                    'Tài chính',
                    [
                      _buildMenuItem(
                        Icons.account_balance_wallet_outlined,
                        'Ví của tôi',
                        'Số dư: 2.500.000đ',
                        () {},
                      ),
                      _buildMenuItem(
                        Icons.payment_outlined,
                        'Phương thức thanh toán',
                        'Quản lý thanh toán',
                        () {},
                      ),
                      _buildMenuItem(
                        Icons.history_outlined,
                        'Lịch sử giao dịch',
                        'Xem lịch sử giao dịch',
                        () {},
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  _buildMenuSection(
                    'Hỗ trợ',
                    [
                      _buildMenuItem(
                        Icons.help_outline,
                        'Trung tâm trợ giúp',
                        'Câu hỏi thường gặp',
                        () {},
                      ),
                      _buildMenuItem(
                        Icons.phone_outlined,
                        'Liên hệ hỗ trợ',
                        'Hotline: 1900 xxxx',
                        () {},
                      ),
                      _buildMenuItem(
                        Icons.description_outlined,
                        'Điều khoản & Chính sách',
                        'Đọc điều khoản sử dụng',
                        () {},
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  _buildMenuSection(
                    'Cài đặt',
                    [
                      _buildMenuItem(
                        Icons.notifications_outlined,
                        'Thông báo',
                        'Quản lý thông báo',
                        () {},
                      ),
                      _buildMenuItem(
                        Icons.language_outlined,
                        'Ngôn ngữ',
                        'Tiếng Việt',
                        () {},
                      ),
                      _buildMenuItem(
                        Icons.security_outlined,
                        'Bảo mật',
                        'Mật khẩu & xác thực',
                        () {},
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Logout Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.logout),
                      label: const Text('Đăng xuất'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Version
                  Text(
                    'Phiên bản 1.0.0',
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 12,
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStat(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: const Color(0xFF2E7D32),
            size: 28,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuSection(String title, List<Widget> items) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E7D32),
              ),
            ),
          ),
          const Divider(height: 1),
          ...items,
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFF2E7D32).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: const Color(0xFF2E7D32),
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }
}