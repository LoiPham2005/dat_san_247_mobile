import 'package:dat_san_247_mobile/features/venue_staff/schedule/presentation/widgets/booking_addon_section.dart';
import 'package:dat_san_247_mobile/features/venue_staff/schedule/presentation/widgets/booking_detail_card.dart';
import 'package:dat_san_247_mobile/features/venue_staff/schedule/presentation/widgets/booking_detail_row.dart';
import 'package:dat_san_247_mobile/features/venue_staff/schedule/presentation/widgets/booking_qr_code_row.dart';
import 'package:dat_san_247_mobile/features/venue_staff/schedule/presentation/widgets/booking_status_banner.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/features/venue_staff/check_in/data/models/check_in_models.dart';
import 'package:dat_san_247_mobile/features/venue_staff/check_in/presentation/pages/check_in_confirm_page.dart';
import 'package:dat_san_247_mobile/features/venue_staff/schedule/data/models/staff_schedule_models.dart';

// ══════════════════════════════════════════════════════════════════════════════
// VS-05: Staff Booking Detail + Add Addon
// ══════════════════════════════════════════════════════════════════════════════
class StaffBookingDetailPage extends StatefulWidget {
  final StaffBookingDetailModel booking;
  final bool canAddAddon; // MANAGER || STAFF role

  const StaffBookingDetailPage({
    super.key,
    required this.booking,
    this.canAddAddon = true,
  });

  @override
  State<StaffBookingDetailPage> createState() => _StaffBookingDetailPageState();
}

class _StaffBookingDetailPageState extends State<StaffBookingDetailPage> {
  static const Color _brand = Color(0xFF7C3AED);

  late List<StaffBookingAddonModel> _addons;

  // Mock available services for add-addon
  final List<VenueServiceModel> _availableServices = const [
    VenueServiceModel(
        id: 's1',
        venueId: 'v1',
        name: 'Nước Pocari',
        category: 'Đồ uống',
        price: 15000,
        unit: ServiceUnit.UNIT,
        isAvailable: true),
    VenueServiceModel(
        id: 's2',
        venueId: 'v1',
        name: 'Bóng đá size 5',
        category: 'Thiết bị',
        price: 20000,
        unit: ServiceUnit.UNIT,
        isAvailable: true),
    VenueServiceModel(
        id: 's3',
        venueId: 'v1',
        name: 'Găng tay thủ môn',
        category: 'Thiết bị',
        price: 10000,
        unit: ServiceUnit.SESSION,
        isAvailable: true),
    VenueServiceModel(
        id: 's4',
        venueId: 'v1',
        name: 'Nước lọc 500ml',
        category: 'Đồ uống',
        price: 8000,
        unit: ServiceUnit.UNIT,
        isAvailable: true),
    VenueServiceModel(
        id: 's5',
        venueId: 'v1',
        name: 'Áo thi đấu',
        category: 'Thiết bị',
        price: 30000,
        unit: ServiceUnit.SESSION,
        isAvailable: false),
  ];

  @override
  void initState() {
    super.initState();
    _addons = List.from(widget.booking.addons);
  }

