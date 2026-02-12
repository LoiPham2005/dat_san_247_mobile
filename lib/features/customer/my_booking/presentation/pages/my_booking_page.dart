import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../utils/booking_const.dart';
import '../utils/booking_status_utils.dart';
import '../widget/bookings_list_section.dart';
import '../widget/my_booking_header.dart';
import '../widget/my_booking_tab_bar.dart';
import '../widget/search_filter_section.dart';
import '../widget/stats_summary_section.dart';

class MyBookingPage extends StatefulWidget {
  const MyBookingPage({super.key});

  @override
  State<MyBookingPage> createState() => _MyBookingPageState();
}

class _MyBookingPageState extends State<MyBookingPage>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _tabController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final TextEditingController searchController = TextEditingController();
  String selectedStatus = 'Tất cả';
  int selectedTabIndex = 0;

  // Mock data với thông tin đầy đủ hơn
  List<BookingModel> bookings = [
    BookingModel(
      id: '1',
      venue: 'Sân bóng Mỹ Đình Sport Center',
      address: 'Nam Từ Liêm, Hà Nội',
      date: DateTime.now().add(const Duration(days: 2)),
      timeStart: '18:00',
      timeEnd: '20:00',
      status: BookingStatus.confirmed,
      price: 400000,
      duration: 2,
      imageUrl:
          'https://images.unsplash.com/photo-1574629810360-7efbbe195018?w=400',
      category: 'Bóng đá',
      playerCount: 22,
      isPaid: true,
    ),
    BookingModel(
      id: '2',
      venue: 'Sân Tennis Thanh Xuân Premium',
      address: 'Thanh Xuân, Hà Nội',
      date: DateTime.now().add(const Duration(days: 5)),
      timeStart: '07:00',
      timeEnd: '09:00',
      status: BookingStatus.pending,
      price: 160000,
      duration: 2,
      imageUrl:
          'https://images.unsplash.com/photo-1551698618-1dfe5d97d256?w=400',
      category: 'Tennis',
      playerCount: 4,
      isPaid: false,
    ),
    BookingModel(
      id: '3',
      venue: 'Sân cầu lông Hoàng Mai',
      address: 'Hoàng Mai, Hà Nội',
      date: DateTime.now().subtract(const Duration(days: 3)),
      timeStart: '19:30',
      timeEnd: '21:30',
      status: BookingStatus.completed,
      price: 120000,
      duration: 2,
      imageUrl:
          'https://images.unsplash.com/photo-1579952363873-27d3bfad9c0d?w=400',
      category: 'Cầu lông',
      playerCount: 4,
      isPaid: true,
    ),
    BookingModel(
      id: '4',
      venue: 'Sân bóng rổ Cầu Giấy',
      address: 'Cầu Giấy, Hà Nội',
      date: DateTime.now().subtract(const Duration(days: 1)),
      timeStart: '20:00',
      timeEnd: '22:00',
      status: BookingStatus.cancelled,
      price: 180000,
      duration: 2,
      imageUrl:
          'https://images.unsplash.com/photo-1546519638-68e109498ffc?w=400',
      category: 'Bóng rổ',
      playerCount: 10,
      isPaid: false,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _tabController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutCubic,
          ),
        );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _tabController.dispose();
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: SafeArea(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xff62b766).withOpacity(0.08),
                    Colors.white,
                    Color(0xff4fa553).withOpacity(0.04),
                  ],
                ),
              ),
              child: Column(
                children: [
                  // Header
                  const MyBookingHeader(),

                  // Tab bar
                  MyBookingTabBar(
                    selectedIndex: selectedTabIndex,
                    onTabChanged: (newIndex) {
                      setState(() {
                        selectedTabIndex = newIndex;
                      });
                    },
                  ),

                  // Search và filter section
                  SearchFilterSection(
                    searchController: searchController,
                    selectedStatus: selectedStatus,
                    onStatusChanged: (newStatus) {
                      setState(() {
                        selectedStatus = newStatus!;
                      });
                    },
                    onSearchChanged: () {
                      setState(() {});
                    },
                  ),

                  // Stats summary section
                  // StatsSummarySection(bookings: _getFilteredBookings()),

                  // // Bookings list section
                  // Expanded(
                  //   child: BookingsListSection(
                  //     bookings: _getFilteredBookings(),
                  //     onBookingTap: (booking) {
                  //       // TODO: Handle booking tap
                  //     },
                  //     onCancelBooking: _handleCancelBooking,
                  //     onBookAgain: (booking) {
                  //       _bookAgain(booking);
                  //     },
                  //   ),
                  // ),
                  Expanded(
                    child: CustomScrollView(
                      slivers: [
                        SliverToBoxAdapter(
                          child: StatsSummarySection(
                            bookings: _getFilteredBookings(),
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: BookingsListSection(
                            bookings: _getFilteredBookings(),
                            onBookingTap: (booking) {},
                            onCancelBooking: _handleCancelBooking,
                            onBookAgain: _bookAgain,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Thêm method để lọc bookings
  List<BookingModel> _getFilteredBookings() {
    return bookings.where((booking) {
      // Filter by status
      bool matchesStatus =
          selectedStatus == 'Tất cả' ||
          BookingStatusUtils.getStatusText(booking.status) == selectedStatus;

      // Filter by tab
      bool matchesTab = true;
      final now = DateTime.now();
      switch (selectedTabIndex) {
        case 0: // Tất cả
          matchesTab = true;
          break;
        case 1: // Sắp tới
          matchesTab =
              booking.date.isAfter(now) &&
              (booking.status == BookingStatus.confirmed ||
                  booking.status == BookingStatus.pending);
          break;
        case 2: // Đã hoàn thành
          matchesTab = booking.status == BookingStatus.completed;
          break;
        case 3: // Đã hủy
          matchesTab = booking.status == BookingStatus.cancelled;
          break;
      }

      // Filter by search
      bool matchesSearch =
          searchController.text.isEmpty ||
          booking.venue.toLowerCase().contains(
            searchController.text.toLowerCase(),
          ) ||
          booking.category.toLowerCase().contains(
            searchController.text.toLowerCase(),
          );

      return matchesStatus && matchesTab && matchesSearch;
    }).toList();
  }

  void _bookAgain(BookingModel booking) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.refresh, color: Colors.green, size: 28),
            const SizedBox(width: 12),
            const Text('Đặt lại sân'),
          ],
        ),
        content: Text(
          'Bạn muốn đặt lại sân "${booking.venue}" với thông tin tương tự?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Đang chuyển đến trang đặt sân "${booking.venue}"',
                  ),
                  action: SnackBarAction(
                    label: 'Đặt ngay',
                    onPressed: () {
                      // TODO: Navigate to booking screen with pre-filled data
                    },
                  ),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Đặt ngay'),
          ),
        ],
      ),
    );
  }

  void _handleCancelBooking(BookingModel booking) {
    setState(() {
      final index = bookings.indexWhere((b) => b.id == booking.id);
      if (index != -1) {
        bookings[index] = booking.copyWith(status: BookingStatus.cancelled);
      }
    });
  }
}
