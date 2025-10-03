import 'package:flutter/material.dart';

class OwnerBookingScreen extends StatefulWidget {
  const OwnerBookingScreen({Key? key}) : super(key: key);

  @override
  State<OwnerBookingScreen> createState() => _OwnerBookingScreenState();
}

class _OwnerBookingScreenState extends State<OwnerBookingScreen> {
  int _selectedTab = 0; // 0: Chờ xác nhận, 1: Đã xác nhận, 2: Hoàn thành, 3: Đã hủy

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản Lý Đặt Sân'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Tab Bar
          Container(
            color: Colors.white,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildTab('Chờ xác nhận', 0, 5),
                  _buildTab('Đã xác nhận', 1, 12),
                  _buildTab('Hoàn thành', 2, 45),
                  _buildTab('Đã hủy', 3, 3),
                ],
              ),
            ),
          ),
          const Divider(height: 1),

          // Content
          Expanded(
            child: _selectedTab == 0
                ? _buildPendingBookings()
                : _selectedTab == 1
                    ? _buildConfirmedBookings()
                    : _selectedTab == 2
                        ? _buildCompletedBookings()
                        : _buildCancelledBookings(),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String title, int index, int count) {
    bool isSelected = _selectedTab == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTab = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? const Color(0xFF2E7D32) : Colors.transparent,
              width: 3,
            ),
          ),
        ),
        child: Row(
          children: [
            Text(
              title,
              style: TextStyle(
                color: isSelected ? const Color(0xFF2E7D32) : Colors.grey,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 14,
              ),
            ),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF2E7D32)
                    : Colors.grey.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '$count',
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPendingBookings() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildBookingCard(
          'Sân 5 người A',
          'Nguyễn Văn A',
          '0987654321',
          'Hôm nay, 15:00 - 16:30',
          '350.000đ',
          'pending',
        ),
        _buildBookingCard(
          'Sân 7 người B',
          'Trần Thị B',
          '0123456789',
          'Hôm nay, 17:00 - 18:30',
          '500.000đ',
          'pending',
        ),
        _buildBookingCard(
          'Sân 11 người C',
          'Lê Văn C',
          '0369852147',
          'Ngày mai, 08:00 - 09:30',
          '800.000đ',
          'pending',
        ),
      ],
    );
  }

  Widget _buildConfirmedBookings() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildBookingCard(
          'Sân 5 người D',
          'Phạm Văn D',
          '0912345678',
          'Hôm nay, 18:00 - 19:30',
          '350.000đ',
          'confirmed',
        ),
        _buildBookingCard(
          'Sân 7 người E',
          'Hoàng Thị E',
          '0981234567',
          'Ngày mai, 14:00 - 15:30',
          '500.000đ',
          'confirmed',
        ),
      ],
    );
  }

  Widget _buildCompletedBookings() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildBookingCard(
          'Sân 5 người F',
          'Vũ Văn F',
          '0976543210',
          '02/10/2025, 16:00 - 17:30',
          '350.000đ',
          'completed',
        ),
      ],
    );
  }

  Widget _buildCancelledBookings() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildBookingCard(
          'Sân 7 người G',
          'Đỗ Thị G',
          '0945678912',
          '01/10/2025, 10:00 - 11:30',
          '500.000đ',
          'cancelled',
        ),
      ],
    );
  }

  Widget _buildBookingCard(
    String fieldName,
    String customerName,
    String phone,
    String timeInfo,
    String price,
    String status,
  ) {
    Color statusColor;
    String statusText;
    List<Widget> actions = [];

    switch (status) {
      case 'pending':
        statusColor = Colors.orange;
        statusText = 'Chờ xác nhận';
        actions = [
          Expanded(
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Từ chối'),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E7D32),
                foregroundColor: Colors.white,
              ),
              child: const Text('Xác nhận'),
            ),
          ),
        ];
        break;
      case 'confirmed':
        statusColor = Colors.green;
        statusText = 'Đã xác nhận';
        actions = [
          Expanded(
            child: OutlinedButton(
              onPressed: () {},
              child: const Text('Liên hệ'),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Hủy đặt'),
            ),
          ),
        ];
        break;
      case 'completed':
        statusColor = Colors.blue;
        statusText = 'Hoàn thành';
        actions = [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.receipt, size: 18),
              label: const Text('Xem hóa đơn'),
            ),
          ),
        ];
        break;
      case 'cancelled':
        statusColor = Colors.red;
        statusText = 'Đã hủy';
        actions = [];
        break;
      default:
        statusColor = Colors.grey;
        statusText = 'Không xác định';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2E7D32).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.sports_soccer,
                        color: Color(0xFF2E7D32),
                        size: 30,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                fieldName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: statusColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  statusText,
                                  style: TextStyle(
                                    color: statusColor,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(Icons.person, size: 16, color: Colors.grey[600]),
                              const SizedBox(width: 6),
                              Text(
                                customerName,
                                style: TextStyle(color: Colors.grey[700]),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.phone, size: 16, color: Colors.grey[600]),
                              const SizedBox(width: 6),
                              Text(
                                phone,
                                style: TextStyle(color: Colors.grey[700]),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                              const SizedBox(width: 6),
                              Text(
                                timeInfo,
                                style: TextStyle(color: Colors.grey[700]),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            price,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Color(0xFF2E7D32),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (actions.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  const Divider(),
                  const SizedBox(height: 8),
                  Row(children: actions),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}