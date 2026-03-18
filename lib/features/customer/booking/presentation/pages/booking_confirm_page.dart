import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/features/customer/booking/data/models/booking_models.dart';
import 'package:dat_san_247_mobile/features/customer/booking/data/models/time_slot_model.dart';

// ──────────────────────────────────────────────────────────────────────────
// C-06: Màn Xác Nhận Đặt Sân
// ──────────────────────────────────────────────────────────────────────────
class BookingConfirmPage extends StatefulWidget {
  final String courtId;
  final String courtName;
  final String venueId;
  final String venueName;
  final String venueAddress;
  final String bookingDate;   // yyyy-MM-dd
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

  double get _subTotal =>
      widget.selectedSlots.fold(0, (s, slot) => s + slot.price);

  double get _addonTotal =>
      _addons.fold(0, (s, a) => s + a.totalPrice);

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
          const SnackBar(content: Text('❌ Mã giảm giá không hợp lệ hoặc đã hết hạn.'), backgroundColor: AppColors.error),
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
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: const Text('Xác nhận đặt sân', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBookingSummaryCard(fmt),
            const SizedBox(height: 16),
            _buildAddonsCard(fmt),
            const SizedBox(height: 16),
            _buildPromoCard(),
            const SizedBox(height: 16),
            _buildNoteCard(),
            const SizedBox(height: 16),
            _buildPaymentMethodCard(),
            const SizedBox(height: 16),
            _buildRefundPolicyCard(),
            const SizedBox(height: 16),
            _buildPriceSummaryCard(fmt),
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(fmt),
    );
  }

  Widget _buildBookingSummaryCard(NumberFormat fmt) {
    final slots = widget.selectedSlots;
    final startTime = slots.first.startTime;
    final endTime = slots.last.endTime;
    final date = DateFormat('EEEE, dd/MM/yyyy', 'vi_VN')
        .format(DateTime.parse(widget.bookingDate));

    return Container(
      decoration: _cardDecoration(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle(Icons.sports_soccer_rounded, 'Thông tin đặt sân'),
          const SizedBox(height: 16),
          _infoRow(Icons.stadium_rounded, 'Sân', '${widget.courtName} - ${widget.venueName}'),
          const SizedBox(height: 10),
          _infoRow(Icons.location_on_rounded, 'Địa chỉ', widget.venueAddress),
          const SizedBox(height: 10),
          _infoRow(Icons.calendar_today_rounded, 'Ngày', date),
          const SizedBox(height: 10),
          _infoRow(Icons.access_time_rounded, 'Giờ', '$startTime → $endTime (${slots.length}h)'),
          const SizedBox(height: 10),
          _infoRow(Icons.attach_money_rounded, 'Đơn giá', fmt.format(slots.first.price) + '/h'),
        ],
      ),
    );
  }

  Widget _buildAddonsCard(NumberFormat fmt) {
    return Container(
      decoration: _cardDecoration(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle(Icons.add_shopping_cart_rounded, 'Dịch vụ kèm theo'),
          const SizedBox(height: 4),
          const Text('Tùy chọn thêm dịch vụ từ sân', style: TextStyle(color: AppColors.textHint, fontSize: 12)),
          const SizedBox(height: 12),
          ..._mockServices.map((service) {
            final isSelected = _addons.any((a) => a.serviceId == service.id);
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primaryLightBrand.withOpacity(0.06) : AppColors.mutedLight,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isSelected ? AppColors.primaryLightBrand : AppColors.borderLight,
                ),
              ),
              child: ListTile(
                dense: true,
                title: Text(service.name, style: TextStyle(fontWeight: FontWeight.w600, color: isSelected ? AppColors.primaryLightBrand : AppColors.textPrimary)),
                subtitle: Text(fmt.format(service.price) + '/${service.unit == 'SESSION' ? 'buổi' : 'cái'}', style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                trailing: GestureDetector(
                  onTap: () => _onAddonToggle(service),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 28, height: 28,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected ? AppColors.primaryLightBrand : AppColors.white,
                      border: Border.all(color: isSelected ? AppColors.primaryLightBrand : AppColors.borderLight, width: 2),
                    ),
                    child: isSelected ? const Icon(Icons.check, size: 16, color: AppColors.white) : null,
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildPromoCard() {
    return Container(
      decoration: _cardDecoration(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle(Icons.local_offer_rounded, 'Mã giảm giá'),
          const SizedBox(height: 12),
          if (_appliedPromo != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.primaryLightBrand.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.primaryLightBrand),
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle_rounded, color: AppColors.primaryLightBrand, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(_appliedPromo!.name, style: const TextStyle(color: AppColors.primaryLightBrand, fontWeight: FontWeight.bold)),
                  ),
                  GestureDetector(
                    onTap: () => setState(() => _appliedPromo = null),
                    child: const Icon(Icons.close_rounded, size: 18, color: AppColors.primaryLightBrand),
                  ),
                ],
              ),
            )
          else
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _promoController,
                    style: const TextStyle(fontSize: 14),
                    decoration: InputDecoration(
                      hintText: 'Nhập mã khuyến mãi...',
                      hintStyle: const TextStyle(color: AppColors.textHint),
                      filled: true,
                      fillColor: AppColors.mutedLight,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _isApplyingPromo ? null : _applyPromo,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryLightBrand,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    elevation: 0,
                  ),
                  child: _isApplyingPromo
                      ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.white))
                      : const Text('Áp dụng', style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildNoteCard() {
    return Container(
      decoration: _cardDecoration(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle(Icons.note_alt_rounded, 'Ghi chú cho sân'),
          const SizedBox(height: 12),
          TextField(
            controller: _noteController,
            maxLines: 3,
            maxLength: 200,
            style: const TextStyle(fontSize: 14),
            decoration: InputDecoration(
              hintText: 'VD: Mang theo giày cỏ, đặt số lượng 6 người...',
              hintStyle: const TextStyle(color: AppColors.textHint, fontSize: 13),
              filled: true,
              fillColor: AppColors.mutedLight,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
              contentPadding: const EdgeInsets.all(12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodCard() {
    return Container(
      decoration: _cardDecoration(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle(Icons.payment_rounded, 'Phương thức thanh toán'),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 2.2,
            children: _paymentMethods.map((pm) {
              final isSelected = _selectedPayment == pm['id'];
              return GestureDetector(
                onTap: () => setState(() => _selectedPayment = pm['id']!),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primaryLightBrand.withOpacity(0.1) : AppColors.mutedLight,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: isSelected ? AppColors.primaryLightBrand : AppColors.borderLight, width: isSelected ? 2 : 1),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(pm['icon']!, style: const TextStyle(fontSize: 18)),
                      Text(pm['label']!, style: TextStyle(fontSize: 11, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, color: isSelected ? AppColors.primaryLightBrand : AppColors.textSecondary)),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildRefundPolicyCard() {
    return Container(
      decoration: _cardDecoration(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle(Icons.policy_rounded, 'Chính sách hoàn tiền'),
          const SizedBox(height: 12),
          ..._refundRules.map((rule) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 8, height: 8,
                  margin: const EdgeInsets.only(top: 5, right: 8),
                  decoration: const BoxDecoration(color: AppColors.primaryLightBrand, shape: BoxShape.circle),
                ),
                Expanded(child: Text(rule.description ?? '', style: const TextStyle(fontSize: 13, color: AppColors.textSecondary))),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildPriceSummaryCard(NumberFormat fmt) {
    return Container(
      decoration: _cardDecoration(),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _priceRow('Tiền sân (${widget.selectedSlots.length}h)', fmt.format(_subTotal)),
          if (_addonTotal > 0) _priceRow('Dịch vụ kèm theo', fmt.format(_addonTotal)),
          if (_appliedPromo != null) _priceRow('Giảm giá', '-${fmt.format(_discountAmount)}', isDiscount: true),
          const Padding(padding: EdgeInsets.symmetric(vertical: 10), child: Divider()),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Tổng thanh toán', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
              Text(fmt.format(_totalAmount), style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: AppColors.primaryLightBrand)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(NumberFormat fmt) {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20, top: 16, bottom: MediaQuery.of(context).padding.bottom + 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [BoxShadow(color: AppColors.black.withOpacity(0.06), blurRadius: 12, offset: const Offset(0, -4))],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Tổng cộng', style: TextStyle(color: AppColors.textHint, fontSize: 12)),
                Text(fmt.format(_totalAmount), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppColors.primaryLightBrand)),
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
                ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2.5, color: AppColors.white))
                : const Text('Thanh toán ngay', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.white)),
          ),
        ],
      ),
    );
  }

  // ── Helper Widgets ──────────────────────────────────────────────────────
  BoxDecoration _cardDecoration() => BoxDecoration(
    color: AppColors.white,
    borderRadius: BorderRadius.circular(16),
    boxShadow: [BoxShadow(color: AppColors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
  );

  Widget _sectionTitle(IconData icon, String title) => Row(
    children: [
      Icon(icon, color: AppColors.primaryLightBrand, size: 20),
      const SizedBox(width: 8),
      Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
    ],
  );

  Widget _infoRow(IconData icon, String label, String value) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Icon(icon, size: 16, color: AppColors.textHint),
      const SizedBox(width: 8),
      SizedBox(width: 64, child: Text(label, style: const TextStyle(fontSize: 13, color: AppColors.textHint))),
      Expanded(child: Text(value, style: const TextStyle(fontSize: 13, color: AppColors.textPrimary, fontWeight: FontWeight.w600))),
    ],
  );

  Widget _priceRow(String label, String value, {bool isDiscount = false}) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, color: AppColors.textSecondary)),
        Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: isDiscount ? AppColors.primaryLightBrand : AppColors.textPrimary)),
      ],
    ),
  );
}
