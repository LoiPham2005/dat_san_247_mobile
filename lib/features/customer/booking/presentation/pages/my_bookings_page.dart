import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:dat_san_247_mobile/features/customer/booking/presentation/cubit/my_bookings_cubit.dart';
import 'package:dat_san_247_mobile/features/customer/booking/data/models/booking_request.dart';
import 'package:dat_san_247_mobile/features/customer/booking/data/models/my_booking_models.dart';
import 'package:dat_san_247_mobile/core/base/state/bloc/base_state.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/features/customer/main/presentation/pages/main_shell_page.dart';
import '../widgets/booking_list_item_card.dart';

// ──────────────────────────────────────────────────────────────────────────
// C-09: Danh Sách Booking
// ──────────────────────────────────────────────────────────────────────────
class MyBookingsPage extends StatelessWidget {
  const MyBookingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.I<MyBookingsCubit>()..getMyBookings(),
      child: const MyBookingsView(),
    );
  }
}

class MyBookingsView extends StatefulWidget {
  const MyBookingsView({super.key});

  @override
  State<MyBookingsView> createState() => _MyBookingsViewState();
}

class _MyBookingsViewState extends State<MyBookingsView>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  late TabController _tabController;
  int _selectedTab = 0;

  List<BookingListItemModel> _mapBookings(List<BookingResponse> responses) {
    return responses.map((res) {
      return BookingListItemModel(
        id: res.id,
        bookingCode: res.bookingCode,
        checkInCode: res.checkInCode,
        venueName: res.venueName,
        courtName: res.courtName,
        venueAddress: res.venueAddress,
        venueThumbnailUrl:
            null, // Backend doesn't return thumb yet in this list
        bookingDate: DateTime.tryParse(res.bookingDate) ?? DateTime.now(),
        startTime: res.startTime,
        endTime: res.endTime,
        status:
            BookingStatus.values.firstWhere((e) => e.name == res.status.name),
        paymentStatus: PaymentStatus.values
            .firstWhere((e) => e.name == res.paymentStatus.name),
        totalAmount: res.totalAmount,
        createdAt: DateTime.tryParse(res.createdAt) ?? DateTime.now(),
      );
    }).toList();
  }

  List<BookingListItemModel> _filterList(List<BookingListItemModel> list) {
    switch (_selectedTab) {
      case 0:
        return list; // Tất cả
      case 1:
        return list.where((b) => b.isUpcoming).toList(); // Sắp tới
      case 2:
        return list.where((b) => b.status == BookingStatus.COMPLETED).toList();
      case 3:
        return list
            .where((b) =>
                b.status == BookingStatus.CANCELLED ||
                b.status == BookingStatus.NO_SHOW)
            .toList();
      default:
        return list;
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging)
        setState(() => _selectedTab = _tabController.index);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: AppBar(
        automaticallyImplyLeading: context.canPop() &&
            context.findAncestorWidgetOfExactType<MainShellPage>() == null,
        backgroundColor: AppColors.white,
        elevation: 0,
        title: const Text('Lịch đặt sân',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary)),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined,
                color: AppColors.textPrimary),
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
              labelStyle:
                  const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
              unselectedLabelStyle:
                  const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
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
      body: BlocBuilder<MyBookingsCubit, BaseState<List<BookingResponse>>>(
        builder: (context, state) {
          return state.when(
            initial: () => const Center(child: CircularProgressIndicator()),
            loading: (data) => const Center(child: CircularProgressIndicator()),
            failure: (error, data) => Center(child: Text('Lỗi: $error')),
            success: (data, message) {
              final mapped = _mapBookings(data);
              return TabBarView(
                controller: _tabController,
                children:
                    List.generate(4, (i) => _buildList(_filterList(mapped))),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildList(List<BookingListItemModel> list) {
    if (list.isEmpty) return _buildEmpty();
    return RefreshIndicator(
      onRefresh: () => context.read<MyBookingsCubit>().getMyBookings(),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        itemCount: list.length,
        itemBuilder: (context, i) => BookingListItemCard(
          booking: list[i],
          onTap: () => _goToDetail(list[i]),
        ),
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
                color: AppColors.primaryLightBrand.withOpacity(0.08),
                shape: BoxShape.circle),
            child: const Icon(Icons.calendar_month_rounded,
                size: 44, color: AppColors.primaryLightBrand),
          ),
          const SizedBox(height: 16),
          const Text('Chưa có lịch đặt sân',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary)),
          const SizedBox(height: 6),
          const Text('Hãy đặt sân đầu tiên của bạn!',
              style: TextStyle(color: AppColors.textHint, fontSize: 13)),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () => context.go('/venues'),
            icon:
                const Icon(Icons.sports_soccer_rounded, color: AppColors.white),
            label: const Text('Tìm sân ngay',
                style: TextStyle(
                    color: AppColors.white, fontWeight: FontWeight.bold)),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryLightBrand,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
      ),
    );
  }

  void _goToDetail(BookingListItemModel booking) async {
    await context.push('/booking-detail', extra: {
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

    if (mounted) {
      context.read<MyBookingsCubit>().getMyBookings();
    }
  }
}
