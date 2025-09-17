import 'package:flutter/material.dart';

class MyBookingPage extends StatefulWidget {
  const MyBookingPage({super.key});

  @override
  State<MyBookingPage> createState() => _MyBookingPageState();
}

class _MyBookingPageState extends State<MyBookingPage> {
  final TextEditingController searchController = TextEditingController();
  String selectedStatus = 'Tất cả';

  final bookings = [
    {
      "venue": "Sân bóng ĐH Bách Khoa",
      "address": "268 Lý Thường Kiệt, Q.10",
      "date": "12/06/2024",
      "time": "18:00 - 20:00",
      "status": "Đã xác nhận",
    },
    {
      "venue": "Sân Tennis Quận 7",
      "address": "Số 5 Nguyễn Văn Linh",
      "date": "15/06/2024",
      "time": "07:00 - 09:00",
      "status": "Chờ xác nhận",
    },
  ];

  @override
  Widget build(BuildContext context) {
    // Lọc theo trạng thái và từ khóa
    final filteredBookings = bookings.where((booking) {
      final matchesStatus =
          selectedStatus == 'Tất cả' || booking["status"] == selectedStatus;
      final matchesSearch =
          searchController.text.isEmpty ||
          (booking["venue"] as String).toLowerCase().contains(
            searchController.text.toLowerCase(),
          );
      return matchesStatus && matchesSearch;
    }).toList();

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xff62b766).withOpacity(0.1),
              Colors.white,
              Color(0xff4fa553).withOpacity(0.05),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xff62b766), Color(0xff4fa553)],
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.sports_soccer,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      "Đặt Sân Của Tôi",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff2d5533),
                      ),
                    ),
                    Spacer(),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff62b766),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                      icon: Icon(Icons.history, size: 18),
                      label: Text("Xem lịch sử"),
                      onPressed: () {
                        // TODO: Chuyển sang màn lịch sử đặt sân
                      },
                    ),
                  ],
                ),
                SizedBox(height: 20),

                // Search & Filter
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 6,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: searchController,
                          onChanged: (_) => setState(() {}),
                          decoration: InputDecoration(
                            hintText: 'Tìm kiếm sân...',
                            border: InputBorder.none,
                            prefixIcon: Icon(Icons.search),
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 14,
                              horizontal: 16,
                            ),
                            suffixIcon: searchController.text.isEmpty
                                ? null
                                : IconButton(
                                    icon: Icon(Icons.clear),
                                    onPressed: () {
                                      searchController.clear();
                                      setState(() {});
                                    },
                                  ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    DropdownButton<String>(
                      value: selectedStatus,
                      items: ['Tất cả', 'Đã xác nhận', 'Chờ xác nhận']
                          .map(
                            (status) => DropdownMenuItem(
                              value: status,
                              child: Text(status),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            selectedStatus = value;
                          });
                        }
                      },
                      underline: SizedBox(),
                      style: TextStyle(
                        color: Color(0xff2d5533),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),

                // List bookings
                Expanded(
                  child: filteredBookings.isEmpty
                      ? Center(child: Text("Không có kết quả phù hợp"))
                      : ListView.builder(
                          itemCount: filteredBookings.length,
                          itemBuilder: (context, index) {
                            final booking = filteredBookings[index];
                            return Card(
                              margin: EdgeInsets.only(bottom: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 3,
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.location_on,
                                          color: Color(0xff62b766),
                                        ),
                                        SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            booking["venue"] ?? "",
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xff2d5533),
                                            ),
                                          ),
                                        ),
                                        Chip(
                                          label: Text(
                                            booking["status"] ?? "",
                                            style: TextStyle(
                                              color:
                                                  booking["status"] ==
                                                      "Đã xác nhận"
                                                  ? Colors.green
                                                  : Colors.orange,
                                            ),
                                          ),
                                          backgroundColor: Colors.grey[100],
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      booking["address"] ?? "",
                                      style: TextStyle(color: Colors.grey[600]),
                                    ),
                                    SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.calendar_today,
                                          size: 16,
                                          color: Colors.grey,
                                        ),
                                        SizedBox(width: 4),
                                        Text(booking["date"] ?? ""),
                                        SizedBox(width: 16),
                                        Icon(
                                          Icons.access_time,
                                          size: 16,
                                          color: Colors.grey,
                                        ),
                                        SizedBox(width: 4),
                                        Text(booking["time"] ?? ""),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
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
