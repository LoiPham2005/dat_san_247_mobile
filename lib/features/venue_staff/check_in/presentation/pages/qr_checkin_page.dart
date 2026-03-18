import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/features/venue_staff/check_in/data/models/check_in_models.dart';
import 'package:intl/intl.dart';

// ──────────────────────────────────────────────────────────────────────────
// VS-02: QR Scanner Check-in page
// ──────────────────────────────────────────────────────────────────────────
class QrCheckInPage extends StatefulWidget {
  const QrCheckInPage({super.key});

  @override
  State<QrCheckInPage> createState() => _QrCheckInPageState();
}

class _QrCheckInPageState extends State<QrCheckInPage>
    with SingleTickerProviderStateMixin {
  static const Color _brand = Color(0xFF7C3AED);

  bool _isLoading = false;
  String? _errorMsg;
  bool _showManual = false;
  final _manualCtrl = TextEditingController();

  // Scan line animation
  late final AnimationController _animCtrl;
  late final Animation<double> _scanAnim;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat(reverse: true);
    _scanAnim = Tween<double>(begin: 0.1, end: 0.85).animate(CurvedAnimation(parent: _animCtrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    _manualCtrl.dispose();
    super.dispose();
  }

  // ── Simulate QR scan ──────────────────────────────────────────────────
  void _simulateScan() async {
    HapticFeedback.mediumImpact();
    setState(() { _isLoading = true; _errorMsg = null; });
    await Future.delayed(const Duration(milliseconds: 800));

    // Mock: found booking
    final mockBooking = CheckInBookingModel(
      id: 'b-demo-001',
      bookingCode: 'DS24799101',
      checkInCode: 'ABCD1234',
      courtId: 'c1',
      courtName: 'Sân A - 5 người',
      isIndoor: false,
      venueName: 'Sân K34 Phạm Văn Đồng',
      venueAddress: '34 Phạm Văn Đồng, Cầu Giấy, Hà Nội',
      customerId: 'u1',
      customerName: 'Nguyễn Văn An',
      customerPhone: '0912345678',
      bookingDate: DateTime.now(),
      startTime: '18:00',
      endTime: '19:30',
      status: BookingStatusVS.CONFIRMED,
      totalAmount: 225000,
      paymentMethod: 'WALLET',
      addons: [
        StaffBookingAddonModel(id: 'a1', bookingId: 'b-demo-001', serviceId: 's1', serviceName: 'Nước Pocari', serviceCategory: 'Đồ uống', quantity: 2, pricePerUnit: 15000, totalPrice: 30000),
        StaffBookingAddonModel(id: 'a2', bookingId: 'b-demo-001', serviceId: 's2', serviceName: 'Bóng đá size 5', serviceCategory: 'Thiết bị', quantity: 1, pricePerUnit: 20000, totalPrice: 20000),
      ],
    );

    setState(() => _isLoading = false);
    if (!mounted) return;
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => CheckInConfirmPage(booking: mockBooking),
    ));
  }

  // ── Manual lookup ──────────────────────────────────────────────────────
  void _manualLookup() async {
    final code = _manualCtrl.text.trim().toUpperCase();
    if (code.isEmpty) return;
    HapticFeedback.selectionClick();
    setState(() { _isLoading = true; _errorMsg = null; });
    await Future.delayed(const Duration(milliseconds: 600));

    if (code == 'DS24799101' || code == 'ABCD1234') {
      _simulateScan();
      return;
    }
    setState(() {
      _isLoading = false;
      _errorMsg = 'Không tìm thấy booking với mã "$code"';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F1A),
      body: Stack(
        children: [
          // ── Fake camera background ──
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF0F0F1A), Color(0xFF1A0D2E)],
                  begin: Alignment.topCenter, end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),

          // ── Camera grid overlay (decorative) ──
          Positioned.fill(
            child: CustomPaint(painter: _GridPainter()),
          ),

          // ── QR Square frame ──
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 60),
                _QrFrame(scanAnim: _scanAnim, brand: _brand, isLoading: _isLoading),
              ],
            ),
          ),

          // ── SafeArea content ──
          SafeArea(
            child: Column(
              children: [
                // AppBar area
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => context.pop(),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
                          child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 18),
                        ),
                      ),
                      const SizedBox(width: 14),
                      const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('Quét QR Check-in', style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold)),
                        Text('Hướng camera vào mã QR của khách', style: TextStyle(color: Colors.white60, fontSize: 11)),
                      ]),
                      const Spacer(),
                      // Flashlight toggle (mock)
                      GestureDetector(
                        onTap: () => HapticFeedback.selectionClick(),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
                          child: const Icon(Icons.flash_on_rounded, color: Colors.white, size: 20),
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // ── Bottom panel ──
                Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A2E).withOpacity(0.95),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: _brand.withOpacity(0.3)),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // ── Simulate scan button ──
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _isLoading ? null : _simulateScan,
                          icon: _isLoading
                              ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                              : const Icon(Icons.qr_code_scanner_rounded, size: 20),
                          label: Text(_isLoading ? 'Đang tìm...' : '✨ Simulate Scan (Demo)', style: const TextStyle(fontWeight: FontWeight.bold)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _brand,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            elevation: 0,
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Row(children: [
                        Expanded(child: Divider(color: Colors.white.withOpacity(0.15))),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text('hoặc nhập thủ công', style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 11)),
                        ),
                        Expanded(child: Divider(color: Colors.white.withOpacity(0.15))),
                      ]),
                      const SizedBox(height: 14),

                      // ── Manual input ──
                      AnimatedCrossFade(
                        duration: const Duration(milliseconds: 250),
                        crossFadeState: _showManual ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                        firstChild: SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: () => setState(() => _showManual = true),
                            icon: const Icon(Icons.keyboard_rounded, size: 18, color: Colors.white70),
                            label: const Text('Nhập mã booking / QR', style: TextStyle(color: Colors.white70)),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: Colors.white.withOpacity(0.25)),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                        ),
                        secondChild: Column(
                          children: [
                            Row(children: [
                              Expanded(
                                child: TextField(
                                  controller: _manualCtrl,
                                  autofocus: false,
                                  textCapitalization: TextCapitalization.characters,
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.5),
                                  decoration: InputDecoration(
                                    hintText: 'DS24799101 hoặc ABCD1234',
                                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 12),
                                    filled: true,
                                    fillColor: Colors.white.withOpacity(0.08),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: _brand.withOpacity(0.5))),
                                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.white.withOpacity(0.2))),
                                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: _brand, width: 1.5)),
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                    prefixIcon: const Icon(Icons.tag_rounded, color: Colors.white54, size: 18),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              ElevatedButton(
                                onPressed: _isLoading ? null : _manualLookup,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _brand, foregroundColor: Colors.white, elevation: 0,
                                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                ),
                                child: const Icon(Icons.search_rounded, size: 22),
                              ),
                            ]),
                            if (_errorMsg != null) ...[
                              const SizedBox(height: 10),
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(color: AppColors.error.withOpacity(0.15), borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.error.withOpacity(0.4))),
                                child: Row(children: [
                                  const Icon(Icons.error_outline_rounded, color: AppColors.error, size: 16),
                                  const SizedBox(width: 8),
                                  Expanded(child: Text(_errorMsg!, style: const TextStyle(color: AppColors.error, fontSize: 12))),
                                ]),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── QR Frame widget ─────────────────────────────────────────────────────
