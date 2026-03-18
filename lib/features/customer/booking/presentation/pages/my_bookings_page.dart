import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/features/customer/booking/data/models/my_booking_models.dart';

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
        backgroundColor: AppColors.white,
        elevation: 0,
        title: const Text('Lịch đặt sân', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
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
      itemBuilder: (context, i) => _BookingCard(
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
            width: 88, height: 88,
            decoration: BoxDecoration(color: AppColors.primaryLightBrand.withOpacity(0.08), shape: BoxShape.circle),
            child: const Icon(Icons.calendar_month_rounded, size: 44, color: AppColors.primaryLightBrand),
          ),
          const SizedBox(height: 16),
          const Text('Chưa có lịch đặt sân', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
          const SizedBox(height: 6),
          const Text('Hãy đặt sân đầu tiên của bạn!', style: TextStyle(color: AppColors.textHint, fontSize: 13)),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () => context.go('/venues'),
            icon: const Icon(Icons.sports_soccer_rounded, color: AppColors.white),
            label: const Text('Tìm sân ngay', style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold)),
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

// ──────────────────────────────────────────────────────────────────────────
// BookingCard Widget
// ──────────────────────────────────────────────────────────────────────────
class _BookingCard extends StatelessWidget {
  final BookingListItemModel booking;
  final VoidCallback onTap;
  const _BookingCard({required this.booking, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final fmt = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');
    final dateStr = DateFormat('dd/MM/yyyy').format(booking.bookingDate);
    final (color, bg, icon) = _statusStyle(booking.status);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: AppColors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 3))],
        ),
        child: Column(
          children: [
            // ── Header ──
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
              child: Row(
                children: [
                  // Thumbnail
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: booking.venueThumbnailUrl != null
                        ? Image.network(booking.venueThumbnailUrl!, width: 56, height: 56, fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => _missingThumb())
                        : _missingThumb(),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(booking.venueName, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary), maxLines: 1, overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 2),
                        Text(booking.courtName, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                      ],
                    ),
                  ),
                  // Status badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(icon, size: 10, color: color),
                        const SizedBox(width: 3),
                        Text(booking.status.label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: color)),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const Divider(height: 1, color: AppColors.borderLight),

            // ── Info Row ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Row(
                children: [
                  _InfoChip(icon: Icons.calendar_today_rounded, label: dateStr),
                  const SizedBox(width: 10),
                  _InfoChip(icon: Icons.access_time_rounded, label: '${booking.startTime}–${booking.endTime}'),
                  const Spacer(),
                  Text(fmt.format(booking.totalAmount), style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.primaryLightBrand)),
                ],
              ),
            ),

            // ── Action strip (QR code for CONFIRMED) ──
            if (booking.status == BookingStatus.CONFIRMED && booking.checkInCode != null)
              GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  Clipboard.setData(ClipboardData(text: booking.checkInCode!));
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('✅ Đã sao chép mã check-in'), duration: Duration(seconds: 1)));
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 9),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLightBrand.withOpacity(0.08),
                    borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(16), bottomRight: Radius.circular(16)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.qr_code_2_rounded, size: 16, color: AppColors.primaryLightBrand),
                      const SizedBox(width: 6),
                      Text('Mã check-in: ${booking.checkInCode}',
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primaryLightBrand)),
                      const SizedBox(width: 4),
                      const Icon(Icons.copy_rounded, size: 12, color: AppColors.primaryLightBrand),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _missingThumb() => Container(
    width: 56, height: 56,
    decoration: BoxDecoration(color: AppColors.mutedLight, borderRadius: BorderRadius.circular(10)),
    child: const Icon(Icons.sports_soccer_rounded, color: AppColors.primaryLightBrand, size: 28),
  );

  (Color, Color, IconData) _statusStyle(BookingStatus s) {
    switch (s) {
      case BookingStatus.PENDING: return (AppColors.warning, AppColors.warning.withOpacity(0.12), Icons.schedule_rounded);
      case BookingStatus.CONFIRMED: return (AppColors.primaryLightBrand, AppColors.primaryLightBrand.withOpacity(0.1), Icons.check_circle_rounded);
      case BookingStatus.CHECKED_IN: return (AppColors.info, AppColors.info.withOpacity(0.1), Icons.play_circle_rounded);
      case BookingStatus.COMPLETED: return (AppColors.success, AppColors.success.withOpacity(0.1), Icons.task_alt_rounded);
      case BookingStatus.CANCELLED: return (AppColors.error, AppColors.error.withOpacity(0.1), Icons.cancel_rounded);
      case BookingStatus.NO_SHOW: return (AppColors.greyDark, AppColors.greyDark.withOpacity(0.1), Icons.person_off_rounded);
    }
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: AppColors.textHint),
        const SizedBox(width: 3),
        Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
      ],
    );
  }
}
