import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:dat_san_247_mobile/features/venue_staff/check_in/data/models/check_in_models.dart';
import 'package:dat_san_247_mobile/features/venue_staff/check_in/presentation/pages/check_in_confirm_page.dart';
import 'package:dat_san_247_mobile/features/venue_staff/check_in/presentation/widgets/qr_scanner_widgets.dart';

// ──────────────────────────────────────────────────────────────────────────
// VS-02: QR Scanner Check-in page
// ──────────────────────────────────────────────────────────────────────────
class QrCheckInPage extends StatefulWidget {
  const QrCheckInPage({super.key});

  @override
  State<QrCheckInPage> createState() => _QrCheckInPageState();
}

class _QrCheckInPageState extends State<QrCheckInPage> with SingleTickerProviderStateMixin {
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
    setState(() {
      _isLoading = true;
      _errorMsg = null;
    });
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
        StaffBookingAddonModel(
            id: 'a1',
            bookingId: 'b-demo-001',
            serviceId: 's1',
            serviceName: 'Nước Pocari',
            serviceCategory: 'Đồ uống',
            quantity: 2,
            pricePerUnit: 15000,
            totalPrice: 30000),
        StaffBookingAddonModel(
            id: 'a2',
            bookingId: 'b-demo-001',
            serviceId: 's2',
            serviceName: 'Bóng đá size 5',
            serviceCategory: 'Thiết bị',
            quantity: 1,
            pricePerUnit: 20000,
            totalPrice: 20000),
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
    setState(() {
      _isLoading = true;
      _errorMsg = null;
    });
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
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),

          // ── Camera grid overlay (decorative) ──
          Positioned.fill(
            child: CustomPaint(painter: GridPainter()),
          ),

          // ── QR Square frame ──
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 60),
                QrFrame(scanAnim: _scanAnim, brand: _brand, isLoading: _isLoading),
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
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
                          child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 18),
                        ),
                      ),
                      const SizedBox(width: 14),
                      const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('Quét QR Check-in',
                            style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold)),
                        Text('Hướng camera vào mã QR của khách',
                            style: TextStyle(color: Colors.white60, fontSize: 11)),
                      ]),
                      const Spacer(),
                      // Flashlight toggle (mock)
                      GestureDetector(
                        onTap: () => HapticFeedback.selectionClick(),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
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
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                              : const Icon(Icons.qr_code_scanner_rounded, size: 20),
                          label: Text(_isLoading ? 'Đang tìm...' : '✨ Simulate Scan (Demo)',
                              style: const TextStyle(fontWeight: FontWeight.bold)),
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
                          child: Text('hoặc nhập thủ công',
                              style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 11)),
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
                                  style: const TextStyle(
                                      color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.5),
                                  decoration: InputDecoration(
                                    hintText: 'DS24799101 hoặc ABCD1234',
                                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 12),
                                    filled: true,
                                    fillColor: Colors.white.withOpacity(0.08),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(color: _brand.withOpacity(0.5))),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(color: Colors.white.withOpacity(0.2))),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(color: _brand, width: 1.5)),
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                    prefixIcon: const Icon(Icons.tag_rounded, color: Colors.white54, size: 18),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              ElevatedButton(
                                onPressed: _isLoading ? null : _manualLookup,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _brand,
                                  foregroundColor: Colors.white,
                                  elevation: 0,
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
                                decoration: BoxDecoration(
                                    color: Colors.red.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: Colors.red.withOpacity(0.4))),
                                child: Row(children: [
                                  const Icon(Icons.error_outline_rounded, color: Colors.red, size: 16),
                                  const SizedBox(width: 8),
                                  Expanded(
                                      child: Text(_errorMsg!,
                                          style: const TextStyle(color: Colors.red, fontSize: 12))),
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
