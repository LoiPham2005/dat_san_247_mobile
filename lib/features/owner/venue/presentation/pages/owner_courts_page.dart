import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/features/owner/venue/data/models/venue_models.dart';
import 'package:dat_san_247_mobile/features/owner/venue/presentation/pages/owner_court_pricing_page.dart';
import 'package:dat_san_247_mobile/features/owner/venue/presentation/widgets/court_card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dat_san_247_mobile/core/base/di/injection.dart';
import 'package:dat_san_247_mobile/core/base/state/bloc/base_state.dart';
import 'package:dat_san_247_mobile/features/owner/venue/presentation/cubit/owner_venue_detail_sub_cubits.dart';
import 'package:dat_san_247_mobile/core/services/manager/toast_service.dart';

// ──────────────────────────────────────────────────────────────────────────
// O-04: Quản Lý Sân (Courts)
// ──────────────────────────────────────────────────────────────────────────
class OwnerCourtsPage extends StatelessWidget {
  final String venueId;
  final String venueName;
  const OwnerCourtsPage({super.key, required this.venueId, required this.venueName});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<OwnerCourtsCubit>()..fetchCourts(venueId),
      child: _OwnerCourtsView(venueId: venueId, venueName: venueName),
    );
  }
}

class _OwnerCourtsView extends StatefulWidget {
  final String venueId;
  final String venueName;
  const _OwnerCourtsView({required this.venueId, required this.venueName});

  @override
  State<_OwnerCourtsView> createState() => _OwnerCourtsViewState();
}

class _OwnerCourtsViewState extends State<_OwnerCourtsView> {
  static const Color _brand = Color(0xFF0891B2);
  static const Color _brandDark = Color(0xFF0E7490);