  @override
  Widget build(BuildContext context) {
    final b = widget.booking;
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      body: CustomScrollView(
        slivers: [
          // ── AppBar ──
          SliverAppBar(
            pinned: true,
            backgroundColor: _brand,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 18),
              onPressed: () => Navigator.pop(context),
            ),
            title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Chi tiết Booking',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
              Text(b.bookingCode,
                  style: const TextStyle(
                      color: Colors.white70, fontSize: 11, fontFamily: 'monospace')),
            ]),
            actions: [
              // QR check-in shortcut
              if (b.status == BookingStatusVS.CONFIRMED)
                IconButton(
                  icon: const Icon(Icons.qr_code_scanner_rounded, color: Colors.white),
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => CheckInConfirmPage(booking: _toCheckInModel(b)),
                  )),
                ),
            ],
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 30),
              child: Column(children: [
                // ── Status bar ──
                BookingStatusBanner(status: b.status),
                const SizedBox(height: 12),

                // ── Customer ──
                BookingDetailCard(
                    child: Row(children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: _brand.withOpacity(0.12),
                    child: Text(b.customerName[0],
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: _brand)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(b.customerName,
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                    if (b.customerPhone != null)
                      Row(children: [
                        const Icon(Icons.phone_rounded, size: 12, color: AppColors.textHint),
                        const SizedBox(width: 4),
                        Text(b.customerPhone!,
                            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                      ]),
                  ])),
                  // Call button
                  if (b.customerPhone != null)
                    GestureDetector(
                      onTap: () => HapticFeedback.selectionClick(),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: AppColors.success.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10)),
                        child: const Icon(Icons.phone_rounded, size: 18, color: AppColors.success),
                      ),
                    ),
                ])),
                const SizedBox(height: 10),

                // ── Booking info ──
                BookingDetailCard(
                  title: 'Thông tin đặt sân',
                  child: Column(children: [
                    BookingDetailRow(
                        icon: Icons.sports_soccer_rounded,
                        label: 'Sân',
                        value: b.courtName,
                        valueColor: _brand),
                    BookingDetailRow(
                        icon: Icons.event_rounded,
                        label: 'Ngày',
                        value: DateFormat('EEE, dd/MM/yyyy', 'vi').format(b.bookingDate)),
                    BookingDetailRow(
                        icon: Icons.access_time_rounded,
                        label: 'Giờ chơi',
                        value: '${b.startTime} – ${b.endTime}',
                        valueColor: _brand,
                        isBold: true),
                    BookingDetailRow(
                        icon: Icons.confirmation_number_rounded,
                        label: 'Mã booking',
                        value: b.bookingCode,
                        isMono: true),
                    if (b.checkInCode != null) BookingQrCodeRow(code: b.checkInCode!),
                    if (b.checkedInAt != null) ...[
                      const Divider(height: 16, color: AppColors.borderLight),
                      BookingDetailRow(
                        icon: Icons.how_to_reg_rounded,
                        label: 'Check-in lúc',
                        value: DateFormat('HH:mm dd/MM').format(b.checkedInAt!),
                        valueColor: AppColors.success,
                      ),
                      if (b.checkedInByName != null)
                        BookingDetailRow(
                            icon: Icons.person_rounded,
                            label: 'Thực hiện bởi',
                            value: b.checkedInByName!),
                    ],
                    if (b.note != null && b.note!.isNotEmpty) ...[
                      const Divider(height: 16, color: AppColors.borderLight),
                      BookingDetailRow(icon: Icons.notes_rounded, label: 'Ghi chú', value: b.note!),
                    ],
                  ]),
                ),
                const SizedBox(height: 10),

                // ── Payment ──
                BookingDetailCard(
                  title: 'Thanh toán',
                  child: Column(children: [
                    BookingDetailRow(label: 'Tiền sân', value: _fmt(b.subTotal)),
                    if (b.discountAmount > 0)
                      BookingDetailRow(
                          label: 'Giảm giá',
                          value: '–${_fmt(b.discountAmount)}',
                          valueColor: AppColors.success),
                    if (b.vatAmount > 0)
                      BookingDetailRow(
                          label: 'Thuế VAT',
                          value: '+${_fmt(b.vatAmount)}',
                          valueColor: AppColors.warning),
                    if (_addons.isNotEmpty)
                      BookingDetailRow(
                          label: 'Addon',
                          value: _fmt(_addons.fold(0.0, (s, a) => s + a.totalPrice))),
                    const Divider(height: 12, color: AppColors.borderLight),
                    BookingDetailRow(
                        label: 'Tổng cộng',
                        value: _fmt(b.totalAmount + _addons.fold(0.0, (s, a) => s + a.totalPrice)),
                        isBold: true,
                        valueColor: _brand),
                    BookingDetailRow(
                        label: 'Phương thức',
                        value: _paymentLabel(b.paymentMethod),
                        valueColor: AppColors.textSecondary),
                  ]),
                ),
                const SizedBox(height: 10),

                // ── Addons ──
                BookingAddonSection(
                  addons: _addons,
                  availableServices: _availableServices,
                  canAdd: widget.canAddAddon,
                  onAddonAdded: (addon) => setState(() => _addons.add(addon)),
                  onAddonRemoved: (id) => setState(() => _addons.removeWhere((a) => a.id == id)),
                ),

                // ── Action button: Check-in ──
                if (b.status == BookingStatusVS.CONFIRMED) ...[
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => CheckInConfirmPage(booking: _toCheckInModel(b)),
                      )),
                      icon: const Icon(Icons.qr_code_scanner_rounded, size: 20),
                      label: const Text('Xác nhận Check-in',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.success,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        elevation: 0,
                      ),
                    ),
                  ),
                ],
              ]),
            ),
          ),
        ],
      ),
    );
  }

  CheckInBookingModel _toCheckInModel(StaffBookingDetailModel b) => CheckInBookingModel(
        id: b.id,
        bookingCode: b.bookingCode,
        checkInCode: b.checkInCode,
        courtId: b.courtId,
        courtName: b.courtName,
        isIndoor: b.isIndoor,
        venueName: b.venueName,
        venueAddress: '',
        customerId: b.customerId,
        customerName: b.customerName,
        customerPhone: b.customerPhone,
        bookingDate: b.bookingDate,
        startTime: b.startTime,
        endTime: b.endTime,
        status: b.status,
        totalAmount: b.totalAmount,
        paymentMethod: b.paymentMethod,
        addons: _addons,
      );

  String _fmt(double v) {
    final n = v.toInt();
    final s = n.toString();
    final result = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) result.write('.');
      result.write(s[i]);
    }
    return '${result}đ';
  }

  String _paymentLabel(String? m) => switch (m) {
        'CASH' => '💵 Tiền mặt',
        'WALLET' => '👛 Ví điện tử',
        'BANK_TRANSFER' => '🏦 Chuyển khoản',
        'MOMO' => '🟣 MoMo',
        _ => '—',
      };
}
