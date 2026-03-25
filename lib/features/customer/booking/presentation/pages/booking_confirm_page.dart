import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/features/customer/booking/data/models/booking_models.dart';
import 'package:dat_san_247_mobile/features/customer/booking/data/models/time_slot_model.dart';
import '../widgets/booking_summary_card.dart';
import '../widgets/addons_card.dart';
import '../widgets/promo_card.dart';
import '../widgets/note_card.dart';
import '../widgets/payment_method_card.dart';
import '../widgets/refund_policy_card.dart';
import '../widgets/price_summary_card.dart';

// ──────────────────────────────────────────────────────────────────────────
// C-06: Màn Xác Nhận Đặt Sân
// ──────────────────────────────────────────────────────────────────────────
class BookingConfirmPage extends StatefulWidget {
  final String courtId;
  final String courtName;
  final String venueId;
  final String venueName;
  final String venueAddress;
  final String bookingDate; // yyyy-MM-dd
  final List<TimeSlotModel> selectedSlots;

  const BookingConfirmPage({
    super.key,
    required this.courtId,
    required this.courtName,
    required this.venueId,
    required this.venueName,
    required this.venueAddress,
    required this.bookingDate,
    required this.selectedSlots,
  });

  @override
  State<BookingConfirmPage> createState() => _BookingConfirmPageState();
}

class _BookingConfirmPageState extends State<BookingConfirmPage> {
  final _noteController = TextEditingController();
  final _promoController = TextEditingController();
  String _selectedPayment = 'MOMO';
  PromotionModel? _appliedPromo;
  bool _isApplyingPromo = false;
  bool _isSubmitting = false;

  final List<BookingAddonModel> _addons = [];

  // Mock services từ venue_services
  final List<VenueServiceModel> _mockServices = [
    VenueServiceModel(id: 's1', venueId: 'v1', name: 'Thuê áo đá bóng', price: 30000, unit: 'UNIT'),
    VenueServiceModel(id: 's2', venueId: 'v1', name: 'Nước uống Pocari', price: 15000, unit: 'UNIT'),
    VenueServiceModel(id: 's3', venueId: 'v1', name: 'Bơm bóng', price: 10000, unit: 'SESSION'),
  ];

  // Mock refund rules từ refund_policies + refund_rules
  final List<RefundRuleModel> _refundRules = [
    RefundRuleModel(cancelBeforeHours: 24, refundPercentage: 100, description: 'Hủy trước 24h: hoàn 100%'),
    RefundRuleModel(cancelBeforeHours: 4, refundPercentage: 50, description: 'Hủy trước 4h: hoàn 50%'),
    RefundRuleModel(cancelBeforeHours: 0, refundPercentage: 0, description: 'Hủy dưới 4h: không hoàn'),
  ];

  final _paymentMethods = [
    {'id': 'MOMO', 'label': 'MoMo', 'icon': '💜'},
    {'id': 'VNPAY', 'label': 'VNPay', 'icon': '🔵'},
    {'id': 'ZALOPAY', 'label': 'ZaloPay', 'icon': '🟢'},
    {'id': 'WALLET', 'label': 'Ví tài khoản', 'icon': '👛'},
    {'id': 'CASH', 'label': 'Tiền mặt', 'icon': '💵'},
  ];

  double get _subTotal => widget.selectedSlots.fold(0, (s, slot) => s + slot.price);

  double get _addonTotal => _addons.fold(0, (s, a) => s + a.totalPrice);

  double get _discountAmount {
    if (_appliedPromo == null) return 0;
    if (_appliedPromo!.discountType == 'PERCENTAGE') {
      final disc = (_subTotal + _addonTotal) * _appliedPromo!.discountValue / 100;
      return _appliedPromo!.maxDiscountAmount != null
          ? disc.clamp(0, _appliedPromo!.maxDiscountAmount!)
          : disc;
    }
    return _appliedPromo!.discountValue;
  }

  double get _totalAmount => (_subTotal + _addonTotal - _discountAmount).clamp(0, double.infinity);

