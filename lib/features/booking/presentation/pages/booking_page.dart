import 'package:dat_san_247_mobile/core/utils/extensions/int_ext.dart';
import 'package:dat_san_247_mobile/features/booking/presentation/widgets/booking_app_bar.dart';
import 'package:dat_san_247_mobile/features/booking/presentation/widgets/booking_bottom_bar.dart';
import 'package:dat_san_247_mobile/features/booking/presentation/widgets/customer_info_form.dart';
import 'package:dat_san_247_mobile/features/booking/presentation/widgets/date_selector.dart';
import 'package:dat_san_247_mobile/features/booking/presentation/widgets/duration_selector.dart';
import 'package:dat_san_247_mobile/features/booking/presentation/widgets/payment_method_selector.dart';
import 'package:dat_san_247_mobile/features/booking/presentation/widgets/price_summary_card.dart';
import 'package:dat_san_247_mobile/features/booking/presentation/widgets/time_slots_grid.dart';
import 'package:dat_san_247_mobile/features/booking/presentation/widgets/venue_info_card.dart';
import 'package:dat_san_247_mobile/features/booking/presentation/widgets/voucher_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class BookingPage extends StatefulWidget {
  final int venueId;
  final String venueName;
  final String venueAddress;
  final String? venueImage;
  final double pricePerHour;

  const BookingPage({
    super.key,
    required this.venueId,
    required this.venueName,
    required this.venueAddress,
    this.venueImage,
    required this.pricePerHour,
  });

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Booking data
  DateTime selectedDate = DateTime.now();
  TimeOfDay? selectedStartTime;
  int selectedDuration = 1; // hours
  String customerName = '';
  String customerPhone = '';
  String customerEmail = '';
  String notes = '';

  // Available time slots
  List<TimeOfDay> availableSlots = [
    TimeOfDay(hour: 6, minute: 0),
    TimeOfDay(hour: 7, minute: 0),
    TimeOfDay(hour: 8, minute: 0),
    TimeOfDay(hour: 9, minute: 0),
    TimeOfDay(hour: 10, minute: 0),
    TimeOfDay(hour: 14, minute: 0),
    TimeOfDay(hour: 15, minute: 0),
    TimeOfDay(hour: 16, minute: 0),
    TimeOfDay(hour: 17, minute: 0),
    TimeOfDay(hour: 18, minute: 0),
    TimeOfDay(hour: 19, minute: 0),
    TimeOfDay(hour: 20, minute: 0),
    TimeOfDay(hour: 21, minute: 0),
  ];

  // Booked slots (example data)
  List<TimeOfDay> bookedSlots = [
    TimeOfDay(hour: 9, minute: 0),
    TimeOfDay(hour: 15, minute: 0),
    TimeOfDay(hour: 19, minute: 0),
  ];

  String? voucherCode;

  String? selectedPaymentMethod; // null | 'cash' | 'banking' | 'wallet'

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
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

  double get totalPrice => widget.pricePerHour * selectedDuration;

  bool get canBook {
    return selectedStartTime != null &&
        customerName.isNotEmpty &&
        customerPhone.isNotEmpty;
  }

  void _onDateSelected(DateTime date) {
    setState(() {
      selectedDate = date;
      selectedStartTime = null; // Reset time when date changes
    });
  }

  void _onTimeSlotSelected(TimeOfDay time) {
    setState(() {
      selectedStartTime = time;
    });
  }

  void _onDurationChanged(int duration) {
    setState(() {
      selectedDuration = duration;
    });
  }

  void _updateCustomerInfo({
    String? name,
    String? phone,
    String? email,
    String? customerNotes,
  }) {
    setState(() {
      if (name != null) customerName = name;
      if (phone != null) customerPhone = phone;
      if (email != null) customerEmail = email;
      if (customerNotes != null) notes = customerNotes;
    });
  }

  void _onBookingConfirm() {
    if (!canBook) {
      _showErrorDialog('Vui lòng điền đầy đủ thông tin bắt buộc');
      return;
    }

    _showConfirmDialog();
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.red[600]),
            SizedBox(width: 8),
            Text('Thông báo'),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Đóng'),
          ),
        ],
      ),
    );
  }

  void _showConfirmDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.green[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.check_circle, color: Colors.green[600]),
            ),
            SizedBox(width: 10),
            Text('Xác nhận đặt sân', style: TextStyle(fontSize: 15)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildConfirmRow('Sân:', widget.venueName),
            _buildConfirmRow(
              'Ngày:',
              DateFormat('dd/MM/yyyy').format(selectedDate),
            ),
            _buildConfirmRow('Giờ:', selectedStartTime!.format(context)),
            _buildConfirmRow('Thời gian:', '$selectedDuration giờ'),
            _buildConfirmRow('Khách hàng:', customerName),
            _buildConfirmRow('Số điện thoại:', customerPhone),
            Divider(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Tổng tiền:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  '${NumberFormat('#,##0').format(totalPrice)}đ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Hủy'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
              _processBooking();
            },
            child: Text('Xác nhận'),
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(label, style: TextStyle(color: Colors.grey[600])),
          ),
          Expanded(
            child: Text(value, style: TextStyle(fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }

  // void _processBooking() {
  //   // Show loading
  //   showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (context) => Center(
  //       child: Container(
  //         padding: EdgeInsets.all(20),
  //         decoration: BoxDecoration(
  //           color: Colors.white,
  //           borderRadius: BorderRadius.circular(16),
  //         ),
  //         child: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             CircularProgressIndicator(),
  //             SizedBox(height: 16),
  //             Text('Đang xử lý đặt sân...'),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );

  void _processBooking() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: Container(
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xff62b766), Color(0xff4fa553), Colors.white],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 56,
                width: 56,
                child: CircularProgressIndicator(
                  strokeWidth: 5,
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xff62b766)),
                  backgroundColor: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Đang xử lý đặt sân...',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff2D3748),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Vui lòng chờ trong giây lát',
                style: TextStyle(fontSize: 13, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ),
    );

    // Simulate booking process
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pop(context); // Close loading dialog
      _showSuccessDialog();
    });
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green[100],
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.check, color: Colors.green[600], size: 48),
            ),
            SizedBox(height: 16),
            Text(
              'Đặt sân thành công!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Chúng tôi sẽ liên hệ với bạn sớm nhất để xác nhận.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.symmetric(vertical: 12),
              ),
              onPressed: () {
                Navigator.pop(context); // Close dialog
                Navigator.pop(context); // Go back to previous screen
              },
              child: Text('Hoàn tất'),
            ),
          ),
        ],
      ),
    );
  }

  void _onVoucherTap() async {
    // Hiển thị dialog chọn voucher hoặc nhập mã
    final code = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Nhập mã voucher'),
        content: TextField(
          autofocus: true,
          decoration: InputDecoration(hintText: 'Nhập mã voucher'),
          onSubmitted: (value) => Navigator.pop(context, value),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              // Lấy giá trị từ TextField
              Navigator.pop(context, null);
            },
            child: Text('Xác nhận'),
          ),
        ],
      ),
    );
    if (code != null && code.isNotEmpty) {
      setState(() {
        voucherCode = code;
      });
    }
  }

  void _onPaymentMethodChanged(String method) {
    setState(() {
      selectedPaymentMethod = method;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Container(
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
        child: CustomScrollView(
          slivers: [
            BookingAppBar(
              venueName: widget.venueName,
              venueImage: widget.venueImage,
              colorScheme: colorScheme,
            ),
            SliverToBoxAdapter(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Column(
                    children: [
                      50.height,
                      VenueInfoCard(
                        venueName: widget.venueName,
                        venueAddress: widget.venueAddress,
                        pricePerHour: widget.pricePerHour,
                      ),
                      DateSelector(
                        selectedDate: selectedDate,
                        onDateSelected: _onDateSelected,
                      ),
                      TimeSlotsGrid(
                        availableSlots: availableSlots,
                        bookedSlots: bookedSlots,
                        selectedSlot: selectedStartTime,
                        onSlotSelected: _onTimeSlotSelected,
                      ),
                      DurationSelector(
                        selectedDuration: selectedDuration,
                        onDurationChanged: _onDurationChanged,
                      ),
                      CustomerInfoForm(onInfoChanged: _updateCustomerInfo),
                      // Thêm voucher widget ở đây
                      VoucherWidget(
                        voucherCode: voucherCode,
                        onTap: _onVoucherTap,
                      ),
                      PriceSummaryCard(
                        pricePerHour: widget.pricePerHour,
                        duration: selectedDuration,
                        totalPrice: totalPrice,
                      ),
                      PaymentMethodSelector(
                        selectedMethod: selectedPaymentMethod,
                        onMethodSelected: _onPaymentMethodChanged,
                      ),
                      30.height,
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BookingBottomBar(
        canBook: canBook,
        totalPrice: totalPrice,
        onConfirm: _onBookingConfirm,
        colorScheme: colorScheme,
      ),
    );
  }
}
