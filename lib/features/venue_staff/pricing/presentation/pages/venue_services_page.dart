import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/features/venue_staff/schedule/data/models/staff_schedule_models.dart';
import 'package:dat_san_247_mobile/routes/base/annotations.dart';
// ══════════════════════════════════════════════════════════════════════════════
// VS-10: Dịch Vụ Bán Kèm [MANAGER only]
// DB: venue_services (venue_id)  { name, price, unit, type, category,
//     is_available, track_inventory, stock_quantity }
// ══════════════════════════════════════════════════════════════════════════════
@route
class VenueServicesPage extends StatefulWidget {
  const VenueServicesPage({super.key});

  @override
  State<VenueServicesPage> createState() => _VenueServicesPageState();
}

class _VenueServicesPageState extends State<VenueServicesPage> {
  static const Color _brand = Color(0xFF7C3AED);
  String? _filterCategory;

  late List<VenueServiceModel> _services = _buildMock();

  static List<VenueServiceModel> _buildMock() => [
    VenueServiceModel(id:'s1', venueId:'v1', name:'Nước Pocari 500ml', category:'Đồ uống', price:15000, unit:ServiceUnit.UNIT, type:VenueServiceType.FOOD_BEVERAGE, isAvailable:true, trackInventory:true, stockQuantity:48),
    VenueServiceModel(id:'s2', venueId:'v1', name:'Nước lọc Tiger 500ml', category:'Đồ uống', price:8000, unit:ServiceUnit.UNIT, type:VenueServiceType.FOOD_BEVERAGE, isAvailable:true, trackInventory:true, stockQuantity:120),
    VenueServiceModel(id:'s3', venueId:'v1', name:'Nước tăng lực Sting', category:'Đồ uống', price:12000, unit:ServiceUnit.UNIT, type:VenueServiceType.FOOD_BEVERAGE, isAvailable:false, trackInventory:true, stockQuantity:0),
    VenueServiceModel(id:'s4', venueId:'v1', name:'Bóng đá size 4', category:'Thiết bị', price:20000, unit:ServiceUnit.SESSION, type:VenueServiceType.EQUIPMENT, isAvailable:true, trackInventory:true, stockQuantity:8),
    VenueServiceModel(id:'s5', venueId:'v1', name:'Bóng đá size 5', category:'Thiết bị', price:25000, unit:ServiceUnit.SESSION, type:VenueServiceType.EQUIPMENT, isAvailable:true, trackInventory:true, stockQuantity:5),
    VenueServiceModel(id:'s6', venueId:'v1', name:'Găng tay thủ môn', category:'Thiết bị', price:10000, unit:ServiceUnit.SESSION, type:VenueServiceType.EQUIPMENT, isAvailable:true, trackInventory:true, stockQuantity:2),
    VenueServiceModel(id:'s7', venueId:'v1', name:'Áo thi đấu (thuê)', category:'Thiết bị', price:30000, unit:ServiceUnit.SESSION, type:VenueServiceType.EQUIPMENT, isAvailable:true, trackInventory:false, stockQuantity:0),
    VenueServiceModel(id:'s8', venueId:'v1', name:'Chụp ảnh lưu niệm', category:'Dịch vụ', price:100000, unit:ServiceUnit.SESSION, type:VenueServiceType.SERVICE, isAvailable:true, trackInventory:false, stockQuantity:0),
    VenueServiceModel(id:'s9', venueId:'v1', name:'Huấn luyện viên 1 giờ', category:'Dịch vụ', price:200000, unit:ServiceUnit.HOUR, type:VenueServiceType.SERVICE, isAvailable:false, trackInventory:false, stockQuantity:0),
  ];

  List<String> get _categories => _services.map((s) => s.category ?? 'Khác').toSet().toList();

  List<VenueServiceModel> get _filtered => _filterCategory == null
      ? _services
      : _services.where((s) => (s.category ?? 'Khác') == _filterCategory).toList();

