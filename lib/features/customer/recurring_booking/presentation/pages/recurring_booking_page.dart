import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/features/customer/recurring_booking/data/models/recurring_booking_model.dart';
import '../widgets/recurring_booking_card.dart';

// ──────────────────────────────────────────────────────────────────────────
// C-13: Lịch Định Kỳ
// ──────────────────────────────────────────────────────────────────────────
class RecurringBookingPage extends StatefulWidget {
  const RecurringBookingPage({super.key});

  @override
  State<RecurringBookingPage> createState() => _RecurringBookingPageState();
}

class _RecurringBookingPageState extends State<RecurringBookingPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedTab = 0; // 0=Đang hoạt động, 1=Đã dừng

  final List<RecurringBookingModel> _mockData = [
    RecurringBookingModel(
      id: 'r1',
      venueId: 'v1',
      venueName: 'Sân K34 Phạm Văn Đồng',
      courtId: 'c1',
      courtName: 'Sân A - 5 người',
      repeatType: RecurringType.WEEKLY,
      startTime: '18:00',
      endTime: '19:00',
      startDate: DateTime(2026, 1, 6),
      endDate: DateTime(2026, 6, 30),
      isActive: true,
      createdAt: DateTime(2026, 1, 1),
      repeatDays: [DayOfWeek.MONDAY, DayOfWeek.WEDNESDAY, DayOfWeek.FRIDAY],
      totalBookingsGenerated: 24,
    ),
    RecurringBookingModel(
      id: 'r2',
      venueId: 'v2',
      venueName: 'Sân Thể Thao Vạn Hạnh',
      courtId: 'c2',
      courtName: 'Sân Cầu Lông B',
      repeatType: RecurringType.WEEKLY,
      startTime: '06:00',
      endTime: '07:30',
      startDate: DateTime(2026, 2, 1),
      isActive: true,
      createdAt: DateTime(2026, 1, 28),
      repeatDays: [DayOfWeek.SATURDAY, DayOfWeek.SUNDAY],
      totalBookingsGenerated: 8,
    ),
    RecurringBookingModel(
      id: 'r3',
      venueId: 'v1',
      venueName: 'Sân K34 Phạm Văn Đồng',
      courtId: 'c3',
      courtName: 'Sân C - Trong nhà',
      repeatType: RecurringType.DAILY,
      startTime: '07:00',
      endTime: '08:00',
      startDate: DateTime(2025, 10, 1),
      endDate: DateTime(2025, 12, 31),
      isActive: false,
      createdAt: DateTime(2025, 9, 25),
      repeatDays: [],
      totalBookingsGenerated: 61,
    ),
  ];

  List<RecurringBookingModel> get _filteredList =>
      _mockData.where((r) => _selectedTab == 0 ? r.isActive : !r.isActive).toList();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: const Text('Lịch đặt định kỳ',
            style: TextStyle(
                fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(44),
          child: TabBar(
            controller: _tabController,
            labelColor: AppColors.primaryLightBrand,
            unselectedLabelColor: AppColors.textHint,
            indicatorColor: AppColors.primaryLightBrand,
            labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
            tabs: const [Tab(text: 'Đang hoạt động'), Tab(text: 'Đã dừng')],
          ),
        ),
      ),
      body: _filteredList.isEmpty ? _buildEmpty() : _buildList(),
    );
  }

  Widget _buildList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _filteredList.length,
      itemBuilder: (ctx, i) => RecurringBookingCard(
        item: _filteredList[i],
        onToggle: (item) => _toggleActive(item),
      ),
    );
  }

  void _toggleActive(RecurringBookingModel item) async {
    final action = item.isActive ? 'tạm dừng' : 'kích hoạt lại';
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('${item.isActive ? 'Tạm dừng' : 'Kích hoạt'} lịch định kỳ?'),
        content: Text('Bạn muốn $action lịch đặt "${item.courtName}" tại "${item.venueName}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Huỷ')),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: item.isActive ? AppColors.error : AppColors.primaryLightBrand,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text(item.isActive ? 'Tạm dừng' : 'Kích hoạt',
                style: const TextStyle(color: AppColors.white)),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      setState(() {
        final idx = _mockData.indexOf(item);
        _mockData[idx] = RecurringBookingModel(
          id: item.id,
          venueId: item.venueId,
          venueName: item.venueName,
          courtId: item.courtId,
          courtName: item.courtName,
          repeatType: item.repeatType,
          startTime: item.startTime,
          endTime: item.endTime,
          startDate: item.startDate,
          endDate: item.endDate,
          isActive: !item.isActive,
          createdAt: item.createdAt,
          repeatDays: item.repeatDays,
          totalBookingsGenerated: item.totalBookingsGenerated,
        );
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(item.isActive
              ? '⏸️ Đã tạm dừng lịch định kỳ'
              : '▶️ Đã kích hoạt lại lịch định kỳ'),
          backgroundColor: AppColors.primaryLightBrand,
        ));
      }
    }
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
            child: const Icon(Icons.repeat_rounded, size: 44, color: AppColors.primaryLightBrand),
          ),
          const SizedBox(height: 16),
          const Text('Chưa có lịch định kỳ',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          const Text('Lịch định kỳ được tạo khi bạn đặt sân hằng tuần',
              style: TextStyle(color: AppColors.textHint, fontSize: 13)),
        ],
      ),
    );
  }
}
