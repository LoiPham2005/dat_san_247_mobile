import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/features/customer/booking/data/models/time_slot_model.dart';
import 'package:dat_san_247_mobile/features/customer/booking/data/models/court_availability_model.dart';
import 'package:go_router/go_router.dart';

class TimeSlotPickerPage extends StatefulWidget {
  final String courtId;
  final String venueName;

  const TimeSlotPickerPage({
    super.key,
    required this.courtId,
    required this.venueName,
  });

  @override
  State<TimeSlotPickerPage> createState() => _TimeSlotPickerPageState();
}

class _TimeSlotPickerPageState extends State<TimeSlotPickerPage> {
  late DateTime _selectedDate;
  final List<DateTime> _availableDates = [];
  
  // Fake responses
  CourtAvailabilityModel? _availability;
  bool _isLoading = false;

  final List<TimeSlotModel> _selectedSlots = [];

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _generateDates();
    _fetchAvailability(_selectedDate);
  }

  void _generateDates() {
    final now = DateTime.now();
    for (int i = 0; i < 30; i++) {
      _availableDates.add(now.add(Duration(days: i)));
    }
  }

  Future<void> _fetchAvailability(DateTime date) async {
    setState(() {
      _isLoading = true;
      _selectedSlots.clear();
    });

    // MOCK API CALL: This would evaluate bookings, maintenance, pricing_rules, schedule_exceptions
    await Future.delayed(const Duration(milliseconds: 600));

    // Mock data for a single day
    final slots = <TimeSlotModel>[];
    for (int i = 6; i < 22; i++) { // 06:00 to 22:00
      final startTimeStr = '${i.toString().padLeft(2, '0')}:00';
      final endTimeStr = '${(i + 1).toString().padLeft(2, '0')}:00';
      
      TimeSlotStatus status = TimeSlotStatus.AVAILABLE;
      double price = 150000;

      // Mock some statuses
      if (i == 8 || i == 9) {
        status = TimeSlotStatus.BOOKED; // Booked slots
      } else if (i == 13 || i == 14) {
        status = TimeSlotStatus.MAINTENANCE; // Maintenance slots
      }

      // Mock pricing diff (evening = higher price)
      if (i >= 17) {
        price = 200000;
      }

      slots.add(TimeSlotModel(
        startTime: startTimeStr,
        endTime: endTimeStr,
        price: price,
        status: status,
      ));
    }

    if (!mounted) return;

    setState(() {
      _availability = CourtAvailabilityModel(
        courtId: widget.courtId,
        date: date,
        slots: slots,
      );
      _isLoading = false;
    });
  }

  void _onSlotTap(TimeSlotModel slot) {
    if (slot.status == TimeSlotStatus.BOOKED) {
      _showWaitlistDialog(slot);
      return;
    }
    if (slot.status != TimeSlotStatus.AVAILABLE) {
      return;
    }

    setState(() {
      if (_selectedSlots.contains(slot)) {
        _selectedSlots.remove(slot);
      } else {
        // Validation: Ensure contiguous selection if picking multiple
        if (_selectedSlots.isNotEmpty) {
           _selectedSlots.add(slot);
           _selectedSlots.sort((a, b) => a.startTime.compareTo(b.startTime));
           // TODO: Add logic to check if they are contiguous and not spanning over BOOKED slots.
        } else {
          _selectedSlots.add(slot);
        }
      }
    });
  }

  void _showWaitlistDialog(TimeSlotModel slot) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.notifications_active_rounded, color: AppColors.primaryLightBrand, size: 48),
              const SizedBox(height: 16),
              const Text('Slot này đã có người đặt!', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(
                'Bạn có muốn tham gia hàng chờ cho ca ${slot.startTime} - ${slot.endTime}?\nNền tảng sẽ thông báo ngay khi sân trống.',
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () => context.pop(),
                      child: const Text('Hủy', style: TextStyle(color: AppColors.textSecondary)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryLightBrand,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        // TODO: Call API waitlist
                        context.pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Đã thêm vào danh sách hàng chờ!')),
                        );
                      },
                      child: const Text('Tham gia Waitlist', style: TextStyle(color: AppColors.white)),
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final formatCurrency = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');
    double totalPrice = _selectedSlots.fold(0, (sum, slot) => sum + slot.price);

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Chọn khung giờ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
            Text(widget.venueName, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, fontWeight: FontWeight.normal)),
          ],
        ),
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
           icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary),
           onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          _buildDateStrip(),
          const Divider(height: 1, color: AppColors.borderLight),
          const SizedBox(height: 16),
          Expanded(
            child: _isLoading 
                ? const Center(child: CircularProgressIndicator(color: AppColors.primaryLightBrand))
                : _buildTimeSlotsGrid(),
          ),
        ],
      ),
      bottomNavigationBar: _selectedSlots.isNotEmpty ? _buildBottomBookingBar(formatCurrency, totalPrice) : null,
    );
  }

  Widget _buildDateStrip() {
    return Container(
      color: AppColors.white,
      height: 90,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: _availableDates.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final date = _availableDates[index];
          final isSelected = DateUtils.isSameDay(_selectedDate, date);
          
          final dayName = DateFormat('EEE', 'vi_VN').format(date); // T2, T3...
          final dayNumber = DateFormat('dd').format(date);

          return GestureDetector(
            onTap: () {
              setState(() => _selectedDate = date);
              _fetchAvailability(date);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 60,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primaryLightBrand : AppColors.mutedLight,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected ? AppColors.primaryLightBrand : AppColors.borderLight,
                )
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    dayName, 
                    style: TextStyle(
                      fontSize: 12, 
                      fontWeight: FontWeight.w500,
                      color: isSelected ? AppColors.white.withOpacity(0.9) : AppColors.textSecondary,
                    )
                  ),
                  const SizedBox(height: 4),
                  Text(
                    dayNumber, 
                    style: TextStyle(
                      fontSize: 18, 
                      fontWeight: FontWeight.bold,
                      color: isSelected ? AppColors.white : AppColors.textPrimary,
                    )
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTimeSlotsGrid() {
    if (_availability == null || _availability!.slots.isEmpty) {
      return const Center(child: Text('Không có lịch trống', style: TextStyle(color: AppColors.textHint)));
    }

    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 2.2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: _availability!.slots.length,
      itemBuilder: (context, index) {
        final slot = _availability!.slots[index];
        final isSelected = _selectedSlots.contains(slot);
        
        Color bgColor;
        Color textColor;
        Color borderColor;

        if (isSelected) {
          bgColor = AppColors.primaryLightBrand;
          textColor = AppColors.white;
          borderColor = AppColors.primaryLightBrand;
        } else if (slot.status == TimeSlotStatus.AVAILABLE) {
          bgColor = AppColors.white;
          textColor = AppColors.textPrimary;
          borderColor = AppColors.borderLight;
        } else if (slot.status == TimeSlotStatus.BOOKED) {
          bgColor = AppColors.mutedLight;
          textColor = AppColors.textHint;
          borderColor = AppColors.borderLight;
        } else { // MAINTENANCE / CLOSED
          bgColor = AppColors.error.withOpacity(0.1);
          textColor = AppColors.error;
          borderColor = AppColors.error.withOpacity(0.3);
        }

        final formatCurrency = NumberFormat.compact(locale: 'vi_VN').format(slot.price);

        return GestureDetector(
          onTap: () => _onSlotTap(slot),
          child: Container(
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: borderColor),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${slot.startTime}', 
                  style: TextStyle(
                    fontSize: 14, 
                    fontWeight: FontWeight.bold,
                    color: textColor,
                    decoration: slot.status == TimeSlotStatus.BOOKED ? TextDecoration.lineThrough : null,
                  ),
                ),
                if (slot.status == TimeSlotStatus.AVAILABLE || isSelected)
                  Text(
                    formatCurrency,
                    style: TextStyle(
                      fontSize: 11,
                      color: isSelected ? AppColors.white.withOpacity(0.9) : AppColors.primaryLightBrand,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                if (slot.status == TimeSlotStatus.MAINTENANCE)
                   const Text('Bảo trì', style: TextStyle(fontSize: 10, color: AppColors.error)),
                if (slot.status == TimeSlotStatus.BOOKED)
                   const Text('Waitlist', style: TextStyle(fontSize: 10, color: AppColors.textHint, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomBookingBar(NumberFormat formatter, double total) {
    return Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 16,
        bottom: MediaQuery.of(context).padding.bottom + 16,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${_selectedSlots.length} ca đã chọn', style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
              const SizedBox(height: 2),
              Text(
                formatter.format(total),
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primaryLightBrand),
              ),
            ],
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryLightBrand,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              if (_selectedSlots.isEmpty) return;
              GoRouter.of(context).push('/booking-confirm', extra: {
                'courtId': widget.courtId,
                'courtName': 'Sân A', // TODO: replace with real court name
                'venueId': 'venue-1', // TODO: replace with real venue id
                'venueName': widget.venueName,
                'venueAddress': '497 Hòa Hảo, Quận 10, TP.HCM', // TODO: from API
                'bookingDate': DateFormat('yyyy-MM-dd').format(_selectedDate),
                'selectedSlots': _selectedSlots,
              });
            },
            child: const Text('Tiếp tục', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.white)),
          ),
        ],
      ),
    );
  }
}