class _QrFrame extends StatelessWidget {
  final Animation<double> scanAnim;
  final Color brand;
  final bool isLoading;
  const _QrFrame({required this.scanAnim, required this.brand, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    const size = 260.0;
    return SizedBox(
      width: size, height: size,
      child: Stack(
        children: [
          // Corner decorations
          Positioned(top: 0, left: 0, child: _Corner(color: brand, rotation: 0)),
          Positioned(top: 0, right: 0, child: _Corner(color: brand, rotation: 90)),
          Positioned(bottom: 0, right: 0, child: _Corner(color: brand, rotation: 180)),
          Positioned(bottom: 0, left: 0, child: _Corner(color: brand, rotation: 270)),
          // Dark overlay inside frame
          Positioned(top: 16, left: 16, right: 16, bottom: 16,
            child: Container(color: Colors.black.withOpacity(0.3)),
          ),
          // Scan line
          if (!isLoading)
            AnimatedBuilder(
              animation: scanAnim,
              builder: (_, __) => Positioned(
                top: 16 + (size - 32) * scanAnim.value,
                left: 16, right: 16, height: 2,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [Colors.transparent, brand, Colors.transparent]),
                    boxShadow: [BoxShadow(color: brand.withOpacity(0.6), blurRadius: 6)],
                  ),
                ),
              ),
            )
          else
            const Positioned.fill(
              child: Center(child: CircularProgressIndicator(color: Colors.white)),
            ),
        ],
      ),
    );
  }
}

