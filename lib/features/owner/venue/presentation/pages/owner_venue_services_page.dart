import 'package:dat_san_247_mobile/core/base/di/injection.dart';
import 'package:dat_san_247_mobile/core/services/manager/toast_service.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/features/owner/venue/data/models/venue_models.dart';
import 'package:dat_san_247_mobile/features/owner/venue/presentation/providers/owner_venue_detail_sub_notifiers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// ══════════════════════════════════════════════════════════════════════════════
// O-06: Dịch Vụ Bán Kèm
// ══════════════════════════════════════════════════════════════════════════════
class OwnerVenueServicesPage extends ConsumerStatefulWidget {
  final String venueId;
  final String venueName;
  const OwnerVenueServicesPage(
      {super.key, required this.venueId, required this.venueName});

  @override
  ConsumerState<OwnerVenueServicesPage> createState() =>
      _OwnerVenueServicesPageState();
}

class _OwnerVenueServicesPageState extends ConsumerState<OwnerVenueServicesPage>
    with SingleTickerProviderStateMixin {
  static const Color _brand = Color(0xFF0891B2);
  static const Color _brandDark = Color(0xFF0E7490);

  late TabController _tabCtrl;
  VenueServiceType? _typeFilter;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = ownerVenueServicesProvider(widget.venueId);
    final state = ref.watch(provider);
    final services = state.value ?? [];
    final filtered =
        _typeFilter == null ? services : services.where((s) => s.type == _typeFilter).toList();

        final availableCount = services.where((s) => s.isAvailable).length;
        final lowStockCount = services.where((s) => s.isLowStock).length;
        final outOfStockCount = services.where((s) => s.isOutOfStock).length;

        return Scaffold(
          backgroundColor: const Color(0xFFF4F6FA),
          body: CustomScrollView(
            slivers: [
              // ── AppBar ──
              SliverAppBar(
                pinned: true,
                expandedHeight: 150,
                backgroundColor: _brand,
                titleSpacing: 0,
                title: const Text('Dịch Vụ Bán Kèm',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                leading: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white, size: 18),
                    onPressed: () => Navigator.pop(context)),
                actions: [
                  IconButton(
                      icon: const Icon(Icons.add_rounded, color: Colors.white),
                      onPressed: () => _showEditSheet(context, null)),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: const BoxDecoration(
                        gradient: LinearGradient(
                            colors: [_brandDark, _brand], begin: Alignment.topLeft, end: Alignment.bottomRight)),
                    child: SafeArea(
                        child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 48, 20, 0),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('Dịch vụ · ${widget.venueName}',
                            style: const TextStyle(color: Colors.white70, fontSize: 11)),
                        // const Text('Dịch Vụ Bán Kèm',
                        //     style: TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.w900)),
                        const SizedBox(height: 8),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(children: [
                            _HChip('${services.length} dịch vụ', Colors.white),
                            const SizedBox(width: 8),
                            _HChip('$availableCount đang bán', AppColors.success),
                            if (lowStockCount > 0) ...[
                              const SizedBox(width: 8),
                              _HChip('$lowStockCount sắp hết', AppColors.warning)
                            ],
                            if (outOfStockCount > 0) ...[
                              const SizedBox(width: 8),
                              _HChip('$outOfStockCount hết hàng', AppColors.error)
                            ],
                          ]),
                        ),
                      ]),
                    )),
                  ),
                  // title: const Text('Dịch Vụ Bán Kèm',
                  //     style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                ),
                bottom: TabBar(
                  controller: _tabCtrl,
                  indicatorColor: Colors.white,
                  indicatorWeight: 3,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white60,
                  labelStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                  onTap: (i) => setState(() => _typeFilter = i == 0
                      ? null
                      : (i == 1 ? VenueServiceType.PRODUCT : VenueServiceType.SERVICE)),
                  tabs: const [Tab(text: 'Tất cả'), Tab(text: '📦 Sản phẩm'), Tab(text: '🛎 Dịch vụ')],
                ),
              ),

              if (state.isLoading && services.isEmpty)
                const SliverFillRemaining(child: Center(child: CircularProgressIndicator()))
              else ...[
                // ── Stats bar ──
                if (outOfStockCount > 0 || lowStockCount > 0)
                  SliverToBoxAdapter(
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(12, 10, 12, 0),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: AppColors.warning.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.warning.withOpacity(0.3))),
                      child: Row(children: [
                        const Icon(Icons.inventory_2_rounded, size: 14, color: AppColors.warning),
                        const SizedBox(width: 8),
                        Expanded(
                            child: Text(
                          outOfStockCount > 0
                              ? '$outOfStockCount dịch vụ hết hàng · $lowStockCount sắp hết — cần bổ sung tồn kho'
                              : '$lowStockCount dịch vụ sắp hết hàng',
                          style: const TextStyle(fontSize: 11, color: AppColors.warning),
                        )),
                      ]),
                    ),
                  ),

                // ── List ──
                filtered.isEmpty
                    ? const SliverFillRemaining(
                        child: Center(
                            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                        Icon(Icons.room_service_outlined, size: 48, color: AppColors.textHint),
                        SizedBox(height: 12),
                        Text('Chưa có dịch vụ nào', style: TextStyle(color: AppColors.textHint)),
                      ])))
                    : SliverPadding(
                        padding: const EdgeInsets.fromLTRB(12, 10, 12, 80),
                        sliver: SliverList(
                            delegate: SliverChildBuilderDelegate(
                          (_, i) => _ServiceCard(
                            service: filtered[i],
                            onTap: () => _showEditSheet(context, filtered[i]),
                            onToggle: () {
                              ref.read(ownerVenueServicesProvider(widget.venueId).notifier).updateService(
                                  filtered[i].id, {'is_available': !filtered[i].isAvailable});
                              HapticFeedback.selectionClick();
                            },
                            onUpdateStock: () => _showUpdateStockSheet(context, filtered[i]),
                            onDelete: () => _confirmDelete(context, filtered[i]),
                          ),
                          childCount: filtered.length,
                        )),
                      ),
              ],
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => _showEditSheet(context, null),
            backgroundColor: _brand,
            icon: const Icon(Icons.add_rounded, color: Colors.white),
            label: const Text('Thêm Dịch Vụ', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        );
  }

  void _showEditSheet(BuildContext context, VenueServiceModel? existing) {
    final isNew = existing == null;
    final nameCtrl = TextEditingController(text: existing?.name ?? '');
    final descCtrl = TextEditingController(text: existing?.description ?? '');
    final priceCtrl = TextEditingController(text: existing != null ? existing.price.toInt().toString() : '');
    final catCtrl = TextEditingController(text: existing?.category ?? '');
    VenueServiceType type = existing?.type ?? VenueServiceType.SERVICE;
    ServiceUnit unit = existing?.unit ?? ServiceUnit.UNIT;
    bool isAvailable = existing?.isAvailable ?? true;
    bool trackInventory = existing?.trackInventory ?? false;
    final stockCtrl = TextEditingController(text: existing?.stockQuantity.toString() ?? '0');

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
                _Handle(),
                const SizedBox(height: 14),
                Row(children: [
                  Icon(isNew ? Icons.add_circle_rounded : Icons.edit_rounded, color: _brand, size: 20),
                  const SizedBox(width: 8),
                  Text(isNew ? 'Thêm Dịch Vụ' : 'Sửa: ${existing.name}',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold))
                ]),
                const SizedBox(height: 16),

                // Type chips
                _Label('Loại dịch vụ'),
                Row(
                    children: VenueServiceType.values
                        .map((t) => GestureDetector(
                              onTap: () => ss(() => type = t),
                              child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 150),
                                  margin: const EdgeInsets.only(right: 8),
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  decoration: BoxDecoration(
                                      color: type == t ? _brand : Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          color: type == t ? _brand : AppColors.borderLight)),
                                  child: Text('${t.emoji} ${t.label}',
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: type == t ? Colors.white : AppColors.textSecondary))),
                            ))
                        .toList()),
                const SizedBox(height: 12),

                _Label('Tên dịch vụ *'),
                _FieldBox(ctrl: nameCtrl, hint: 'VD: Nước suối, Thuê giày...'),
                const SizedBox(height: 10),
                _Label('Mô tả'),
                _FieldBox(ctrl: descCtrl, hint: 'Chai 500ml, giày các size...'),
                const SizedBox(height: 10),
                _Label('Danh mục'),
                _FieldBox(ctrl: catCtrl, hint: 'Đồ uống, Thiết bị, Giải trí...'),
                const SizedBox(height: 10),
                Row(children: [
                  Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    _Label('Giá *'),
                    _FieldBox(ctrl: priceCtrl, hint: '10000', keyboardType: TextInputType.number),
                  ])),
                  const SizedBox(width: 10),
                  Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    _Label('Đơn vị'),
                    Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                            border: Border.all(color: AppColors.borderLight),
                            borderRadius: BorderRadius.circular(10)),
                        child: DropdownButtonHideUnderline(
                            child: DropdownButton<ServiceUnit>(
                          isExpanded: true,
                          value: unit,
                          items: ServiceUnit.values
                              .map((u) => DropdownMenuItem(
                                  value: u, child: Text(u.label, style: const TextStyle(fontSize: 13))))
                              .toList(),
                          onChanged: (v) => ss(() => unit = v ?? unit),
                        ))),
                  ])),
                ]),
                const SizedBox(height: 10),

                // Toggle: available
                _ToggleRow('Đang bán', isAvailable, () => ss(() => isAvailable = !isAvailable)),
                const Divider(height: 12),
                _ToggleRow('Theo dõi tồn kho', trackInventory,
                    () => ss(() => trackInventory = !trackInventory)),
                if (trackInventory) ...[
                  const SizedBox(height: 8),
                  _Label('Số lượng tồn kho'),
                  _FieldBox(ctrl: stockCtrl, hint: '0', keyboardType: TextInputType.number),
                ],
                const SizedBox(height: 16),

                SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        final name = nameCtrl.text.trim();
                        // Clean price string from commas or spaces before parsing
                        final priceStr = priceCtrl.text.replaceAll(RegExp(r'[^0-9.]'), '');
                        final p = double.tryParse(priceStr) ?? 0;
                        
                        if (name.isEmpty || p <= 0) {
                          getIt<ToastService>().error('Vui lòng nhập tên và giá hợp lệ');
                          return;
                        }
                        Navigator.pop(ctx);

                        final data = {
                          'name': name,
                          'description': descCtrl.text.trim().isEmpty ? null : descCtrl.text.trim(),
                          'price': p,
                          'unit': unit.name,
                          'type': type.name,
                          'category': catCtrl.text.trim().isEmpty ? null : catCtrl.text.trim(),
                          'is_available': isAvailable,
                          'track_inventory': trackInventory,
                          'stock_quantity': int.tryParse(stockCtrl.text) ?? 0,
                        };

                        final servicesNotifier = ref.read(
                            ownerVenueServicesProvider(widget.venueId).notifier);
                        if (isNew) {
                          servicesNotifier.addService(data);
                        } else {
                          servicesNotifier.updateService(existing.id, data);
                        }

                        HapticFeedback.mediumImpact();
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: _brand,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                      child: Text(isNew ? 'Thêm Dịch Vụ' : 'Lưu',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    )),
              ])),
        ),
      ),
    );
  }

  void _showUpdateStockSheet(BuildContext context, VenueServiceModel service) {
    final ctrl = TextEditingController(text: service.stockQuantity.toString());
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(18))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
              _Handle(),
              const SizedBox(height: 14),
              Row(children: [
                const Icon(Icons.inventory_2_rounded, color: AppColors.warning),
                const SizedBox(width: 8),
                Text('Cập nhật tồn kho: ${service.name}',
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold))
              ]),
              const SizedBox(height: 16),
              Row(children: [
                _StockBtn('-', () {
                  final v = (int.tryParse(ctrl.text) ?? 0) - 1;
                  if (v >= 0) ctrl.text = v.toString();
                }),
                Expanded(
                    child: TextField(
                        controller: ctrl,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(), contentPadding: EdgeInsets.symmetric(vertical: 10)))),
                _StockBtn('+', () {
                  final v = (int.tryParse(ctrl.text) ?? 0) + 1;
                  ctrl.text = v.toString();
                }),
              ]),
              const SizedBox(height: 16),
              SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                      final newQty = int.tryParse(ctrl.text) ?? 0;
                      ref.read(ownerVenueServicesProvider(widget.venueId).notifier)
                          .updateService(service.id, {'stock_quantity': newQty});
                      HapticFeedback.mediumImpact();
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.warning,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                    child: const Text('Cập nhật tồn kho',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  )),
            ])),
      ),
    );
  }

  void _confirmDelete(BuildContext context, VenueServiceModel service) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: const Text('Xoá dịch vụ?', style: TextStyle(fontWeight: FontWeight.bold)),
              content: Text('Xoá "${service.name}"?\nDữ liệu booking_addons liên quan sẽ không bị ảnh hưởng.'),
              actions: [
                TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Huỷ')),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    ref.read(ownerVenueServicesProvider(widget.venueId).notifier).deleteService(service.id);
                    HapticFeedback.mediumImpact();
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.error,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                  child: const Text('Xoá', style: TextStyle(color: Colors.white)),
                ),
              ],
            ));
  }
}

