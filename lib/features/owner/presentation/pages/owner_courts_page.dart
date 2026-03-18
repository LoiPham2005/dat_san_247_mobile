import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/features/owner/data/models/owner_models.dart';
import 'package:dat_san_247_mobile/features/owner/presentation/pages/owner_court_pricing_page.dart';

// ══════════════════════════════════════════════════════════════════════════════
// O-04: Quản Lý Sân (Courts)
// DB: courts (venue_id, deleted_at IS NULL), sport_assignments, amenities,
//     media_attachments
// ══════════════════════════════════════════════════════════════════════════════
class OwnerCourtsPage extends StatefulWidget {
  final String venueId;
  final String venueName;
  const OwnerCourtsPage({super.key, required this.venueId, required this.venueName});

  @override
  State<OwnerCourtsPage> createState() => _OwnerCourtsPageState();
}

class _OwnerCourtsPageState extends State<OwnerCourtsPage> {
  static const Color _brand = Color(0xFF0891B2);
  static const Color _brandDark = Color(0xFF0E7490);

  bool _showInactive = false;

  List<OwnerCourtModel> _courts = _buildMock();

  static List<OwnerCourtModel> _buildMock() {
    final now = DateTime.now();
    return [
      OwnerCourtModel(id:'c1', venueId:'v1', name:'Sân A', description:'Sân bóng đá 7 người cỏ nhân tạo thế hệ 3.', pricePerHour:150000, surfaceType:CourtSurfaceType.ARTIFICIAL_GRASS, size:'34x18m', isIndoor:false, isActive:true, displayOrder:1, sportTypes:['FOOTBALL'],
        amenities:[const AmenityModel(id:'a1', courtId:'c1', name:'Đèn chiếu sáng', isFree:true), const AmenityModel(id:'a2', courtId:'c1', name:'Ghế ngồi', isFree:true)], createdAt:now, updatedAt:now),
      OwnerCourtModel(id:'c2', venueId:'v1', name:'Sân B', description:'Sân bóng đá 7 người, góc thoáng mát.', pricePerHour:130000, surfaceType:CourtSurfaceType.ARTIFICIAL_GRASS, size:'34x18m', isIndoor:false, isActive:true, displayOrder:2, sportTypes:['FOOTBALL'],
        amenities:[const AmenityModel(id:'a3', courtId:'c2', name:'Đèn chiếu sáng', isFree:true)], createdAt:now, updatedAt:now),
      OwnerCourtModel(id:'c3', venueId:'v1', name:'Sân CL', description:'Sân cầu lông trong nhà, máy lạnh.', pricePerHour:70000, surfaceType:CourtSurfaceType.WOOD, size:'13.4x6.1m', isIndoor:true, isActive:true, displayOrder:3, sportTypes:['BADMINTON'], amenities:[], createdAt:now, updatedAt:now),
      OwnerCourtModel(id:'c4', venueId:'v1', name:'Sân D', description:'Sân bóng đá 5 người mini.', pricePerHour:120000, surfaceType:CourtSurfaceType.ARTIFICIAL_GRASS, size:'25x14m', isIndoor:false, isActive:true, displayOrder:4, sportTypes:['FOOTBALL'], amenities:[], createdAt:now, updatedAt:now),
      OwnerCourtModel(id:'c5', venueId:'v1', name:'Sân E (Bảo trì)', description:'Đang nâng cấp hệ thống tưới cỏ.', pricePerHour:150000, surfaceType:CourtSurfaceType.GRASS, size:'34x18m', isIndoor:false, isActive:false, displayOrder:5, sportTypes:['FOOTBALL'], amenities:[], createdAt:now, updatedAt:now),
    ];
  }

