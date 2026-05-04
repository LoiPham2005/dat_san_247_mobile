import 'package:dat_san_247_mobile/core/base/state/riverpod/riverpod_listeners.dart';
import 'package:dat_san_247_mobile/core/services/manager/toast_service.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/features/customer/booking/data/models/booking_models.dart';
import 'package:dat_san_247_mobile/features/customer/booking/data/models/booking_request.dart';
import 'package:dat_san_247_mobile/features/customer/booking/data/models/time_slot_model.dart';
import 'package:dat_san_247_mobile/features/customer/booking/presentation/providers/booking_confirm_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../widgets/addons_card.dart';
import '../widgets/booking_summary_card.dart';
import '../widgets/note_card.dart';
import '../widgets/payment_method_card.dart';
import '../widgets/price_summary_card.dart';
import '../widgets/promo_card.dart';
import '../widgets/refund_policy_card.dart';

// ──────────────────────────────────────────────────────────────────────────
// C-06: Màn Xác Nhận Đặt Sân
// ──────────────────────────────────────────────────────────────────────────
class BookingConfirmPage extends HookConsumerWidget {
  final String courtId;
  final String courtName;
  final String venueId;
  final String venueName;
  final String venueAddress;
  final String bookingDate;
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

  static final _mockServices = [
    VenueServiceModel(id: 's1', venueId: 'v1', name: 'Thuê áo đá bóng', price: 30000, unit: 'UNIT'),
    VenueServiceModel(id: 's2', venueId: 'v1', name: 'Nước uống Pocari', price: 15000, unit: 'UNIT'),
    VenueServiceModel(id: 's3', venueId: 'v1', name: 'Bơm bóng', price: 10000, unit: 'SESSION'),
  ];

  static final _refundRules = [
    RefundRuleModel(cancelBeforeHours: 24, refundPercentage: 100, description: 'Hủy trước giờ trên 24h: hoàn tiền 100%'),
    RefundRuleModel(cancelBeforeHours: 4, refundPercentage: 50, description: 'Hủy trước từ 4h đến 24h: hoàn tiền 50%'),
    RefundRuleModel(cancelBeforeHours: 0, refundPercentage: 0, description: 'Hủy trong vòng 4h trước giờ: không hoàn tiền'),
  ];

