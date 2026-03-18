import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/features/venue_staff/check_in/data/models/check_in_models.dart';
import 'package:dat_san_247_mobile/features/venue_staff/check_in/presentation/pages/qr_checkin_page.dart';
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
    VenueServiceModel(id:'s1', venueId:'v1', name:'Nước Pocari', category:'Đồ uống', price:15000, unit:ServiceUnit.UNIT, isAvailable:true),
    VenueServiceModel(id:'s2', venueId:'v1', name:'Bóng đá size 5', category:'Thiết bị', price:20000, unit:ServiceUnit.UNIT, isAvailable:true),
    VenueServiceModel(id:'s3', venueId:'v1', name:'Găng tay thủ môn', category:'Thiết bị', price:10000, unit:ServiceUnit.SESSION, isAvailable:true),
    VenueServiceModel(id:'s4', venueId:'v1', name:'Nước lọc 500ml', category:'Đồ uống', price:8000, unit:ServiceUnit.UNIT, isAvailable:true),
    VenueServiceModel(id:'s5', venueId:'v1', name:'Áo thi đấu', category:'Thiết bị', price:30000, unit:ServiceUnit.SESSION, isAvailable:false),
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
              const Text('Chi tiết Booking', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
              Text(b.bookingCode, style: const TextStyle(color: Colors.white70, fontSize: 11, fontFamily: 'monospace')),
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
                _StatusBanner(status: b.status),
                const SizedBox(height: 12),

                // ── Customer ──
                _Card(child: Row(children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: _brand.withOpacity(0.12),
                    child: Text(b.customerName[0], style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: _brand)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(b.customerName, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                    if (b.customerPhone != null)
                      Row(children: [
                        const Icon(Icons.phone_rounded, size: 12, color: AppColors.textHint),
                        const SizedBox(width: 4),
                        Text(b.customerPhone!, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                      ]),
                  ])),
                  // Call button
                  if (b.customerPhone != null)
                    GestureDetector(
                      onTap: () => HapticFeedback.selectionClick(),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: AppColors.success.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                        child: const Icon(Icons.phone_rounded, size: 18, color: AppColors.success),
                      ),
                    ),
                ])),
                const SizedBox(height: 10),

                // ── Booking info ──
                _Card(
                  title: 'Thông tin đặt sân',
                  child: Column(children: [
                    _Row(icon: Icons.sports_soccer_rounded, label: 'Sân', value: b.courtName, valueColor: _brand),
                    _Row(icon: Icons.event_rounded, label: 'Ngày', value: DateFormat('EEE, dd/MM/yyyy', 'vi').format(b.bookingDate)),
                    _Row(icon: Icons.access_time_rounded, label: 'Giờ chơi', value: '${b.startTime} – ${b.endTime}', valueColor: _brand, isBold: true),
                    _Row(icon: Icons.confirmation_number_rounded, label: 'Mã booking', value: b.bookingCode, isMono: true),
                    if (b.checkInCode != null)
                      _QrCodeRow(code: b.checkInCode!),
                    if (b.checkedInAt != null) ...[
                      const Divider(height: 16, color: AppColors.borderLight),
                      _Row(
                        icon: Icons.how_to_reg_rounded,
                        label: 'Check-in lúc',
                        value: DateFormat('HH:mm dd/MM').format(b.checkedInAt!),
                        valueColor: AppColors.success,
                      ),
                      if (b.checkedInByName != null)
                        _Row(icon: Icons.person_rounded, label: 'Thực hiện bởi', value: b.checkedInByName!),
                    ],
                    if (b.note != null && b.note!.isNotEmpty) ...[
                      const Divider(height: 16, color: AppColors.borderLight),
                      _Row(icon: Icons.notes_rounded, label: 'Ghi chú', value: b.note!),
                    ],
                  ]),
                ),
                const SizedBox(height: 10),

                // ── Payment ──
                _Card(
                  title: 'Thanh toán',
                  child: Column(children: [
                    _Row(label: 'Tiền sân', value: _fmt(b.subTotal)),
                    if (b.discountAmount > 0)
                      _Row(label: 'Giảm giá', value: '–${_fmt(b.discountAmount)}', valueColor: AppColors.success),
                    if (b.vatAmount > 0)
                      _Row(label: 'Thuế VAT', value: '+${_fmt(b.vatAmount)}', valueColor: AppColors.warning),
                    if (_addons.isNotEmpty)
                      _Row(label: 'Addon', value: _fmt(_addons.fold(0.0, (s, a) => s + a.totalPrice))),
                    const Divider(height: 12, color: AppColors.borderLight),
                    _Row(label: 'Tổng cộng', value: _fmt(b.totalAmount + _addons.fold(0.0, (s, a) => s + a.totalPrice)), isBold: true, valueColor: _brand),
                    _Row(label: 'Phương thức', value: _paymentLabel(b.paymentMethod), valueColor: AppColors.textSecondary),
                  ]),
                ),
                const SizedBox(height: 10),

                // ── Addons ──
                _AddonSection(
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
                      label: const Text('Xác nhận Check-in', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.success, foregroundColor: Colors.white,
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
    id: b.id, bookingCode: b.bookingCode, checkInCode: b.checkInCode,
    courtId: b.courtId, courtName: b.courtName, isIndoor: b.isIndoor,
    venueName: b.venueName, venueAddress: '',
    customerId: b.customerId, customerName: b.customerName, customerPhone: b.customerPhone,
    bookingDate: b.bookingDate, startTime: b.startTime, endTime: b.endTime,
    status: b.status, totalAmount: b.totalAmount,
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

// ── Addon section with Add bottom sheet ──────────────────────────────────────
class _AddonSection extends StatelessWidget {
  final List<StaffBookingAddonModel> addons;
  final List<VenueServiceModel> availableServices;
  final bool canAdd;
  final void Function(StaffBookingAddonModel) onAddonAdded;
  final void Function(String id) onAddonRemoved;

  const _AddonSection({
    required this.addons,
    required this.availableServices,
    required this.canAdd,
    required this.onAddonAdded,
    required this.onAddonRemoved,
  });

  @override
  Widget build(BuildContext context) {
    const brand = Color(0xFF7C3AED);
    return _Card(
      title: addons.isEmpty ? 'Dịch vụ thêm' : 'Dịch vụ thêm (${addons.length})',
      trailing: canAdd
          ? GestureDetector(
              onTap: () => _showAddAddonSheet(context),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: brand.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
                child: const Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(Icons.add_rounded, size: 14, color: brand),
                  SizedBox(width: 4),
                  Text('Thêm', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: brand)),
                ]),
              ),
            )
          : null,
      child: addons.isEmpty
          ? const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Center(child: Text('Chưa có dịch vụ thêm', style: TextStyle(fontSize: 12, color: AppColors.textHint))),
            )
          : Column(
              children: addons.map((a) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Row(children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(color: AppColors.primaryLightBrand.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                    child: const Icon(Icons.shopping_bag_rounded, size: 14, color: AppColors.primaryLightBrand),
                  ),
                  const SizedBox(width: 10),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(a.serviceName, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                    if (a.serviceCategory != null)
                      Text(a.serviceCategory!, style: const TextStyle(fontSize: 10, color: AppColors.textHint)),
                  ])),
                  Text('x${a.quantity}', style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                  const SizedBox(width: 8),
                  Text(_fmtPrice(a.totalPrice), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primaryLightBrand)),
                  if (canAdd) ...[
                    const SizedBox(width: 6),
                    GestureDetector(
                      onTap: () => onAddonRemoved(a.id),
                      child: const Icon(Icons.close_rounded, size: 15, color: AppColors.textHint),
                    ),
                  ],
                ]),
              )).toList(),
            ),
    );
  }

  String _fmtPrice(double v) {
    final n = v.toInt();
    final s = n.toString();
    final result = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) result.write('.');
      result.write(s[i]);
    }
    return '${result}đ';
  }

  void _showAddAddonSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => _AddAddonSheet(
        services: availableServices,
        onAdd: (service, qty) {
          final addon = StaffBookingAddonModel(
            id: 'new_${DateTime.now().millisecondsSinceEpoch}',
            bookingId: '', serviceId: service.id,
            serviceName: service.name, serviceCategory: service.category,
            quantity: qty, pricePerUnit: service.price, totalPrice: service.price * qty,
          );
          onAddonAdded(addon);
          Navigator.pop(ctx);
        },
      ),
    );
  }
}