  int get _availableCount => _services.where((s) => s.isAvailable).length;
  int get _lowStockCount => _services.where((s) => s.trackInventory && s.stockQuantity <= 3 && s.isAvailable).length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      body: CustomScrollView(
        slivers: [
          // ── AppBar ──
          SliverAppBar(
            pinned: true,
            expandedHeight: 130,
            backgroundColor: _brand,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white, size: 18),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.add_rounded, color: Colors.white),
                onPressed: () => _showEditSheet(context, null),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: [Color(0xFF4C1D95), Color(0xFF7C3AED)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 44, 20, 0),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      const Text('Dịch Vụ Bán Kèm', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900)),
                      const Text('👑 MANAGER — Quản lý addon & kho hàng', style: TextStyle(color: Colors.white70, fontSize: 11)),
                      const SizedBox(height: 10),
                      Row(children: [
                        _StatPill('$_availableCount hoạt động', AppColors.success),
                        const SizedBox(width: 8),
                        _StatPill('${_services.length - _availableCount} tắt', Colors.white60),
                        if (_lowStockCount > 0) ...[
                          const SizedBox(width: 8),
                          _StatPill('⚠️ $_lowStockCount sắp hết', AppColors.warning),
                        ],
                      ]),
                    ]),
                  ),
                ),
              ),
              title: const Text('Dịch Vụ', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
            ),
          ),

          // ── Category filter ──
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(children: [
                  _CatPill(label: 'Tất cả', selected: _filterCategory == null, brand: _brand, onTap: () => setState(() => _filterCategory = null)),
                  ..._categories.map((cat) => _CatPill(
                    label: cat,
                    selected: _filterCategory == cat,
                    brand: _brand,
                    icon: _catIcon(cat),
                    onTap: () => setState(() => _filterCategory = cat),
                  )),
                ]),
              ),
            ),
          ),

          // ── Low stock warning ──
          if (_lowStockCount > 0)
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.fromLTRB(12, 10, 12, 0),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: AppColors.warning.withOpacity(0.1), borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.warning.withOpacity(0.3))),
                child: Row(children: [
                  const Icon(Icons.inventory_2_outlined, size: 16, color: AppColors.warning),
                  const SizedBox(width: 8),
                  Text('$_lowStockCount dịch vụ sắp hết hàng — cần nhập thêm kho', style: const TextStyle(fontSize: 12, color: AppColors.warning, fontWeight: FontWeight.w600)),
                ]),
              ),
            ),

          // ── Service list ──
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 80),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (_, i) => _ServiceCard(
                  service: _filtered[i],
                  onToggle: () => setState(() {
                    final idx = _services.indexWhere((s) => s.id == _filtered[i].id);
                    if (idx >= 0) {
                      final old = _services[idx];
                      _services[idx] = VenueServiceModel(
                        id: old.id, venueId: old.venueId, name: old.name,
                        category: old.category, price: old.price, unit: old.unit,
                        type: old.type, isAvailable: !old.isAvailable,
                        trackInventory: old.trackInventory, stockQuantity: old.stockQuantity,
                        description: old.description,
                      );
                    }
                    HapticFeedback.selectionClick();
                  }),
                  onUpdateStock: _filtered[i].trackInventory ? () => _showStockSheet(context, _filtered[i]) : null,
                  onEdit: () => _showEditSheet(context, _filtered[i]),
                ),
                childCount: _filtered.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _catIcon(String cat) => switch (cat) {
    'Đồ uống' => Icons.local_drink_rounded,
    'Thiết bị' => Icons.sports_rounded,
    'Dịch vụ' => Icons.miscellaneous_services_rounded,
    _ => Icons.category_rounded,
  };

  void _showStockSheet(BuildContext context, VenueServiceModel service) {
    int qty = service.stockQuantity;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(18))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, ss) => Padding(
          padding: const EdgeInsets.all(20),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 14),
            Row(children: [
              const Icon(Icons.inventory_2_rounded, color: Color(0xFF7C3AED)),
              const SizedBox(width: 8),
              const Text('Cập nhật kho hàng', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ]),
            const SizedBox(height: 4),
            Text(service.name, style: const TextStyle(fontSize: 12, color: AppColors.textHint)),
            const SizedBox(height: 20),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              _QtyButton(icon: Icons.remove_rounded, color: AppColors.error, onTap: qty > 0 ? () => ss(() => qty--) : null),
              Container(
                width: 80, height: 60,
                decoration: BoxDecoration(border: Border.all(color: AppColors.borderLight), borderRadius: BorderRadius.circular(12)),
                child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text('$qty', style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900)),
                  const Text('số lượng', style: TextStyle(fontSize: 9, color: AppColors.textHint)),
                ]),
              ),
              _QtyButton(icon: Icons.add_rounded, color: AppColors.success, onTap: () => ss(() => qty++)),
            ]),
            const SizedBox(height: 8),
            if (qty <= 3)
              Text('⚠️ Số lượng thấp – sắp hết hàng', style: TextStyle(fontSize: 11, color: AppColors.warning, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  setState(() {
                    final idx = _services.indexWhere((s) => s.id == service.id);
                    if (idx >= 0) {
                      final old = _services[idx];
                      _services[idx] = VenueServiceModel(
                        id: old.id, venueId: old.venueId, name: old.name,
                        category: old.category, price: old.price, unit: old.unit,
                        type: old.type, isAvailable: old.isAvailable,
                        trackInventory: old.trackInventory, stockQuantity: qty,
                        description: old.description,
                      );
                    }
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('✅ Đã cập nhật kho: ${service.name} → $qty ${service.unit.label}'), backgroundColor: AppColors.success),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7C3AED), elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Lưu kho', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  void _showEditSheet(BuildContext context, VenueServiceModel? existing) {
    final isNew = existing == null;
    final nameCtrl = TextEditingController(text: existing?.name ?? '');
    final priceCtrl = TextEditingController(text: existing != null ? existing.price.toInt().toString() : '');
    final catCtrl = TextEditingController(text: existing?.category ?? '');
    ServiceUnit unit = existing?.unit ?? ServiceUnit.UNIT;
    VenueServiceType type = existing?.type ?? VenueServiceType.SERVICE;
    bool trackInventory = existing?.trackInventory ?? false;

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
              Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)))),
              const SizedBox(height: 14),
              Row(children: [
                Icon(isNew ? Icons.add_circle_rounded : Icons.edit_rounded, color: const Color(0xFF7C3AED), size: 20),
                const SizedBox(width: 8),
                Text(isNew ? 'Thêm Dịch Vụ' : 'Sửa Dịch Vụ', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ]),
              const SizedBox(height: 16),
              _LabelTxt('Tên dịch vụ'),
              _FieldBox(child: TextField(controller: nameCtrl, decoration: const InputDecoration.collapsed(hintText: 'VD: Nước Pocari 500ml'))),
              const SizedBox(height: 10),
              Row(children: [
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  _LabelTxt('Giá (VNĐ)'),
                  _FieldBox(child: TextField(controller: priceCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration.collapsed(hintText: '15000'))),
                ])),
                const SizedBox(width: 10),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  _LabelTxt('Đơn vị'),
                  _FieldBox(child: DropdownButtonHideUnderline(
                    child: DropdownButton<ServiceUnit>(
                      value: unit, isExpanded: true,
                      items: ServiceUnit.values.map((u) => DropdownMenuItem(value: u, child: Text(u.label, style: const TextStyle(fontSize: 13)))).toList(),
                      onChanged: (v) => ss(() => unit = v!),
                    ),
                  )),
                ])),
              ]),
              const SizedBox(height: 10),
              Row(children: [
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  _LabelTxt('Danh mục'),
                  _FieldBox(child: TextField(controller: catCtrl, decoration: const InputDecoration.collapsed(hintText: 'Thiết bị / Đồ uống...'))),
                ])),
                const SizedBox(width: 10),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  _LabelTxt('Loại'),
                  _FieldBox(child: DropdownButtonHideUnderline(
                    child: DropdownButton<VenueServiceType>(
                      value: type, isExpanded: true,
                      items: VenueServiceType.values.map((t) => DropdownMenuItem(value: t, child: Text(_typeLabel(t), style: const TextStyle(fontSize: 12)))).toList(),
                      onChanged: (v) => ss(() => type = v!),
                    ),
                  )),
                ])),
              ]),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () => ss(() => trackInventory = !trackInventory),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: trackInventory ? const Color(0xFF7C3AED).withOpacity(0.06) : Colors.grey.shade50, borderRadius: BorderRadius.circular(10), border: Border.all(color: trackInventory ? const Color(0xFF7C3AED).withOpacity(0.3) : AppColors.borderLight)),
                  child: Row(children: [
                    Icon(Icons.inventory_2_rounded, color: trackInventory ? const Color(0xFF7C3AED) : AppColors.textHint, size: 18),
                    const SizedBox(width: 10),
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      const Text('Theo dõi kho hàng', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      const Text('Giới hạn bán khi hết stock', style: TextStyle(fontSize: 10, color: AppColors.textHint)),
                    ]),
                    const Spacer(),
                    Switch(value: trackInventory, onChanged: (v) => ss(() => trackInventory = v), activeColor: const Color(0xFF7C3AED)),
                  ]),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (nameCtrl.text.isEmpty) return;
                    Navigator.pop(ctx);
                    setState(() {
                      if (isNew) {
                        _services.add(VenueServiceModel(
                          id: 'new_${DateTime.now().millisecondsSinceEpoch}',
                          venueId: 'v1', name: nameCtrl.text,
                          category: catCtrl.text.isEmpty ? null : catCtrl.text,
                          price: double.tryParse(priceCtrl.text) ?? 0,
                          unit: unit, type: type,
                          isAvailable: true, trackInventory: trackInventory, stockQuantity: 0,
                        ));
                      }
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(isNew ? '✅ Đã thêm dịch vụ: ${nameCtrl.text}' : '✅ Đã cập nhật'), backgroundColor: AppColors.success),
                    );
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF7C3AED), elevation: 0, padding: const EdgeInsets.symmetric(vertical: 13), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                  child: Text(isNew ? 'Thêm dịch vụ' : 'Lưu', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  String _typeLabel(VenueServiceType t) => switch (t) {
    VenueServiceType.SERVICE       => 'Dịch vụ',
    VenueServiceType.EQUIPMENT     => 'Thiết bị',
    VenueServiceType.FOOD_BEVERAGE => 'Thức ăn/uống',
    VenueServiceType.OTHER         => 'Khác',
  };
}