  static const _paymentMethods = [
    {'id': 'MOMO', 'label': 'MoMo', 'icon': '💜'},
    {'id': 'VNPAY', 'label': 'VNPay', 'icon': '🔵'},
    {'id': 'ZALOPAY', 'label': 'ZaloPay', 'icon': '🟢'},
    {'id': 'WALLET', 'label': 'Ví tài khoản', 'icon': '👛'},
    {'id': 'CASH', 'label': 'Tiền mặt', 'icon': '💵'},
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final noteController = useTextEditingController();
    final promoController = useTextEditingController();
    final selectedPayment = useState('MOMO');
    final appliedPromo = useState<PromotionModel?>(null);
    final isApplyingPromo = useState(false);
    final addons = useState<List<BookingAddonModel>>([]);

    final state = ref.watch(bookingConfirmProvider);
    final notifier = ref.read(bookingConfirmProvider.notifier);
    final isLoading = state.isLoading;

    final subTotal = selectedSlots.fold<double>(0, (s, slot) => s + slot.price);
    final addonTotal = addons.value.fold<double>(0, (s, a) => s + a.totalPrice);
    final discountAmount = _computeDiscount(appliedPromo.value, subTotal + addonTotal);
    final totalAmount =
        (subTotal + addonTotal - discountAmount).clamp(0, double.infinity).toDouble();

    RiverpodListeners.async$(
      ref: ref,
      context: context,
      provider: bookingConfirmProvider,
      notifier: notifier,
      onSuccess: (data) {
        if (data == null) return;
        context.push('/payment', extra: {
          'bookingCode': data.bookingCode,
          'venueName': venueName,
          'courtName': courtName,
          'bookingDate': data.bookingDate,
          'startTime': data.startTime,
          'endTime': data.endTime,
          'totalAmount': data.totalAmount,
          'paymentMethod': selectedPayment.value,
        });
      },
    );

    void onAddonToggle(VenueServiceModel service) {
      final current = [...addons.value];
      final idx = current.indexWhere((a) => a.serviceId == service.id);
      if (idx >= 0) {
        current.removeAt(idx);
      } else {
        current.add(BookingAddonModel(
          serviceId: service.id,
          name: service.name,
          pricePerUnit: service.price,
          unit: service.unit,
        ));
      }
      addons.value = current;
    }

    Future<void> applyPromo() async {
      final code = promoController.text.trim();
      if (code.isEmpty) return;
      isApplyingPromo.value = true;
      await Future.delayed(const Duration(milliseconds: 800));
      isApplyingPromo.value = false;
      if (code.toUpperCase() == 'WELCOME20') {
        appliedPromo.value = PromotionModel(
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
        toast.success('✅ Áp dụng mã WELCOME20 thành công!');
      } else {
        toast.error('❌ Mã giảm giá không hợp lệ hoặc đã hết hạn.');
      }
    }

    void submitBooking() {
      final items = selectedSlots
          .map((slot) => BookingItemRequest(
                courtId: courtId,
                startTime: slot.startTime,
                endTime: slot.endTime,
              ))
          .toList();
      final request = CreateBookingRequest(
        venueId: venueId,
        bookingDate: bookingDate,
        items: items,
        paymentMethod: selectedPayment.value,
        voucherCode: appliedPromo.value?.code,
        note: noteController.text,
      );
      notifier.createBooking(request);
    }

    final fmt = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');
    final formattedTotal = fmt.format(totalAmount);

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
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BookingSummaryCard(
              courtName: courtName,
              venueName: venueName,
              venueAddress: venueAddress,
              bookingDate: bookingDate,
              selectedSlots: selectedSlots,
            ),
            const SizedBox(height: 16),
            AddonsCard(
              services: _mockServices,
              selectedAddons: addons.value,
              onToggle: onAddonToggle,
            ),
            const SizedBox(height: 16),
            PromoCard(
              appliedPromo: appliedPromo.value,
              controller: promoController,
              isApplying: isApplyingPromo.value,
              onApply: applyPromo,
              onRemove: () => appliedPromo.value = null,
            ),
            const SizedBox(height: 16),
            NoteCard(controller: noteController),
            const SizedBox(height: 16),
            PaymentMethodCard(
              selectedPayment: selectedPayment.value,
              paymentMethods: _paymentMethods.map((e) => Map<String, String>.from(e)).toList(),
              onChanged: (v) => selectedPayment.value = v,
            ),
            const SizedBox(height: 16),
            RefundPolicyCard(refundRules: _refundRules),
            const SizedBox(height: 16),
            PriceSummaryCard(
              subTotal: subTotal,
              addonTotal: addonTotal,
              discountAmount: discountAmount,
              totalAmount: totalAmount,
              selectedSlotsCount: selectedSlots.length,
              hasAppliedPromo: appliedPromo.value != null,
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: Container(
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
                  const Text('Tổng cộng',
                      style: TextStyle(color: AppColors.textHint, fontSize: 12)),
                  Text(formattedTotal,
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          color: AppColors.primaryLightBrand)),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: isLoading ? null : submitBooking,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryLightBrand,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: isLoading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                          strokeWidth: 2.5, color: AppColors.white))
                  : const Text('Thanh toán ngay',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColors.white)),
            ),
          ],
        ),
      ),
    );
  }

  double _computeDiscount(PromotionModel? promo, double subTotal) {
    if (promo == null) return 0;
    if (promo.discountType == 'PERCENTAGE') {
      final disc = subTotal * promo.discountValue / 100;
      return promo.maxDiscountAmount != null
          ? disc.clamp(0, promo.maxDiscountAmount!).toDouble()
          : disc;
    }
    return promo.discountValue;
  }
}