class _AddAddonSheet extends StatefulWidget {
  final List<VenueServiceModel> services;
  final void Function(VenueServiceModel service, int qty) onAdd;
  const _AddAddonSheet({required this.services, required this.onAdd});

  @override
  State<_AddAddonSheet> createState() => _AddAddonSheetState();
}

class _AddAddonSheetState extends State<_AddAddonSheet> {
  VenueServiceModel? _selected;
  int _qty = 1;

  @override
  Widget build(BuildContext context) {
    const brand = Color(0xFF7C3AED);
    return DraggableScrollableSheet(
      expand: false, initialChildSize: 0.6, maxChildSize: 0.85,
      builder: (_, scroll) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          // Handle
          Container(margin: const EdgeInsets.only(top: 10, bottom: 10), width: 40, height: 4,
            decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2))),
          // Header
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 10),
            child: Row(children: [
              Icon(Icons.add_shopping_cart_rounded, color: Color(0xFF7C3AED), size: 20),
              SizedBox(width: 8),
              Text('Thêm dịch vụ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ]),
          ),
          const Divider(height: 1, color: AppColors.borderLight),
          // Service list
          Expanded(
            child: ListView.builder(
              controller: scroll,
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: widget.services.length,
              itemBuilder: (_, i) {
                final s = widget.services[i];
                final isSelected = _selected?.id == s.id;
                return GestureDetector(
                  onTap: s.isInStock ? () { HapticFeedback.selectionClick(); setState(() { _selected = s; _qty = 1; }); } : null,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isSelected ? brand.withOpacity(0.06) : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: isSelected ? brand.withOpacity(0.6) : AppColors.borderLight, width: isSelected ? 1.5 : 1),
                    ),
                    child: Row(children: [
                      Container(width: 8, height: 8, decoration: BoxDecoration(color: s.isInStock ? AppColors.success : AppColors.error, shape: BoxShape.circle)),
                      const SizedBox(width: 10),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(s.name, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: s.isInStock ? AppColors.textPrimary : AppColors.textHint)),
                        if (s.category != null)
                          Text(s.category!, style: const TextStyle(fontSize: 10, color: AppColors.textHint)),
                      ])),
                      if (!s.isInStock)
                        const Text('Hết hàng', style: TextStyle(fontSize: 10, color: AppColors.error))
                      else
                        Text('${_fmtP(s.price)}/${s.unit.label}', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: isSelected ? brand : AppColors.textPrimary)),
                      if (isSelected) ...[
                        const SizedBox(width: 8),
                        const Icon(Icons.check_circle_rounded, color: Color(0xFF7C3AED), size: 18),
                      ],
                    ]),
                  ),
                );
              },
            ),
          ),
          // Qty + confirm
          if (_selected != null) Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 10, offset: const Offset(0, -3))]),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Row(children: [
                Expanded(child: Text(_selected!.name, style: const TextStyle(fontWeight: FontWeight.bold))),
                // Qty spinner
                Row(children: [
                  _QtyBtn(icon: Icons.remove_rounded, onTap: _qty > 1 ? () => setState(() => _qty--) : null),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: Text('$_qty', style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                  ),
                  _QtyBtn(icon: Icons.add_rounded, onTap: () => setState(() => _qty++)),
                ]),
              ]),
              const SizedBox(height: 8),
              Row(children: [
                Text('Tổng: ${_fmtP(_selected!.price * _qty)}đ', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: brand)),
                const Spacer(),
                ElevatedButton(
                  onPressed: () { HapticFeedback.mediumImpact(); widget.onAdd(_selected!, _qty); },
                  style: ElevatedButton.styleFrom(backgroundColor: brand, elevation: 0, padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                  child: const Text('Thêm vào', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ]),
            ]),
          ),
        ]),
      ),
    );
  }

  String _fmtP(double v) {
    if (v >= 1000) return '${(v/1000).round()}K';
    return v.toStringAsFixed(0);
  }
}