  void _onAddonToggle(VenueServiceModel service) {
    setState(() {
      final idx = _addons.indexWhere((a) => a.serviceId == service.id);
      if (idx >= 0) {
        _addons.removeAt(idx);
      } else {
        _addons.add(BookingAddonModel(
          serviceId: service.id,
          name: service.name,
          pricePerUnit: service.price,
          unit: service.unit,
        ));
      }
    });
  }

  Future<void> _applyPromo() async {
    final code = _promoController.text.trim();
    if (code.isEmpty) return;
    setState(() => _isApplyingPromo = true);
    await Future.delayed(const Duration(milliseconds: 800));
    setState(() {
      _isApplyingPromo = false;
      // Mock: mã WELCOME20 → 20% off
      if (code.toUpperCase() == 'WELCOME20') {
        _appliedPromo = PromotionModel(
          id: 'promo-1',
          code: 'WELCOME20',
          name: 'Chào mừng thành viên mới',
          discountType: 'PERCENTAGE',
          discountValue: 20,
          maxDiscountAmount: 100000,
          minBookingAmount: 0,
          validFrom: DateTime.now().subtract(const Duration(days: 1)),
          validTo: DateTime.now().add(const Duration(days: 30)),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Áp dụng mã WELCOME20 thành công!'),
            backgroundColor: AppColors.primaryLightBrand,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('❌ Mã giảm giá không hợp lệ hoặc đã hết hạn.'),
              backgroundColor: AppColors.error),
        );
      }
    });
  }

  Future<void> _submitBooking() async {
    setState(() => _isSubmitting = true);
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    setState(() => _isSubmitting = false);
    // Navigate to payment page
    context.push('/payment', extra: {
      'venueName': widget.venueName,
      'courtName': widget.courtName,
      'bookingDate': widget.bookingDate,
      'startTime': widget.selectedSlots.first.startTime,
      'endTime': widget.selectedSlots.last.endTime,
      'totalAmount': _totalAmount,
      'paymentMethod': _selectedPayment,
    });
  }

  @override
  Widget build(BuildContext context) {
    final fmt = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');
    final formattedTotal = fmt.format(_totalAmount);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: const Text('Xác nhận đặt sân',
            style: TextStyle(
                fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BookingSummaryCard(
              courtName: widget.courtName,
              venueName: widget.venueName,
              venueAddress: widget.venueAddress,
              bookingDate: widget.bookingDate,
              selectedSlots: widget.selectedSlots,
            ),
            const SizedBox(height: 16),
            AddonsCard(
              services: _mockServices,
              selectedAddons: _addons,
              onToggle: _onAddonToggle,
            ),
            const SizedBox(height: 16),
            PromoCard(
              appliedPromo: _appliedPromo,
              controller: _promoController,
              isApplying: _isApplyingPromo,
              onApply: _applyPromo,
              onRemove: () => setState(() => _appliedPromo = null),
            ),
            const SizedBox(height: 16),
            NoteCard(controller: _noteController),
            const SizedBox(height: 16),
            PaymentMethodCard(
              selectedPayment: _selectedPayment,
              paymentMethods: _paymentMethods.map((e) => Map<String, String>.from(e)).toList(),
              onChanged: (v) => setState(() => _selectedPayment = v),
            ),
            const SizedBox(height: 16),
            RefundPolicyCard(refundRules: _refundRules),
            const SizedBox(height: 16),
            PriceSummaryCard(
              subTotal: _subTotal,
              addonTotal: _addonTotal,
              discountAmount: _discountAmount,
              totalAmount: _totalAmount,
              selectedSlotsCount: widget.selectedSlots.length,
              hasAppliedPromo: _appliedPromo != null,
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(formattedTotal),
    );
  }

  Widget _buildBottomBar(String formattedTotal) {
    return Container(
      padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 16,
          bottom: MediaQuery.of(context).padding.bottom + 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
              color: AppColors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, -4))
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Tổng cộng', style: TextStyle(color: AppColors.textHint, fontSize: 12)),
                Text(formattedTotal,
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: AppColors.primaryLightBrand)),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: _isSubmitting ? null : _submitBooking,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryLightBrand,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 0,
            ),
            child: _isSubmitting
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(strokeWidth: 2.5, color: AppColors.white))
                : const Text('Thanh toán ngay',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.white)),
          ),
        ],
      ),
    );
  }
}
