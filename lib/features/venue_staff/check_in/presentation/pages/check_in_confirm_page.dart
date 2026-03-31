import 'package:dat_san_247_mobile/routes/base/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/core/base/di/injection.dart';
import 'package:dat_san_247_mobile/core/services/manager/toast_service.dart';
import 'package:dat_san_247_mobile/features/venue_staff/check_in/data/models/check_in_models.dart';
import 'package:dat_san_247_mobile/features/venue_staff/schedule/data/services/staff_schedule_service.dart';

@route
class CheckInConfirmPage extends StatefulWidget {
  final CheckInBookingModel booking;

  const CheckInConfirmPage({super.key, required this.booking});

  @override
  State<CheckInConfirmPage> createState() => _CheckInConfirmPageState();
}

class _CheckInConfirmPageState extends State<CheckInConfirmPage>
    with SingleTickerProviderStateMixin {
  static const Color _brand = Color(0xFF7C3AED);
  bool _isConfirming = false;
  bool _isCheckedIn = false;
  late AnimationController _successCtrl;

  @override
  void initState() {
    super.initState();
    _successCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
  }

  @override
  void dispose() {
    _successCtrl.dispose();
    super.dispose();
  }

  Future<void> _updateStatus(BookingStatusVS status) async {
    await HapticFeedback.mediumImpact();
    setState(() => _isConfirming = true);

    try {
      final service = getIt<StaffScheduleService>();
      await service.updateStatus(widget.booking.id, {'status': status.name});

      if (!mounted) return;
      
      if (status == BookingStatusVS.CHECKED_IN) {
        setState(() {
          _isConfirming = false;
          _isCheckedIn = true;
        });
        await _successCtrl.forward();
        toast.success('Check-in thành công cho ${widget.booking.customerName}');
      } else {
        toast.warning('Đã đánh dấu vắng mặt cho ${widget.booking.customerName}');
        Navigator.pop(context, true); // true indicates status changed
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isConfirming = false);
      toast.error('Có lỗi xảy ra: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final b = widget.booking;
    final isValid = b.isValidForCheckIn;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: AppBar(
        backgroundColor: _brand,
        elevation: 0,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
            onPressed: () => Navigator.pop(context)),
        title: Text(_isCheckedIn ? '✅ Check-in thành công' : 'Xác nhận Check-in',
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
      ),
      body: _isCheckedIn ? _buildSuccess() : _buildConfirm(b, isValid),
    );
  }

  Widget _buildSuccess() {
    final b = widget.booking;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SizedBox(height: 20),
          ScaleTransition(
            scale: CurvedAnimation(parent: _successCtrl, curve: Curves.elasticOut),
            child: Container(
              width: 110,
              height: 110,
              decoration: const BoxDecoration(color: AppColors.success, shape: BoxShape.circle),
              child: const Icon(Icons.check_rounded, color: Colors.white, size: 60),
            ),
          ),
          const SizedBox(height: 20),
          const Text('Check-in thành công!',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
          const SizedBox(height: 6),
          Text('${b.customerName} vào lúc ${DateFormat('HH:mm').format(DateTime.now())}',
              style: const TextStyle(color: AppColors.textSecondary)),
          const SizedBox(height: 24),
          _BriefCard(booking: b),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              icon: const Icon(Icons.qr_code_scanner_rounded),
              label: const Text('Quét tiếp', style: TextStyle(fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: _brand,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfirm(CheckInBookingModel b, bool isValid) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // ── Validation banner ──
          if (!isValid)
            Container(
              margin: const EdgeInsets.only(bottom: 14),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                  color: AppColors.error.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.error.withOpacity(0.4))),
              child: Row(children: [
                const Icon(Icons.warning_amber_rounded, color: AppColors.error, size: 22),
                const SizedBox(width: 10),
                Expanded(
                    child: Text(b.validationError,
                        style: const TextStyle(
                            color: AppColors.error, fontWeight: FontWeight.bold, fontSize: 13))),
              ]),
            ),

          // ── Customer card ──
          _InfoCard(
            child: Row(children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: _brand.withValues(alpha: 0.15),
                child: Text(b.customerName[0],
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: _brand)),
              ),
              const SizedBox(width: 14),
              Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(b.customerName,
                    style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                if (b.customerPhone != null)
                  Row(children: [
                    const Icon(Icons.phone_rounded, size: 13, color: AppColors.textHint),
                    const SizedBox(width: 4),
                    Text(b.customerPhone!,
                        style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                  ]),
              ])),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                    color: AppColors.success.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20)),
                child: const Text('Đã xác nhận',
                    style: TextStyle(
                        fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.success)),
              ),
            ]),
          ),
          const SizedBox(height: 12),

          // ── Booking details ──
          _InfoCard(
            title: 'Thông tin đặt sân',
            child: Column(children: [
              _DetailRow(
                  icon: Icons.sports_soccer_rounded,
                  label: 'Sân',
                  value: b.courtName,
                  valueColor: _brand),
              _DetailRow(icon: Icons.stadium_rounded, label: 'Venue', value: b.venueName),
              _DetailRow(
                  icon: Icons.event_rounded,
                  label: 'Ngày',
                  value: DateFormat('EEEE, dd/MM/yyyy', 'vi').format(b.bookingDate)),
              _DetailRow(
                  icon: Icons.access_time_rounded,
                  label: 'Giờ chơi',
                  value: '${b.startTime} → ${b.endTime}',
                  valueColor: _brand),
              _DetailRow(
                  icon: Icons.confirmation_number_rounded,
                  label: 'Mã booking',
                  value: b.bookingCode,
                  isMono: true),
              if (b.checkInCode != null)
                _DetailRow(
                    icon: Icons.qr_code_rounded,
                    label: 'Mã QR',
                    value: b.checkInCode!,
                    isMono: true),
              _DetailRow(
                  icon: Icons.payments_rounded,
                  label: 'Tổng tiền',
                  value: _fmt(b.totalAmount),
                  valueColor: AppColors.primaryLightBrand,
                  isBold: true),
            ]),
          ),
          const SizedBox(height: 12),

          // ── Addons ──
          if (b.addons.isNotEmpty) ...[
            _InfoCard(
              title: 'Dịch vụ đã đặt (${b.addons.length})',
              child: Column(
                children: b.addons.map((addon) => _AddonRow(addon: addon)).toList(),
              ),
            ),
            const SizedBox(height: 12),
          ],

          // ── Confirm button ──
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: (!isValid || _isConfirming) ? null : () => _updateStatus(BookingStatusVS.CHECKED_IN),
              style: ElevatedButton.styleFrom(
                backgroundColor: isValid ? AppColors.success : AppColors.textHint,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                disabledBackgroundColor: AppColors.textHint.withValues(alpha: 0.5),
              ),
              child: _isConfirming
                  ? const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)),
                      SizedBox(width: 12),
                      Text('Đang xử lý...',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    ])
                  : Text(isValid ? '✅ Xác Nhận Check-in' : '⚠️ Không thể Check-in',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            ),
          ),
          const SizedBox(height: 12),
          // ── No Show button ──
          if (isValid && !_isConfirming)
            SizedBox(
              width: double.infinity,
              child: TextButton.icon(
                onPressed: () => _showNoShowConfirmation(),
                icon: const Icon(Icons.person_off_rounded, color: AppColors.error, size: 20),
                label: const Text('Khách vắng mặt (No-Show)',
                    style: TextStyle(color: AppColors.error, fontWeight: FontWeight.bold)),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: AppColors.textHint.withOpacity(0.5)),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: const Text('Quay lại',
                  style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textSecondary)),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  void _showNoShowConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận vắng mặt'),
        content: Text('Bạn có chắc muốn đánh dấu khách ${widget.booking.customerName} là vắng mặt (No-Show)?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Huỷ')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _updateStatus(BookingStatusVS.NO_SHOW);
            },
            child: const Text('Xác nhận', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }

  String _fmt(double v) {
    final n = v.toInt();
    String s = n.toString();
    final result = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) result.write('.');
      result.write(s[i]);
    }
    return '${result.toString()}đ';
  }
}