class _QtyBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  const _QtyBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      width: 30, height: 30,
      decoration: BoxDecoration(color: onTap != null ? const Color(0xFF7C3AED).withOpacity(0.1) : AppColors.borderLight, borderRadius: BorderRadius.circular(8)),
      child: Icon(icon, size: 16, color: onTap != null ? const Color(0xFF7C3AED) : AppColors.textHint),
    ),
  );
}

// ── QR code display row ──────────────────────────────────────────────────────
class _QrCodeRow extends StatelessWidget {
  final String code;
  const _QrCodeRow({required this.code});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(children: [
      const Icon(Icons.qr_code_2_rounded, size: 16, color: AppColors.textHint),
      const SizedBox(width: 10),
      const Text('Mã QR Check-in', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
      const Spacer(),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(color: const Color(0xFF7C3AED).withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
        child: Text(code, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900, fontFamily: 'monospace', color: Color(0xFF7C3AED), letterSpacing: 2)),
      ),
      const SizedBox(width: 6),
      GestureDetector(
        onTap: () { HapticFeedback.selectionClick(); },
        child: const Icon(Icons.copy_rounded, size: 14, color: AppColors.textHint),
      ),
    ]),
  );
}

// ── Common sub-widgets ────────────────────────────────────────────────────────
class _StatusBanner extends StatelessWidget {
  final BookingStatusVS status;
  const _StatusBanner({required this.status});