// ── Service card ──────────────────────────────────────────────────────────────
class _ServiceCard extends StatelessWidget {
  final VenueServiceModel service;
  final VoidCallback onToggle;
  final VoidCallback? onUpdateStock;
  final VoidCallback onEdit;

  const _ServiceCard({required this.service, required this.onToggle, this.onUpdateStock, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    const brand = Color(0xFF7C3AED);
    final isLow = service.trackInventory && service.stockQuantity <= 3 && service.isAvailable;

    return GestureDetector(
      onTap: onEdit,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: service.isAvailable ? 1.0 : 0.55,
        child: Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isLow ? AppColors.warning.withOpacity(0.4) : AppColors.borderLight),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 6)],
          ),
          child: Row(children: [
            // Type icon
            Container(
              width: 44, height: 44,
              decoration: BoxDecoration(color: _typeColor.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
              child: Icon(_typeIcon, size: 22, color: _typeColor),
            ),
            const SizedBox(width: 12),

            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Expanded(child: Text(service.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis)),
                if (isLow) Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  decoration: BoxDecoration(color: AppColors.warning.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                  child: const Text('⚠️ Sắp hết', style: TextStyle(fontSize: 9, color: AppColors.warning, fontWeight: FontWeight.bold)),
                ),
              ]),
              const SizedBox(height: 3),
              Row(children: [
                if (service.category != null) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                    decoration: BoxDecoration(color: _typeColor.withOpacity(0.08), borderRadius: BorderRadius.circular(4)),
                    child: Text(service.category!, style: TextStyle(fontSize: 9, color: _typeColor, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(width: 6),
                ],
                Text('${_fmtP(service.price)}/${service.unit.label}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: brand)),
              ]),
              if (service.trackInventory) ...[
                const SizedBox(height: 4),
                Row(children: [
                  const Icon(Icons.inventory_2_rounded, size: 11, color: AppColors.textHint),
                  const SizedBox(width: 4),
                  Text('Kho: ${service.stockQuantity} ${service.unit.label}',
                      style: TextStyle(fontSize: 11, color: isLow ? AppColors.warning : AppColors.textHint, fontWeight: isLow ? FontWeight.bold : FontWeight.normal)),
                ]),
              ],
            ])),

            const SizedBox(width: 8),
            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              // Toggle
              GestureDetector(
                onTap: onToggle,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: service.isAvailable ? AppColors.success.withOpacity(0.1) : AppColors.borderLight.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Container(width: 6, height: 6, decoration: BoxDecoration(color: service.isAvailable ? AppColors.success : AppColors.textHint, shape: BoxShape.circle)),
                    const SizedBox(width: 4),
                    Text(service.isAvailable ? 'Bật' : 'Tắt', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: service.isAvailable ? AppColors.success : AppColors.textHint)),
                  ]),
                ),
              ),
              if (onUpdateStock != null) ...[
                const SizedBox(height: 6),
                GestureDetector(
                  onTap: onUpdateStock,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: brand.withOpacity(0.08), borderRadius: BorderRadius.circular(8)),
                    child: const Text('Kho', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: brand)),
                  ),
                ),
              ],
            ]),
          ]),
        ),
      ),
    );
  }

  Color get _typeColor => switch (service.type) {
    VenueServiceType.FOOD_BEVERAGE => AppColors.success,
    VenueServiceType.EQUIPMENT     => const Color(0xFF0891B2),
    VenueServiceType.SERVICE       => const Color(0xFF7C3AED),
    VenueServiceType.OTHER         => AppColors.textHint,
  };

  IconData get _typeIcon => switch (service.type) {
    VenueServiceType.FOOD_BEVERAGE => Icons.local_drink_rounded,
    VenueServiceType.EQUIPMENT     => Icons.sports_rounded,
    VenueServiceType.SERVICE       => Icons.miscellaneous_services_rounded,
    VenueServiceType.OTHER         => Icons.category_rounded,
  };

  String _fmtP(double v) {
    if (v >= 1000) return '${(v/1000).round()}K';
    return v.toStringAsFixed(0);
  }
}