  bool _showInactive = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OwnerCourtsCubit, BaseState<List<OwnerCourtModel>>>(
      builder: (context, state) {
        final courts = state.data ?? [];
        final filtered = _showInactive ? courts : courts.where((c) => c.isActive).toList();
        final activeCount = courts.where((c) => c.isActive).length;

        return Scaffold(
          backgroundColor: const Color(0xFFF4F6FA),
          body: CustomScrollView(
            slivers: [
              _buildHeader(courts.length, activeCount),
              if (state.isLoading && courts.isEmpty)
                const SliverFillRemaining(child: Center(child: CircularProgressIndicator()))
              else if (filtered.isEmpty)
                SliverFillRemaining(
                  child: Center(
                    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Icon(Icons.stadium_outlined, size: 60, color: Colors.grey.shade300),
                      const SizedBox(height: 16),
                      Text('Chưa có sân nào',
                          style: TextStyle(color: Colors.grey.shade500, fontWeight: FontWeight.w500)),
                    ]),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 80),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (_, i) => CourtCard(
                        court: filtered[i],
                        brand: _brand,
                        onTap: () => _showEditSheet(context, filtered[i]),
                        onToggleActive: () {
                          // TODO: API for toggle active
                          HapticFeedback.selectionClick();
                        },
                        onPricing: () => Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => OwnerCourtPricingPage(court: filtered[i]))),
                        onReorder: null,
                      ),
                      childCount: filtered.length,
                    ),
                  ),
                ),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => _showAddCourtSheet(context),
            backgroundColor: _brand,
            icon: const Icon(Icons.add_rounded, color: Colors.white),
            label: const Text('Thêm Sân', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        );
      },
    );
  }

  Widget _buildHeader(int total, int active) => SliverAppBar(
        pinned: true,
        expandedHeight: 150,
        backgroundColor: _brand,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Danh sách sân',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
        centerTitle: false,
        actions: [
          TextButton.icon(
            onPressed: () => setState(() => _showInactive = !_showInactive),
            icon: Icon(_showInactive ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                color: Colors.white70, size: 14),
            label: Text(_showInactive ? 'Ẩn tắt' : 'Hiện tắt',
                style: const TextStyle(color: Colors.white70, fontSize: 11)),
          ),
        ],
        flexibleSpace: FlexibleSpaceBar(
          background: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: [_brandDark, _brand], begin: Alignment.topLeft, end: Alignment.bottomRight),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const SizedBox(height: 38),
                  Text('Sân của · ${widget.venueName}',
                      style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 2),
                  const Text('Quản lý sân bãi 🏟️',
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  Row(children: [
                    _HChip(label: '$active hoạt động', color: AppColors.success),
                    const SizedBox(width: 8),
                    _HChip(label: '${total - active} tạm nghỉ', color: Colors.white60),
                  ]),
                ]),
              ),
            ),
          ),
        ),
      );

  void _showAddCourtSheet(BuildContext context) {
    final nameCtrl = TextEditingController();
    final priceCtrl = TextEditingController();
    final sizeCtrl = TextEditingController();
    CourtSurfaceType? surface;
    bool isIndoor = false;
    List<String> sports = [];
    const allSports = {
      'FOOTBALL': '⚽ Bóng đá',
      'BADMINTON': '🏸 Cầu lông',
      'TENNIS': '🎾 Tennis',
      'BASKETBALL': '🏀 Bóng rổ'
    };

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, ss) => Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
          child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                Center(
                    child: Container(
                        width: 40,
                        height: 4,
                        decoration:
                            BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)))),
                const SizedBox(height: 14),
                Row(children: [
                  Icon(Icons.add_circle_rounded, color: _brand, size: 20),
                  const SizedBox(width: 8),
                  const Text('Thêm Sân Mới', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))
                ]),
                const SizedBox(height: 16),
                const _Label('Tên sân *'),
                _FieldBox(controller: nameCtrl, hint: 'VD: Sân A'),
                const SizedBox(height: 10),
                Row(children: [
                  Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const _Label('Giá/giờ (VNĐ) *'),
                    _FieldBox(controller: priceCtrl, hint: '150000', keyboardType: TextInputType.number)
                  ])),
                  const SizedBox(width: 10),
                  Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const _Label('Kích thước'),
                    _FieldBox(controller: sizeCtrl, hint: '34x18m')
                  ])),
                ]),
                const SizedBox(height: 10),
                const _Label('Loại mặt sân'),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                      border: Border.all(color: AppColors.borderLight), borderRadius: BorderRadius.circular(10)),
                  child: DropdownButtonHideUnderline(
                      child: DropdownButton<CourtSurfaceType>(
                    isExpanded: true,
                    value: surface,
                    hint: const Text('Chọn mặt sân'),
                    items: CourtSurfaceType.values
                        .map((t) =>
                            DropdownMenuItem(value: t, child: Text(t.label, style: const TextStyle(fontSize: 13))))
                        .toList(),
                    onChanged: (v) => ss(() => surface = v),
                  )),
                ),
                const SizedBox(height: 10),
                Row(children: [
                  const Expanded(
                      child: Text('Sân có mái (trong nhà)',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600))),
                  Switch(value: isIndoor, onChanged: (v) => ss(() => isIndoor = v), activeColor: _brand),
                ]),
                const SizedBox(height: 10),
                const _Label('Môn thể thao'),
                Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: allSports.entries
                        .map((e) => GestureDetector(
                              onTap: () => ss(() {
                                if (sports.contains(e.key))
                                  sports.remove(e.key);
                                else
                                  sports.add(e.key);
                              }),
                              child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 150),
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                  decoration: BoxDecoration(
                                      color: sports.contains(e.key) ? _brand : Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                          color: sports.contains(e.key) ? _brand : AppColors.borderLight)),
                                  child: Text(e.value,
                                      style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: sports.contains(e.key) ? Colors.white : AppColors.textSecondary))),
                            ))
                        .toList()),
                const SizedBox(height: 16),
                SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (nameCtrl.text.isEmpty || priceCtrl.text.isEmpty) {
                          getIt<ToastService>().error('Vui lòng nhập đủ thông tin');
                          return;
                        }
                        Navigator.pop(ctx);
                        context.read<OwnerCourtsCubit>().addCourt(widget.venueId, {
                          'name': nameCtrl.text,
                          'price_per_hour': int.tryParse(priceCtrl.text) ?? 0,
                          'surface_type': surface?.name,
                          'size': sizeCtrl.text.isEmpty ? null : sizeCtrl.text,
                          'is_indoor': isIndoor,
                          'sport_types': sports,
                        }).then((_) {
                          getIt<ToastService>().success('Đã thêm sân: ${nameCtrl.text}');
                        });
                        HapticFeedback.mediumImpact();
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: _brand,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                      child: const Text('Thêm Sân',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    )),
              ])),
        ),
      ),
    );
  }

  void _showEditSheet(BuildContext context, OwnerCourtModel court) {
    final nameCtrl = TextEditingController(text: court.name);
    final priceCtrl = TextEditingController(text: court.pricePerHour.toInt().toString());
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
              Center(
                  child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)))),
              const SizedBox(height: 14),
              Row(children: [
                Icon(Icons.edit_rounded, color: _brand, size: 20),
                const SizedBox(width: 8),
                Text('Sửa: ${court.name}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold))
              ]),
              const SizedBox(height: 16),
              const _Label('Tên sân'),
              _FieldBox(controller: nameCtrl, hint: 'Tên sân'),
              const SizedBox(height: 10),
              const _Label('Giá cơ bản / giờ'),
              _FieldBox(controller: priceCtrl, hint: '150000', keyboardType: TextInputType.number),
              const SizedBox(height: 16),
              Row(children: [
                Expanded(
                    child: OutlinedButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (_) => OwnerCourtPricingPage(court: court)));
                  },
                  style: OutlinedButton.styleFrom(
                      side: BorderSide(color: _brand),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                  child: Text('Bảng Giá', style: TextStyle(color: _brand, fontWeight: FontWeight.bold)),
                )),
                const SizedBox(width: 12),
                Expanded(
                    child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    HapticFeedback.mediumImpact();
                    getIt<ToastService>().success('Tính năng đang phát triển');
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: _brand,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                  child: const Text('Lưu', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                )),
              ]),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: TextButton.icon(
                  onPressed: () {
                    Navigator.pop(ctx);
                    context.read<OwnerCourtsCubit>().deleteCourt(widget.venueId, court.id);
                  },
                  icon: const Icon(Icons.delete_outline_rounded, color: AppColors.error, size: 18),
                  label: const Text('Xóa Sân', style: TextStyle(color: AppColors.error, fontWeight: FontWeight.bold)),
                ),
              ),
            ])),
      ),
    );
  }
}

class _HChip extends StatelessWidget {
  final String label;
  final Color color;
  const _HChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(color: color.withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
        child: Text(label, style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.bold)),
      );
}

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);
  @override
  Widget build(BuildContext context) => Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(text, style: const TextStyle(fontSize: 11, color: AppColors.textHint, fontWeight: FontWeight.bold)));
}

class _FieldBox extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final TextInputType keyboardType;
  const _FieldBox({required this.controller, required this.hint, this.keyboardType = TextInputType.text});
  @override
  Widget build(BuildContext context) => TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
          hintText: hint,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10)));
}