  @override
  Widget build(BuildContext context) {
    final (color, icon, label) = switch (status) {
      BookingStatusVS.CONFIRMED  => (AppColors.info, Icons.event_available_rounded, 'Đã xác nhận — Chưa check-in'),
      BookingStatusVS.CHECKED_IN => (AppColors.success, Icons.how_to_reg_rounded, '✅ Đã check-in thành công'),
      BookingStatusVS.COMPLETED  => (AppColors.textHint, Icons.done_all_rounded, 'Đã hoàn thành'),
      BookingStatusVS.PENDING    => (AppColors.warning, Icons.hourglass_empty_rounded, 'Chờ xác nhận'),
      BookingStatusVS.CANCELLED  => (AppColors.error, Icons.cancel_outlined, 'Đã huỷ'),
      BookingStatusVS.NO_SHOW    => (AppColors.error, Icons.person_off_rounded, '⚠️ Vắng mặt (No-show)'),
    };
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12), border: Border.all(color: color.withOpacity(0.3))),
      child: Row(children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 10),
        Text(label, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 13)),
      ]),
    );
  }
}

class _Card extends StatelessWidget {
  final String? title;
  final Widget? trailing;
  final Widget child;
  const _Card({this.title, this.trailing, required this.child});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)]),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      if (title != null) ...[
        Row(children: [
          Text(title!, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textHint, letterSpacing: 0.4)),
          if (trailing != null) ...[const Spacer(), trailing!],
        ]),
        const Divider(height: 14, color: AppColors.borderLight),
      ],
      child,
    ]),
  );
}

class _Row extends StatelessWidget {
  final IconData? icon;
  final String label;
  final String value;
  final Color? valueColor;
  final bool isMono;
  final bool isBold;
  const _Row({this.icon, required this.label, required this.value, this.valueColor, this.isMono = false, this.isBold = false});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: Row(children: [
      if (icon != null) ...[Icon(icon, size: 14, color: AppColors.textHint), const SizedBox(width: 8)],
      Expanded(child: Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary))),
      Text(value, style: TextStyle(fontSize: isBold ? 14 : 12, fontWeight: isBold ? FontWeight.w900 : FontWeight.w600, color: valueColor ?? AppColors.textPrimary, fontFamily: isMono ? 'monospace' : null)),
    ]),
  );
}