class _Corner extends StatelessWidget {
  final Color color;
  final double rotation;
  const _Corner({required this.color, required this.rotation});

  @override
  Widget build(BuildContext context) => Transform.rotate(
    angle: rotation * 3.14159 / 180,
    child: SizedBox(width: 28, height: 28,
      child: CustomPaint(painter: _CornerPainter(color: color)),
    ),
  );
}

class _CornerPainter extends CustomPainter {
  final Color color;
  const _CornerPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color..strokeWidth = 4..strokeCap = StrokeCap.round..style = PaintingStyle.stroke;
    canvas.drawLine(Offset(0, size.height), const Offset(0, 0), paint);
    canvas.drawLine(const Offset(0, 0), Offset(size.width, 0), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withOpacity(0.04)..strokeWidth = 0.5;
    const spacing = 50.0;
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

// ──────────────────────────────────────────────────────────────────────────
// VS-03: Check-in Confirmation page
// ──────────────────────────────────────────────────────────────────────────
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

  Future<void> _doCheckIn() async {
    HapticFeedback.mediumImpact();
    setState(() => _isConfirming = true);
    await Future.delayed(const Duration(milliseconds: 800));

    if (!mounted) return;
    setState(() { _isConfirming = false; _isCheckedIn = true; });
    _successCtrl.forward();
    HapticFeedback.heavyImpact();
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
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white), onPressed: () => Navigator.pop(context)),
        title: Text(_isCheckedIn ? '✅ Check-in thành công' : 'Xác nhận Check-in', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
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
              width: 110, height: 110,
              decoration: const BoxDecoration(color: AppColors.success, shape: BoxShape.circle),
              child: const Icon(Icons.check_rounded, color: Colors.white, size: 60),
            ),
          ),
          const SizedBox(height: 20),
          const Text('Check-in thành công!', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
          const SizedBox(height: 6),
          Text('${b.customerName} vào lúc ${DateFormat('HH:mm').format(DateTime.now())}', style: const TextStyle(color: AppColors.textSecondary)),
          const SizedBox(height: 24),
          _BriefCard(booking: b),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () { Navigator.pop(context); Navigator.pop(context); },
              icon: const Icon(Icons.qr_code_scanner_rounded),
              label: const Text('Quét tiếp', style: TextStyle(fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: _brand, foregroundColor: Colors.white, elevation: 0,
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
              decoration: BoxDecoration(color: AppColors.error.withOpacity(0.1), borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.error.withOpacity(0.4))),
              child: Row(children: [
                const Icon(Icons.warning_amber_rounded, color: AppColors.error, size: 22),
                const SizedBox(width: 10),
                Expanded(child: Text(b.validationError, style: const TextStyle(color: AppColors.error, fontWeight: FontWeight.bold, fontSize: 13))),
              ]),
            ),

          // ── Customer card ──
          _InfoCard(
            child: Row(children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: _brand.withOpacity(0.15),
                child: Text(b.customerName[0], style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: _brand)),
              ),
              const SizedBox(width: 14),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(b.customerName, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                if (b.customerPhone != null) Row(children: [
                  const Icon(Icons.phone_rounded, size: 13, color: AppColors.textHint),
                  const SizedBox(width: 4),
                  Text(b.customerPhone!, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                ]),
              ])),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: AppColors.success.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
                child: const Text('Đã xác nhận', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.success)),
              ),
            ]),
          ),
          const SizedBox(height: 12),

          // ── Booking details ──
          _InfoCard(
            title: 'Thông tin đặt sân',
            child: Column(children: [
              _DetailRow(icon: Icons.sports_soccer_rounded, label: 'Sân', value: b.courtName, valueColor: _brand),
              _DetailRow(icon: Icons.stadium_rounded, label: 'Venue', value: b.venueName),
              _DetailRow(icon: Icons.event_rounded, label: 'Ngày', value: DateFormat('EEEE, dd/MM/yyyy', 'vi').format(b.bookingDate)),
              _DetailRow(icon: Icons.access_time_rounded, label: 'Giờ chơi', value: '${b.startTime} → ${b.endTime}', valueColor: _brand),
              _DetailRow(icon: Icons.confirmation_number_rounded, label: 'Mã booking', value: b.bookingCode, isMono: true),
              if (b.checkInCode != null)
                _DetailRow(icon: Icons.qr_code_rounded, label: 'Mã QR', value: b.checkInCode!, isMono: true),
              _DetailRow(icon: Icons.payments_rounded, label: 'Tổng tiền', value: _fmt(b.totalAmount), valueColor: AppColors.primaryLightBrand, isBold: true),
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
              onPressed: (!isValid || _isConfirming) ? null : _doCheckIn,
              style: ElevatedButton.styleFrom(
                backgroundColor: isValid ? AppColors.success : AppColors.textHint,
                foregroundColor: Colors.white, elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                disabledBackgroundColor: AppColors.textHint.withOpacity(0.5),
              ),
              child: _isConfirming
                  ? const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)),
                      SizedBox(width: 12),
                      Text('Đang xác nhận...', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    ])
                  : Text(isValid ? '✅ Xác Nhận Check-in' : '⚠️ Không thể Check-in', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
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
              child: const Text('Quét lại', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textSecondary)),
            ),
          ),
          const SizedBox(height: 24),
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
      color: AppColors.white, borderRadius: BorderRadius.circular(14),
      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Text(title!, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textHint, letterSpacing: 0.5)),
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
  const _DetailRow({required this.icon, required this.label, required this.value, this.valueColor, this.isMono = false, this.isBold = false});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: Row(children: [
      Icon(icon, size: 16, color: AppColors.textHint),
      const SizedBox(width: 10),
      Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
      const Spacer(),
      Text(value, style: TextStyle(
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
        decoration: BoxDecoration(color: AppColors.primaryLightBrand.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
        child: const Icon(Icons.add_shopping_cart_rounded, size: 14, color: AppColors.primaryLightBrand),
      ),
      const SizedBox(width: 10),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(addon.serviceName, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
        if (addon.serviceCategory != null)
          Text(addon.serviceCategory!, style: const TextStyle(fontSize: 10, color: AppColors.textHint)),
      ])),
      Text('x${addon.quantity}', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
      const SizedBox(width: 8),
      Text(_fmt(addon.totalPrice), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primaryLightBrand)),
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
      color: AppColors.success.withOpacity(0.08), borderRadius: BorderRadius.circular(14),
      border: Border.all(color: AppColors.success.withOpacity(0.3)),
    ),
    child: Column(children: [
      _DetailRow(icon: Icons.person_rounded, label: 'Khách', value: booking.customerName),
      _DetailRow(icon: Icons.sports_soccer_rounded, label: 'Sân', value: booking.courtName),
      _DetailRow(icon: Icons.access_time_rounded, label: 'Giờ', value: '${booking.startTime} – ${booking.endTime}'),
    ]),
  );
}