  List<OwnerCourtModel> get _filtered => _showInactive ? _courts : _courts.where((c) => c.isActive).toList();
  int get _activeCount => _courts.where((c) => c.isActive).length;

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      body: CustomScrollView(
        slivers: [
          // ── AppBar ──
          SliverAppBar(
            pinned: true,
            expandedHeight: 140,
            backgroundColor: _brand,
            leading: IconButton(icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white, size: 18), onPressed: () => Navigator.pop(context)),
            actions: [
              TextButton.icon(
                onPressed: () => setState(() => _showInactive = !_showInactive),
                icon: Icon(_showInactive ? Icons.visibility_off_rounded : Icons.visibility_rounded, color: Colors.white70, size: 14),
                label: Text(_showInactive ? 'Ẩn tắt' : 'Hiện tắt', style: const TextStyle(color: Colors.white70, fontSize: 11)),
              ),
              IconButton(icon: const Icon(Icons.add_rounded, color: Colors.white), onPressed: () => _showAddCourtSheet(context)),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(gradient: LinearGradient(colors: [_brandDark, _brand], begin: Alignment.topLeft, end: Alignment.bottomRight)),
                child: SafeArea(child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 48, 20, 0),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('Sân của · ${widget.venueName}', style: const TextStyle(color: Colors.white70, fontSize: 11)),
                    const Text('Quản Lý Sân', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900)),
                    const SizedBox(height: 8),
                    Row(children: [
                      _HChip(label: '$_activeCount đang hoạt động', color: AppColors.success),
                      const SizedBox(width: 8),
                      _HChip(label: '${_courts.length - _activeCount} tắt', color: Colors.white60),
                    ]),
                  ]),
                )),
              ),
              title: const Text('Quản Lý Sân', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
            ),
          ),

          // ── Court cards ──
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 80),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (_, i) => _CourtCard(
                  court: filtered[i],
                  brand: _brand,
                  onTap: () => _showEditSheet(context, filtered[i]),
                  onToggleActive: () => setState(() {
                    final idx = _courts.indexWhere((c) => c.id == filtered[i].id);
                    if (idx >= 0) {
                      final c = _courts[idx];
                      _courts[idx] = OwnerCourtModel(id:c.id, venueId:c.venueId, name:c.name, description:c.description, pricePerHour:c.pricePerHour, surfaceType:c.surfaceType, size:c.size, isIndoor:c.isIndoor, isActive:!c.isActive, displayOrder:c.displayOrder, thumbnailUrl:c.thumbnailUrl, sportTypes:c.sportTypes, amenities:c.amenities, createdAt:c.createdAt, updatedAt:DateTime.now());
                    }
                    HapticFeedback.selectionClick();
                  }),
                  onPricing: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => OwnerCourtPricingPage(court: filtered[i]))),
                  onReorder: i < filtered.length - 1 ? () => setState(() {
                    final a = _courts.indexWhere((c) => c.id == filtered[i].id);
                    final b = _courts.indexWhere((c) => c.id == filtered[i+1].id);
                    if (a >= 0 && b >= 0) { final tmp = _courts[a]; _courts[a] = _courts[b]; _courts[b] = tmp; }
                    HapticFeedback.selectionClick();
                  }) : null,
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
  }

  void _showAddCourtSheet(BuildContext context) {
    final nameCtrl = TextEditingController();
    final priceCtrl = TextEditingController();
    final sizeCtrl = TextEditingController();
    CourtSurfaceType? surface;
    bool isIndoor = false;
    List<String> sports = [];
    const allSports = {'FOOTBALL':'⚽ Bóng đá','BADMINTON':'🏸 Cầu lông','TENNIS':'🎾 Tennis','BASKETBALL':'🏀 Bóng rổ'};

    showModalBottomSheet(
      context: context, isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, ss) => Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
          child: SingleChildScrollView(padding: const EdgeInsets.all(20), child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
            Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 14),
            Row(children: [Icon(Icons.add_circle_rounded, color: _brand, size: 20), const SizedBox(width: 8), const Text('Thêm Sân Mới', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))]),
            const SizedBox(height: 16),
            _Label('Tên sân *'), _FieldBox(controller: nameCtrl, hint: 'VD: Sân A'), const SizedBox(height: 10),
            Row(children: [
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [_Label('Giá/giờ (VNĐ) *'), _FieldBox(controller: priceCtrl, hint: '150000', keyboardType: TextInputType.number)])),
              const SizedBox(width: 10),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [_Label('Kích thước'), _FieldBox(controller: sizeCtrl, hint: '34x18m')])),
            ]),
            const SizedBox(height: 10),
            _Label('Loại mặt sân'),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(border: Border.all(color: AppColors.borderLight), borderRadius: BorderRadius.circular(10)),
              child: DropdownButtonHideUnderline(child: DropdownButton<CourtSurfaceType>(
                isExpanded: true, value: surface, hint: const Text('Chọn mặt sân'),
                items: CourtSurfaceType.values.map((t) => DropdownMenuItem(value: t, child: Text(t.label, style: const TextStyle(fontSize: 13)))).toList(),
                onChanged: (v) => ss(() => surface = v),
              )),
            ),
            const SizedBox(height: 10),
            Row(children: [
              const Expanded(child: Text('Sân có mái (trong nhà)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600))),
              Switch(value: isIndoor, onChanged: (v) => ss(() => isIndoor = v), activeColor: _brand),
            ]),
            const SizedBox(height: 10),
            _Label('Môn thể thao'),
            Wrap(spacing: 8, runSpacing: 8, children: allSports.entries.map((e) => GestureDetector(
              onTap: () => ss(() { if (sports.contains(e.key)) sports.remove(e.key); else sports.add(e.key); }),
              child: AnimatedContainer(duration: const Duration(milliseconds: 150), padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(color: sports.contains(e.key) ? _brand : Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: sports.contains(e.key) ? _brand : AppColors.borderLight)),
                child: Text(e.value, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: sports.contains(e.key) ? Colors.white : AppColors.textSecondary))),
            )).toList()),
            const SizedBox(height: 16),
            SizedBox(width: double.infinity, child: ElevatedButton(
              onPressed: () {
                if (nameCtrl.text.isEmpty || priceCtrl.text.isEmpty) return;
                Navigator.pop(ctx);
                setState(() => _courts.add(OwnerCourtModel(id: 'new_${DateTime.now().millisecondsSinceEpoch}', venueId: widget.venueId, name: nameCtrl.text, pricePerHour: double.tryParse(priceCtrl.text) ?? 0, surfaceType: surface, size: sizeCtrl.text.isEmpty ? null : sizeCtrl.text, isIndoor: isIndoor, isActive: true, displayOrder: _courts.length + 1, sportTypes: sports, amenities: [], createdAt: DateTime.now(), updatedAt: DateTime.now())));
                HapticFeedback.mediumImpact();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('✅ Đã thêm sân: ${nameCtrl.text}'), backgroundColor: AppColors.success));
              },
              style: ElevatedButton.styleFrom(backgroundColor: _brand, elevation: 0, padding: const EdgeInsets.symmetric(vertical: 13), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              child: const Text('Thêm Sân', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            )),
          ])),
        ),
      ),
    );
  }

  void _showEditSheet(BuildContext context, OwnerCourtModel court) {
    // Simplified edit — same pattern as add but pre-filled
    final nameCtrl = TextEditingController(text: court.name);
    final priceCtrl = TextEditingController(text: court.pricePerHour.toInt().toString());
    showModalBottomSheet(
      context: context, isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: SingleChildScrollView(padding: const EdgeInsets.all(20), child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)))),
          const SizedBox(height: 14),
          Row(children: [Icon(Icons.edit_rounded, color: _brand, size: 20), const SizedBox(width: 8), Text('Sửa: ${court.name}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold))]),
          const SizedBox(height: 16),
          _Label('Tên sân'), _FieldBox(controller: nameCtrl, hint: 'Tên sân'), const SizedBox(height: 10),
          _Label('Giá cơ bản / giờ'), _FieldBox(controller: priceCtrl, hint: '150000', keyboardType: TextInputType.number), const SizedBox(height: 16),
          Row(children: [
            Expanded(child: OutlinedButton(
              onPressed: () { Navigator.pop(ctx); Navigator.of(context).push(MaterialPageRoute(builder: (_) => OwnerCourtPricingPage(court: court))); },
              style: OutlinedButton.styleFrom(side: BorderSide(color: _brand), padding: const EdgeInsets.symmetric(vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
              child: Text('Bảng Giá', style: TextStyle(color: _brand, fontWeight: FontWeight.bold)),
            )),
            const SizedBox(width: 12),
            Expanded(child: ElevatedButton(
              onPressed: () { Navigator.pop(ctx); HapticFeedback.mediumImpact(); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('✅ Đã cập nhật sân'), backgroundColor: AppColors.success)); },
              style: ElevatedButton.styleFrom(backgroundColor: _brand, elevation: 0, padding: const EdgeInsets.symmetric(vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
              child: const Text('Lưu', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            )),
          ]),
        ])),
      ),
    );
  }
}