// ── Service Card ──────────────────────────────────────────────────────────────
class _ServiceCard extends StatelessWidget {
  final VenueServiceModel service;
  final VoidCallback onTap, onToggle, onUpdateStock, onDelete;
  const _ServiceCard(
      {required this.service,
      required this.onTap,
      required this.onToggle,
      required this.onUpdateStock,
      required this.onDelete});

  @override
  Widget build(BuildContext context) {
    const brand = Color(0xFF0891B2);
    final stockColor =
        service.isOutOfStock ? AppColors.error : service.isLowStock ? AppColors.warning : AppColors.success;

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: service.isAvailable ? 1.0 : 0.55,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  color: service.isOutOfStock ? AppColors.error.withOpacity(0.3) : AppColors.borderLight),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6)]),
          child: Column(children: [
            Row(children: [
              Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(color: brand.withOpacity(0.08), borderRadius: BorderRadius.circular(10)),
                  child: Center(child: Text(service.type.emoji, style: const TextStyle(fontSize: 18)))),
              const SizedBox(width: 10),
              Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Expanded(
                      child: Text(service.name,
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900),
                          overflow: TextOverflow.ellipsis)),
                  if (service.category != null)
                    Container(
                        margin: const EdgeInsets.only(left: 6),
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration:
                            BoxDecoration(color: AppColors.info.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                        child: Text(service.category!,
                            style: const TextStyle(fontSize: 9, color: AppColors.info, fontWeight: FontWeight.bold))),
                ]),
                if (service.description != null)
                  Text(service.description!,
                      style: const TextStyle(fontSize: 10, color: AppColors.textHint),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
              ])),
              Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Text('${_fmtP(service.price)}/${service.unit.label}',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: brand)),
                const SizedBox(height: 4),
                GestureDetector(
                    onTap: onToggle,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                          color:
                              service.isAvailable ? AppColors.success.withOpacity(0.1) : AppColors.borderLight.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(20)),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        Container(
                            width: 5,
                            height: 5,
                            decoration: BoxDecoration(
                                color: service.isAvailable ? AppColors.success : AppColors.textHint,
                                shape: BoxShape.circle)),
                        const SizedBox(width: 4),
                        Text(service.isAvailable ? 'Bật' : 'Tắt',
                            style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                color: service.isAvailable ? AppColors.success : AppColors.textHint)),
                      ]),
                    )),
              ]),
            ]),
            if (service.trackInventory) ...[
              const Divider(height: 10, color: AppColors.borderLight),
              Row(children: [
                Icon(Icons.inventory_2_outlined, size: 12, color: stockColor),
                const SizedBox(width: 6),
                Text(service.isOutOfStock ? 'Hết hàng' : 'Tồn kho: ${service.stockQuantity} ${service.unit.label}',
                    style: TextStyle(fontSize: 11, color: stockColor, fontWeight: FontWeight.bold)),
                const Spacer(),
                GestureDetector(
                    onTap: onUpdateStock,
                    child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(color: AppColors.warning.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                        child: const Text('Cập nhật', style: TextStyle(fontSize: 10, color: AppColors.warning, fontWeight: FontWeight.bold)))),
              ]),
            ],
            const Divider(height: 10, color: AppColors.borderLight),
            Row(children: [
              _Btn(Icons.edit_rounded, 'Sửa', brand, onTap),
              const SizedBox(width: 8),
              _Btn(Icons.delete_outline_rounded, 'Xoá', AppColors.error, onDelete),
            ]),
          ]),
        ),
      ),
    );
  }

  String _fmtP(double v) {
    if (v >= 1000) return '${(v / 1000).round()}K';
    return v.toStringAsFixed(0);
  }
}

