import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/features/customer/booking/data/models/my_booking_models.dart';
import 'package:dat_san_247_mobile/features/customer/main/presentation/pages/main_shell_page.dart';
import '../widgets/booking_list_item_card.dart';

// ──────────────────────────────────────────────────────────────────────────
// C-09: Danh Sách Booking
// ──────────────────────────────────────────────────────────────────────────
class MyBookingsPage extends StatefulWidget {
  const MyBookingsPage({super.key});

  @override
  State<MyBookingsPage> createState() => _MyBookingsPageState();
}

class _MyBookingsPageState extends State<MyBookingsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedTab = 0;

  // ------- MOCK DATA (thay thế bằng API call sau) -------
  final List<BookingListItemModel> _mockBookings = [
    BookingListItemModel(
      id: 'b1',
      bookingCode: 'DS24701234',
      checkInCode: 'CI1001',
      venueName: 'Sân K34 Phạm Văn Đồng',
      courtName: 'Sân A - 5 người',
      venueAddress: 'Số 10 Phạm Văn Đồng, Cầu Giấy, Hà Nội',
      venueThumbnailUrl: 'https://images.unsplash.com/photo-1574629810360-7efbbc09e99c?w=400&q=80',
      bookingDate: DateTime.now().add(const Duration(days: 2)),
      startTime: '18:00',
      endTime: '19:00',
      status: BookingStatus.CONFIRMED,
      paymentStatus: PaymentStatus.PAID,
      totalAmount: 150000,
      cancellationDeadline: DateTime.now().add(const Duration(days: 1, hours: 2)),
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    BookingListItemModel(
      id: 'b2',
      bookingCode: 'DS24705678',
      checkInCode: null,
      venueName: 'Sân Thể Thao Vạn Hạnh',
      courtName: 'Sân Cầu Lông B',
      venueAddress: '45 Điện Biên Phủ, Bình Thạnh, TP.HCM',
      venueThumbnailUrl: null,
      bookingDate: DateTime.now().add(const Duration(days: 5)),
      startTime: '07:00',
      endTime: '08:30',
      status: BookingStatus.PENDING,
      paymentStatus: PaymentStatus.PENDING,
      totalAmount: 90000,
      cancellationDeadline: DateTime.now().add(const Duration(days: 4)),
      createdAt: DateTime.now().subtract(const Duration(hours: 10)),
    ),
    BookingListItemModel(
      id: 'b3',
      bookingCode: 'DS24799001',
      checkInCode: 'CI9900',
      venueName: 'Sân K34 Phạm Văn Đồng',
      courtName: 'Sân A - 5 người',
      venueAddress: 'Số 10 Phạm Văn Đồng, Cầu Giấy, Hà Nội',
      venueThumbnailUrl: 'https://images.unsplash.com/photo-1553778263-73a83bab9b0c?w=400&q=80',
      bookingDate: DateTime.now().subtract(const Duration(days: 3)),
      startTime: '19:00',
      endTime: '21:00',
      status: BookingStatus.COMPLETED,
      paymentStatus: PaymentStatus.PAID,
      totalAmount: 300000,
      createdAt: DateTime.now().subtract(const Duration(days: 4)),
    ),
    BookingListItemModel(
      id: 'b4',
      bookingCode: 'DS24788002',
      checkInCode: null,
      venueName: 'Sân Thể Thao Vạn Hạnh',
      courtName: 'Sân Pickleball 1',
      venueAddress: '45 Điện Biên Phủ, Bình Thạnh, TP.HCM',
      venueThumbnailUrl: null,
      bookingDate: DateTime.now().subtract(const Duration(days: 7)),
      startTime: '06:00',
      endTime: '07:00',
      status: BookingStatus.CANCELLED,
      paymentStatus: PaymentStatus.REFUNDED,
      totalAmount: 120000,
      createdAt: DateTime.now().subtract(const Duration(days: 8)),
    ),
  ];

  List<BookingListItemModel> get _filteredBookings {
    switch (_selectedTab) {
      case 0: return _mockBookings; // Tất cả
      case 1: return _mockBookings.where((b) => b.isUpcoming).toList(); // Sắp tới
      case 2: return _mockBookings.where((b) => b.status == BookingStatus.COMPLETED).toList();
      case 3: return _mockBookings.where((b) => b.status == BookingStatus.CANCELLED || b.status == BookingStatus.NO_SHOW).toList();
      default: return _mockBookings;
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) setState(() => _selectedTab = _tabController.index);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: AppBar(
        automaticallyImplyLeading:
            context.canPop() && context.findAncestorWidgetOfExactType<MainShellPage>() == null,
        backgroundColor: AppColors.white,
        elevation: 0,
        title: const Text('Lịch đặt sân',
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: AppColors.textPrimary),
            onPressed: () {},
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(46),
          child: Container(
            color: AppColors.white,
            child: TabBar(
              controller: _tabController,
              labelColor: AppColors.primaryLightBrand,
              unselectedLabelColor: AppColors.textHint,
              labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
              unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
              indicatorColor: AppColors.primaryLightBrand,
              indicatorWeight: 2.5,
              tabs: const [
                Tab(text: 'Tất cả'),
                Tab(text: 'Sắp tới'),
                Tab(text: 'Đã chơi'),
                Tab(text: 'Đã hủy'),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: List.generate(4, (i) => _buildList()),
      ),
    );
  }

  Widget _buildList() {
    final list = _filteredBookings;
    if (list.isEmpty) return _buildEmpty();
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      itemCount: list.length,
      itemBuilder: (context, i) => BookingListItemCard(
        booking: list[i],
        onTap: () => _goToDetail(list[i]),
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
                color: AppColors.primaryLightBrand.withOpacity(0.08), shape: BoxShape.circle),
            child:
                const Icon(Icons.calendar_month_rounded, size: 44, color: AppColors.primaryLightBrand),
          ),
          const SizedBox(height: 16),
          const Text('Chưa có lịch đặt sân',
              style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
          const SizedBox(height: 6),
          const Text('Hãy đặt sân đầu tiên của bạn!',
              style: TextStyle(color: AppColors.textHint, fontSize: 13)),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () => context.go('/venues'),
            icon: const Icon(Icons.sports_soccer_rounded, color: AppColors.white),
            label: const Text('Tìm sân ngay',
                style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold)),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryLightBrand,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
      ),
    );
  }

  void _goToDetail(BookingListItemModel booking) {
    context.push('/booking-detail', extra: {
      'id': booking.id,
      'bookingCode': booking.bookingCode,
      'checkInCode': booking.checkInCode,
      'venueName': booking.venueName,
      'courtName': booking.courtName,
      'venueAddress': booking.venueAddress,
      'venueThumbnailUrl': booking.venueThumbnailUrl,
      'bookingDate': booking.bookingDate.toIso8601String(),
      'startTime': booking.startTime,
      'endTime': booking.endTime,
      'status': booking.status.name,
      'paymentStatus': booking.paymentStatus.name,
      'totalAmount': booking.totalAmount,
      'cancellationDeadline': booking.cancellationDeadline?.toIso8601String(),
      'createdAt': booking.createdAt.toIso8601String(),
    });
  }
}