// ── Sub-widgets for CheckInConfirmPage ────────────────────────────────────
class _InfoCard extends StatelessWidget {
  final String? title;
  final Widget child;
  const _InfoCard({this.title, required this.child});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (title != null) ...[
              Text(title!,
                  style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textHint,
                      letterSpacing: 0.5)),
              const Divider(height: 16, color: AppColors.borderLight),
            ],
            child,
          ],
        ),
      );
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;
  final bool isMono;
  final bool isBold;
  const _DetailRow(
      {required this.icon,
      required this.label,
      required this.value,
      this.valueColor,
      this.isMono = false,
      this.isBold = false});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(children: [
          Icon(icon, size: 16, color: AppColors.textHint),
          const SizedBox(width: 10),
          Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
          const Spacer(),
          Text(value,
              style: TextStyle(
                fontSize: isBold ? 15 : 12,
                fontWeight: isBold ? FontWeight.w900 : FontWeight.w600,
                color: valueColor ?? AppColors.textPrimary,
                fontFamily: isMono ? 'monospace' : null,
                letterSpacing: isMono ? 1.0 : null,
              )),
        ]),
      );
}

class _AddonRow extends StatelessWidget {
  final StaffBookingAddonModel addon;
  const _AddonRow({required this.addon});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
                color: AppColors.primaryLightBrand.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8)),
            child: const Icon(Icons.add_shopping_cart_rounded,
                size: 14, color: AppColors.primaryLightBrand),
          ),
          const SizedBox(width: 10),
          Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(addon.serviceName,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
            if (addon.serviceCategory != null)
              Text(addon.serviceCategory!,
                  style: const TextStyle(fontSize: 10, color: AppColors.textHint)),
          ])),
          Text('x${addon.quantity}',
              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
          const SizedBox(width: 8),
          Text(_fmt(addon.totalPrice),
              style: const TextStyle(
                  fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primaryLightBrand)),
        ]),
      );

  String _fmt(double v) {
    final n = v.toInt();
    String s = n.toString();
    final result = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) result.write('.');
      result.write(s[i]);
    }
    return '${result.toString()}đ';
  }
}

class _BriefCard extends StatelessWidget {
  final CheckInBookingModel booking;
  const _BriefCard({required this.booking});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.success.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.success.withOpacity(0.3)),
        ),
        child: Column(children: [
          _BriefRow(icon: Icons.person_rounded, label: 'Khách', value: booking.customerName),
          _BriefRow(icon: Icons.sports_soccer_rounded, label: 'Sân', value: booking.courtName),
          _BriefRow(
              icon: Icons.access_time_rounded,
              label: 'Giờ',
              value: '${booking.startTime} – ${booking.endTime}'),
        ]),
      );
}

class _BriefRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _BriefRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(children: [
          Icon(icon, size: 16, color: AppColors.textHint),
          const SizedBox(width: 10),
          Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
          const Spacer(),
          Text(value,
              style: const TextStyle(
                  fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
        ]),
      );
}