// ── Shared ────────────────────────────────────────────────────────────────────
class _HChip extends StatelessWidget {
  final String label;
  final Color color;
  const _HChip(this.label, this.color);
  @override
  Widget build(BuildContext context) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: color.withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
      child: Text(label, style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.bold)));
}

class _Btn extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _Btn(this.icon, this.label, this.color, this.onTap);
  @override
  Widget build(BuildContext context) => GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Icon(icon, size: 12, color: color),
            const SizedBox(width: 4),
            Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: color))
          ])));
}

class _Handle extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Center(
      child: Container(
          width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2))));
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
  final TextEditingController ctrl;
  final String hint;
  final TextInputType keyboardType;
  const _FieldBox({required this.ctrl, required this.hint, this.keyboardType = TextInputType.text});
  @override
  Widget build(BuildContext context) => TextField(
      controller: ctrl,
      keyboardType: keyboardType,
      decoration: InputDecoration(
          hintText: hint,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10)));
}

class _ToggleRow extends StatelessWidget {
  final String label;
  final bool value;
  final VoidCallback onToggle;
  const _ToggleRow(this.label, this.value, this.onToggle);
  @override
  Widget build(BuildContext context) => Row(children: [
        Expanded(child: Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600))),
        Switch(value: value, onChanged: (_) => onToggle(), activeColor: const Color(0xFF0891B2))
      ]);
}

class _StockBtn extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _StockBtn(this.label, this.onTap);
  @override
  Widget build(BuildContext context) => GestureDetector(
      onTap: onTap,
      child: Container(
          width: 44,
          height: 44,
          margin: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(color: const Color(0xFF0891B2).withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
          child: Center(
              child: Text(label,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF0891B2))))));
}
