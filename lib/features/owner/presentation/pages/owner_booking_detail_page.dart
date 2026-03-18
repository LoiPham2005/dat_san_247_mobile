import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/features/owner/data/models/owner_extended_models.dart';

// ══════════════════════════════════════════════════════════════════════════════
// O-09: Chi Tiết Booking (Owner View)
// DB: bookings, booking_addons, booking_status_history, payments,
//     users, commission_records
// ══════════════════════════════════════════════════════════════════════════════
class OwnerBookingDetailPage extends StatefulWidget {
  final String bookingId;
  final OwnerBookingModel booking;
  const OwnerBookingDetailPage({super.key, required this.bookingId, required this.booking});
  @override
  State<OwnerBookingDetailPage> createState() => _OwnerBookingDetailPageState();
}

class _OwnerBookingDetailPageState extends State<OwnerBookingDetailPage> {
  static const Color _brand = Color(0xFF0891B2);
  static const Color _brandDark = Color(0xFF0E7490);
  late OwnerBookingModel _booking;

  final _mockAddons = [
    const OwnerBookingAddonModel(id:'a1', serviceName:'Nước suối', quantity:4, pricePerUnit:10000, totalPrice:40000),
    const OwnerBookingAddonModel(id:'a2', serviceName:'Thuê giày', quantity:2, pricePerUnit:30000, totalPrice:60000),
  ];

  @override
  void initState() { super.initState(); _booking = widget.booking; }