// ── Reusable helpers ──────────────────────────────────────────────────────────
class _CatPill extends StatelessWidget {
  final String label; final bool selected; final Color brand; final VoidCallback onTap; final IconData? icon;
  const _CatPill({required this.label, required this.selected, required this.brand, required this.onTap, this.icon});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: () { HapticFeedback.selectionClick(); onTap(); },
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: selected ? brand : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: selected ? brand : AppColors.borderLight),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        if (icon != null) ...[Icon(icon, size: 12, color: selected ? Colors.white : AppColors.textHint), const SizedBox(width: 4)],
        Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: selected ? Colors.white : AppColors.textSecondary)),
      ]),
    ),
  );
}

class _StatPill extends StatelessWidget {
  final String text; final Color color;
  const _StatPill(this.text, this.color);

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
    decoration: BoxDecoration(color: color.withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
    child: Text(text, style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.bold)),
  );
}

class _QtyButton extends StatelessWidget {
  final IconData icon; final Color color; final VoidCallback? onTap;
  const _QtyButton({required this.icon, required this.color, this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap != null ? () { HapticFeedback.selectionClick(); onTap!(); } : null,
    child: Container(
      width: 44, height: 44, margin: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(color: onTap != null ? color.withOpacity(0.1) : AppColors.borderLight, shape: BoxShape.circle),
      child: Icon(icon, color: onTap != null ? color : AppColors.textHint, size: 24),
    ),
  );
}

class _LabelTxt extends StatelessWidget {
  final String text;
  const _LabelTxt(this.text);

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 4),
    child: Text(text, style: const TextStyle(fontSize: 11, color: AppColors.textHint, fontWeight: FontWeight.bold)),
  );
}

class _FieldBox extends StatelessWidget {
  final Widget child;
  const _FieldBox({required this.child});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
    margin: const EdgeInsets.only(bottom: 0),
    decoration: BoxDecoration(border: Border.all(color: AppColors.borderLight), borderRadius: BorderRadius.circular(10)),
    child: child,
  );
}
