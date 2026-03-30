import 'package:dat_san_247_mobile/core/services/manager/toast_service.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/features/owner/venue/presentation/cubit/owner_venue_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class OwnerAddVenuePage extends StatefulWidget {
  const OwnerAddVenuePage({super.key});

  @override
  State<OwnerAddVenuePage> createState() => _OwnerAddVenuePageState();
}

class _OwnerAddVenuePageState extends State<OwnerAddVenuePage> {
  static const Color _brand = Color(0xFF1565C0);

  final _nameCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  final _districtCtrl = TextEditingController();
  final _wardCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();

  LatLng _selectedPos = const LatLng(21.0285, 105.8542); // Hanoi default
  final MapController _mapCtrl = MapController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _addressCtrl.dispose();
    _cityCtrl.dispose();
    _districtCtrl.dispose();
    _wardCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: AppBar(
        title: const Text('Đăng ký Sân bãi Mới',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: _brand,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('THÔNG TIN LIÊN HỆ',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: _brand)),
                  const SizedBox(height: 12),
                  _FormField(
                      controller: _nameCtrl,
                      label: 'Tên sân bãi *',
                      hint: 'VD: Sân K34 Phạm Văn Đồng'),
                  const SizedBox(height: 12),
                  _FormField(
                      controller: _phoneCtrl,
                      label: 'Số điện thoại liên hệ *',
                      hint: '024...',
                      keyboardType: TextInputType.phone),
                  const SizedBox(height: 24),
                  const Text('ĐỊA CHỈ & VỊ TRÍ',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: _brand)),
                  const SizedBox(height: 12),
                  _FormField(
                      controller: _cityCtrl, label: 'Tỉnh/Thành phố *', hint: 'Hà Nội'),
                  const SizedBox(height: 12),
                  _FormField(
                      controller: _districtCtrl, label: 'Quận/Huyện *', hint: 'Bắc Từ Liêm'),
                  const SizedBox(height: 12),
                  _FormField(controller: _wardCtrl, label: 'Phường/Xã', hint: 'Phường Cổ Nhuế 2'),
                  const SizedBox(height: 12),
                  _FormField(
                      controller: _addressCtrl,
                      label: 'Địa chỉ chi tiết *',
                      hint: '34 Phạm Văn Đồng...'),
                  const SizedBox(height: 24),
                  const Text('CHỌN VỊ TRÍ TRÊN BẢN ĐỒ',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: _brand)),
                  const SizedBox(height: 8),
                  Container(
                    height: 250,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.borderLight),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Stack(
                      children: [
                        FlutterMap(
                          mapController: _mapCtrl,
                          options: MapOptions(
                            initialCenter: _selectedPos,
                            initialZoom: 15,
                            onPositionChanged: (pos, hasGesture) {
                              if (hasGesture) {
                                setState(() {
                                  _selectedPos = pos.center;
                                });
                              }
                            },
                          ),
                          children: [
                            TileLayer(
                              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                              userAgentPackageName: 'com.datsan247.mobile',
                            ),
                          ],
                        ),
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 30),
                            child: Icon(Icons.location_on_rounded, color: Colors.blue, size: 40),
                          ),
                        ),
                        Positioned(
                          bottom: 10,
                          right: 10,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                    color: Colors.white, borderRadius: BorderRadius.circular(8)),
                                child: Text(
                                  '${_selectedPos.latitude.toStringAsFixed(6)}, ${_selectedPos.longitude.toStringAsFixed(6)}',
                                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text('Di chuyển bản đồ để chọn vị trí chính xác',
                      style: TextStyle(fontSize: 11, color: AppColors.textHint)),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -5))],
            ),
            child: SafeArea(
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_nameCtrl.text.isEmpty ||
                        _addressCtrl.text.isEmpty ||
                        _cityCtrl.text.isEmpty ||
                        _districtCtrl.text.isEmpty) {
                      toast.error('Vui lòng nhập đầy đủ thông tin bắt buộc');
                      return;
                    }
                    context.read<OwnerVenueCubit>().createVenue(
                          name: _nameCtrl.text,
                          address: _addressCtrl.text,
                          city: _cityCtrl.text,
                          district: _districtCtrl.text,
                          ward: _wardCtrl.text,
                          phone: _phoneCtrl.text,
                          lat: _selectedPos.latitude,
                          lng: _selectedPos.longitude,
                        );
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _brand,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: const Text('ĐĂNG KÝ SÂN BÃI',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FormField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final TextInputType keyboardType;
  const _FormField(
      {required this.controller,
      required this.label,
      required this.hint,
      this.keyboardType = TextInputType.text});

  @override
  Widget build(BuildContext context) =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label,
            style: const TextStyle(
                fontSize: 11, color: AppColors.textHint, fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        TextField(
            controller: controller,
            keyboardType: keyboardType,
            style: const TextStyle(fontSize: 14),
            decoration: InputDecoration(
                hintText: hint,
                hintStyle: const TextStyle(fontSize: 13, color: AppColors.textHint),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14))),
      ]);
}