  @override
  Widget build(BuildContext context) {
    final statusColor = switch (_booking.status) {
      BookingStatus.PENDING    => AppColors.warning,
      BookingStatus.CONFIRMED  => AppColors.info,
      BookingStatus.CHECKED_IN => _brand,
      BookingStatus.COMPLETED  => AppColors.success,
      BookingStatus.CANCELLED  => AppColors.error,
      BookingStatus.NO_SHOW    => AppColors.textHint,
    };
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      body: CustomScrollView(slivers: [
        // ── AppBar ──
        SliverAppBar(
          pinned: true, expandedHeight: 140, backgroundColor: _brand,
          leading: IconButton(icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white, size: 18), onPressed: () => Navigator.pop(context)),
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              decoration: const BoxDecoration(gradient: LinearGradient(colors: [_brandDark, _brand], begin: Alignment.topLeft, end: Alignment.bottomRight)),
              child: SafeArea(child: Padding(padding: const EdgeInsets.fromLTRB(20, 46, 20, 0), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(_booking.bookingCode, style: const TextStyle(color: Colors.white70, fontSize: 11, letterSpacing: 1)),
                Text(_booking.customerName, style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w900)),
                const SizedBox(height: 8),
                Row(children: [
                  Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: statusColor.withOpacity(0.25), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white.withOpacity(0.3))),
                    child: Row(children: [Text(_booking.status.emoji, style: const TextStyle(fontSize: 11)), const SizedBox(width: 4), Text(_booking.status.label, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold))])),
                  const SizedBox(width: 10),
                  Text('${_fmt(_booking.totalAmount)} đ', style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w900)),
                ]),
              ]))),
            ),
            title: Text(_booking.bookingCode, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
          ),
        ),

        SliverToBoxAdapter(child: Padding(padding: const EdgeInsets.all(12), child: Column(children: [
          // ── Booking info ──
          _Card('Thông Tin Đặt Sân', Icons.event_rounded, _brand, [
            _InfoRow(Icons.sports_soccer_rounded, 'Sân', _booking.courtName, _brand),
            _InfoRow(Icons.calendar_today_rounded, 'Ngày', DateFormat('dd/MM/yyyy EEE', 'vi').format(_booking.bookingDate), AppColors.textPrimary),
            _InfoRow(Icons.access_time_rounded, 'Giờ', '${_booking.startTime} – ${_booking.endTime} (${_booking.totalHours.toStringAsFixed(1)}h)', AppColors.textPrimary),
            if (_booking.note != null) _InfoRow(Icons.notes_rounded, 'Ghi chú', _booking.note!, AppColors.textHint),
          ]),
          const SizedBox(height: 10),

          // ── Customer ──
          _Card('Khách Hàng', Icons.person_rounded, AppColors.info, [
            _InfoRow(Icons.person_rounded, 'Họ tên', _booking.customerName, AppColors.textPrimary),
            if (_booking.customerPhone != null) _InfoRow(Icons.phone_rounded, 'SĐT', _booking.customerPhone!, AppColors.info),
            if (_booking.checkInCode != null) _InfoRow(Icons.qr_code_rounded, 'Mã check-in', _booking.checkInCode!, _brand),
          ]),
          const SizedBox(height: 10),

          // ── Addons ──
          _Card('Dịch Vụ Đã Dùng (${_mockAddons.length})', Icons.room_service_rounded, AppColors.warning, [
            ..._mockAddons.map((a) => Padding(padding: const EdgeInsets.symmetric(vertical: 4), child: Row(children: [
              const Icon(Icons.check_circle_outline_rounded, size: 14, color: AppColors.warning),
              const SizedBox(width: 8),
              Expanded(child: Text('${a.serviceName} × ${a.quantity}', style: const TextStyle(fontSize: 12))),
              Text('${_fmt(a.totalPrice)} đ', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            ]))),
          ]),
          const SizedBox(height: 10),

          // ── Payment breakdown ──
          _Card('Thanh Toán', Icons.receipt_long_rounded, AppColors.success, [
            _AmtRow('Tiền sân', _booking.subTotal),
            _AmtRow('Dịch vụ', _mockAddons.fold(0.0, (sum, a) => sum + a.totalPrice)),
            if (_booking.discountAmount > 0) _AmtRow('Giảm giá', -_booking.discountAmount, color: AppColors.success),
            if (_booking.vatAmount > 0) _AmtRow('VAT', _booking.vatAmount),
            const Divider(height: 12, color: AppColors.borderLight),
            _AmtRow('Tổng', _booking.totalAmount, bold: true),
            const SizedBox(height: 6),
            _AmtRow('Hoa hồng platform', _booking.commissionAmount, color: AppColors.error),
            _AmtRow('Thực nhận', _booking.ownerReceives, bold: true, color: AppColors.success),
          ]),
          const SizedBox(height: 16),

          // ── Action buttons ──
          if (_booking.canConfirm) _ActionBtn('✅ Xác Nhận Booking', AppColors.success, () => _confirmBooking()),
          if (_booking.canCancel && _booking.status != BookingStatus.PENDING) const SizedBox(height: 10),
          if (_booking.canCancel) _ActionBtn('❌ Hủy Booking', AppColors.error, () => _showCancelSheet(context), outlined: true),
          const SizedBox(height: 20),
        ]))),
      ]),
    );
  }

  void _confirmBooking() {
    showDialog(context: context, builder: (ctx) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text('Xác nhận booking?', style: TextStyle(fontWeight: FontWeight.bold)),
      content: Text('Xác nhận booking #${_booking.bookingCode} cho ${_booking.customerName}?'),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Huỷ')),
        ElevatedButton(onPressed: () { Navigator.pop(ctx); setState(() { _booking = OwnerBookingModel(id:_booking.id, bookingCode:_booking.bookingCode, checkInCode:_booking.checkInCode, customerId:_booking.customerId, customerName:_booking.customerName, customerPhone:_booking.customerPhone, courtId:_booking.courtId, courtName:_booking.courtName, venueId:_booking.venueId, bookingDate:_booking.bookingDate, startTime:_booking.startTime, endTime:_booking.endTime, status:BookingStatus.CONFIRMED, totalHours:_booking.totalHours, pricePerHour:_booking.pricePerHour, subTotal:_booking.subTotal, discountAmount:_booking.discountAmount, vatAmount:_booking.vatAmount, totalAmount:_booking.totalAmount, commissionAmount:_booking.commissionAmount, note:_booking.note, createdAt:_booking.createdAt); }); HapticFeedback.mediumImpact(); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('✅ Đã xác nhận booking'), backgroundColor: AppColors.success)); },
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.success, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
          child: const Text('Xác nhận', style: TextStyle(color: Colors.white))),
      ],
    ));
  }

  void _showCancelSheet(BuildContext context) {
    final reasonCtrl = TextEditingController();
    showModalBottomSheet(context: context, isScrollControlled: true, shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom), child: Padding(padding: const EdgeInsets.all(20), child: Column(mainAxisSize: MainAxisSize.min, children: [
        Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)))),
        const SizedBox(height: 14),
        const Icon(Icons.cancel_rounded, color: AppColors.error, size: 36),
        const SizedBox(height: 8),
        const Text('Hủy Booking', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text('Booking #${_booking.bookingCode}', style: const TextStyle(fontSize: 12, color: AppColors.textHint)),
        const SizedBox(height: 16),
        Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: AppColors.warning.withOpacity(0.08), borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.warning.withOpacity(0.3))),
          child: const Text('Hủy booking có thể kích hoạt hoàn tiền theo chính sách đã thiết lập.', style: TextStyle(fontSize: 11, color: AppColors.warning))),
        const SizedBox(height: 12),
        TextField(controller: reasonCtrl, maxLines: 2, decoration: InputDecoration(labelText: 'Lý do hủy *', border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)))),
        const SizedBox(height: 16),
        SizedBox(width: double.infinity, child: ElevatedButton(
          onPressed: () { if (reasonCtrl.text.isEmpty) return; Navigator.pop(ctx); setState(() { _booking = OwnerBookingModel(id:_booking.id, bookingCode:_booking.bookingCode, customerId:_booking.customerId, customerName:_booking.customerName, courtId:_booking.courtId, courtName:_booking.courtName, venueId:_booking.venueId, bookingDate:_booking.bookingDate, startTime:_booking.startTime, endTime:_booking.endTime, status:BookingStatus.CANCELLED, totalHours:_booking.totalHours, pricePerHour:_booking.pricePerHour, subTotal:_booking.subTotal, totalAmount:_booking.totalAmount, commissionAmount:_booking.commissionAmount, createdAt:_booking.createdAt); }); HapticFeedback.mediumImpact(); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đã hủy booking'), backgroundColor: AppColors.error)); },
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.error, elevation: 0, padding: const EdgeInsets.symmetric(vertical: 13), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
          child: const Text('Xác Nhận Hủy', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        )),
      ]))),
    );
  }

  String _fmt(double v) { if (v >= 1000000) return '${(v/1000000).toStringAsFixed(1)}M'; if (v >= 1000) return '${(v/1000).round()}K'; return v.toStringAsFixed(0); }
}