// ── Court Card ────────────────────────────────────────────────────────────────
class _CourtCard extends StatelessWidget {
  final OwnerCourtModel court;
  final Color brand;
  final VoidCallback onTap;
  final VoidCallback onToggleActive;
  final VoidCallback onPricing;
  final VoidCallback? onReorder;
  const _CourtCard({required this.court, required this.brand, required this.onTap, required this.onToggleActive, required this.onPricing, this.onReorder});

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: court.isActive ? 1.0 : 0.55,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: court.isActive ? AppColors.borderLight : AppColors.borderLight.withOpacity(0.5)),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)],
          ),
          child: Column(children: [
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              // Order badge
              Container(width: 32, height: 32, decoration: BoxDecoration(color: brand.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                child: Center(child: Text('#${court.displayOrder}', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: brand)))),
              const SizedBox(width: 10),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Expanded(child: Text(court.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900))),
                  if (court.isIndoor) Container(margin: const EdgeInsets.only(left: 6), padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: AppColors.info.withOpacity(0.1), borderRadius: BorderRadius.circular(6)), child: const Text('🏠 Trong nhà', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.info))),
                ]),
                const SizedBox(height: 2),
                Row(children: [
                  if (court.surfaceType != null) Text(court.surfaceType!.label, style: const TextStyle(fontSize: 10, color: AppColors.textHint)),
                  if (court.size != null) ...[const Text(' · ', style: TextStyle(color: AppColors.textHint, fontSize: 10)), Text(court.size!, style: const TextStyle(fontSize: 10, color: AppColors.textHint))],
                ]),
                const SizedBox(height: 4),
                Row(children: [
                  ...court.sportTypes.map((s) => Padding(padding: const EdgeInsets.only(right: 4), child: Text(_sportEmoji(s), style: const TextStyle(fontSize: 13)))),
                ]),
              ])),
              Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Text(_fmtPrice(court.pricePerHour), style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: brand)),
                const Text('/giờ', style: TextStyle(fontSize: 9, color: AppColors.textHint)),
                const SizedBox(height: 4),
                GestureDetector(
                  onTap: onToggleActive,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: court.isActive ? AppColors.success.withOpacity(0.1) : AppColors.borderLight.withOpacity(0.5), borderRadius: BorderRadius.circular(20)),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      Container(width: 6, height: 6, decoration: BoxDecoration(color: court.isActive ? AppColors.success : AppColors.textHint, shape: BoxShape.circle)),
                      const SizedBox(width: 4),
                      Text(court.isActive ? 'Bật' : 'Tắt', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: court.isActive ? AppColors.success : AppColors.textHint)),
                    ]),
                  ),
                ),
              ]),
            ]),
            if (court.amenities.isNotEmpty) ...[
              const Divider(height: 10, color: AppColors.borderLight),
              Row(children: [
                const Icon(Icons.check_circle_outline_rounded, size: 12, color: AppColors.textHint),
                const SizedBox(width: 4),
                Expanded(child: Text(court.amenities.map((a) => a.name).join(' · '), style: const TextStyle(fontSize: 10, color: AppColors.textHint), maxLines: 1, overflow: TextOverflow.ellipsis)),
              ]),
            ],
            const Divider(height: 10, color: AppColors.borderLight),
            Row(children: [
              _ActionBtn(icon: Icons.price_change_rounded, label: 'Bảng giá', onTap: onPricing, color: AppColors.warning),
              if (onReorder != null) ...[
                const SizedBox(width: 8),
                _ActionBtn(icon: Icons.swap_vert_rounded, label: 'Đổi thứ tự', onTap: onReorder!, color: AppColors.textHint),
              ],
              const Spacer(),
              _ActionBtn(icon: Icons.edit_rounded, label: 'Sửa', onTap: onTap, color: brand),
            ]),
          ]),
        ),
      ),
    );
  }

  String _sportEmoji(String sport) => switch (sport) { 'FOOTBALL' => '⚽', 'BADMINTON' => '🏸', 'TENNIS' => '🎾', 'BASKETBALL' => '🏀', _ => '🏅' };
  String _fmtPrice(double v) { if (v >= 1000) return '${(v/1000).round()}K'; return v.toStringAsFixed(0); }
}

class _ActionBtn extends StatelessWidget {
  final IconData icon; final String label; final VoidCallback onTap; final Color color;
  const _ActionBtn({required this.icon, required this.label, required this.onTap, required this.color});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: () { HapticFeedback.selectionClick(); onTap(); },
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 12, color: color),
        const SizedBox(width: 4),
        Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: color)),
      ]),
    ),
  );
}

class _HChip extends StatelessWidget {
  final String label; final Color color;
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
  Widget build(BuildContext context) => Padding(padding: const EdgeInsets.only(bottom: 4), child: Text(text, style: const TextStyle(fontSize: 11, color: AppColors.textHint, fontWeight: FontWeight.bold)));
}

class _FieldBox extends StatelessWidget {
  final TextEditingController controller; final String hint; final TextInputType keyboardType;
  const _FieldBox({required this.controller, required this.hint, this.keyboardType = TextInputType.text});
  @override
  Widget build(BuildContext context) => TextField(controller: controller, keyboardType: keyboardType, decoration: InputDecoration(hintText: hint, border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)), contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10)));
}