// ── Shared widgets ────────────────────────────────────────────────────────────
class _Card extends StatelessWidget {
  final String title; final IconData icon; final Color color; final List<Widget> children;
  const _Card(this.title, this.icon, this.color, this.children);
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)]),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [Icon(icon, size: 14, color: color), const SizedBox(width: 6), Text(title, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: color))]),
      const Divider(height: 12, color: AppColors.borderLight),
      ...children,
    ]),
  );
}

class _InfoRow extends StatelessWidget {
  final IconData icon; final String label, value; final Color color;
  const _InfoRow(this.icon, this.label, this.value, this.color);
  @override
  Widget build(BuildContext context) => Padding(padding: const EdgeInsets.symmetric(vertical: 4), child: Row(children: [
    Icon(icon, size: 13, color: color), const SizedBox(width: 8),
    SizedBox(width: 80, child: Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary))),
    Expanded(child: Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis)),
  ]));
}

class _AmtRow extends StatelessWidget {
  final String label; final double amount; final bool bold; final Color? color;
  const _AmtRow(this.label, this.amount, {this.bold = false, this.color});
  @override
  Widget build(BuildContext context) {
    final c = color ?? AppColors.textPrimary;
    String fmt(double v) { if (v.abs() >= 1000000) return '${(v/1000000).toStringAsFixed(1)}M'; if (v.abs() >= 1000) return '${(v/1000).round()}K'; return v.toStringAsFixed(0); }
    return Padding(padding: const EdgeInsets.symmetric(vertical: 3), child: Row(children: [
      Expanded(child: Text(label, style: TextStyle(fontSize: 12, fontWeight: bold ? FontWeight.bold : FontWeight.normal, color: c))),
      Text('${amount < 0 ? '-' : ''}${fmt(amount.abs())} đ', style: TextStyle(fontSize: 12, fontWeight: bold ? FontWeight.bold : FontWeight.normal, color: c)),
    ]));
  }
}

class _ActionBtn extends StatelessWidget {
  final String label; final Color color; final VoidCallback onTap; final bool outlined;
  const _ActionBtn(this.label, this.color, this.onTap, {this.outlined = false});
  @override
  Widget build(BuildContext context) => SizedBox(width: double.infinity, child: outlined
    ? OutlinedButton(onPressed: () { HapticFeedback.mediumImpact(); onTap(); }, style: OutlinedButton.styleFrom(side: BorderSide(color: color), padding: const EdgeInsets.symmetric(vertical: 13), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), child: Text(label, style: TextStyle(color: color, fontWeight: FontWeight.bold)))
    : ElevatedButton(onPressed: () { HapticFeedback.mediumImpact(); onTap(); }, style: ElevatedButton.styleFrom(backgroundColor: color, elevation: 0, padding: const EdgeInsets.symmetric(vertical: 13), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), child: Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))));
}
