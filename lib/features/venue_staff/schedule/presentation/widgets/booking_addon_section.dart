import 'package:dat_san_247_mobile/features/venue_staff/check_in/data/models/check_in_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/features/venue_staff/schedule/data/models/staff_schedule_models.dart';
import 'package:dat_san_247_mobile/features/venue_staff/schedule/presentation/widgets/booking_detail_card.dart';

class BookingAddonSection extends StatelessWidget {
  final List<StaffBookingAddonModel> addons;
  final List<VenueServiceModel> availableServices;
  final bool canAdd;
  final void Function(StaffBookingAddonModel) onAddonAdded;
  final void Function(String id) onAddonRemoved;

  const BookingAddonSection({
    super.key,
    required this.addons,
    required this.availableServices,
    required this.canAdd,
    required this.onAddonAdded,
    required this.onAddonRemoved,
  });

  @override
  Widget build(BuildContext context) {
    const brand = Color(0xFF7C3AED);
    return BookingDetailCard(
      title: addons.isEmpty ? 'Dịch vụ thêm' : 'Dịch vụ thêm (${addons.length})',
      trailing: canAdd
          ? GestureDetector(
              onTap: () => _showAddAddonSheet(context),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                    color: brand.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
                child: const Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(Icons.add_rounded, size: 14, color: brand),
                  SizedBox(width: 4),
                  Text('Thêm',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: brand)),
                ]),
              ),
            )
          : null,
      child: addons.isEmpty
          ? const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Center(
                  child: Text('Chưa có dịch vụ thêm',
                      style: TextStyle(fontSize: 12, color: AppColors.textHint))),
            )
          : Column(
              children: addons
                  .map((a) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Row(children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                                color: AppColors.primaryLightBrand.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8)),
                            child: const Icon(Icons.shopping_bag_rounded,
                                size: 14, color: AppColors.primaryLightBrand),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                Text(a.serviceName,
                                    style:
                                        const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                                if (a.serviceCategory != null)
                                  Text(a.serviceCategory!,
                                      style:
                                          const TextStyle(fontSize: 10, color: AppColors.textHint)),
                              ])),
                          Text('x${a.quantity}',
                              style: const TextStyle(
                                  fontSize: 11, color: AppColors.textSecondary)),
                          const SizedBox(width: 8),
                          Text(_fmtPrice(a.totalPrice),
                              style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryLightBrand)),
                          if (canAdd) ...[
                            const SizedBox(width: 6),
                            GestureDetector(
                              onTap: () => onAddonRemoved(a.id),
                              child:
                                  const Icon(Icons.close_rounded, size: 15, color: AppColors.textHint),
                            ),
                          ],
                        ]),
                      ))
                  .toList(),
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
      shape:
          const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => _AddAddonSheet(
        services: availableServices,
        onAdd: (service, qty) {
          final addon = StaffBookingAddonModel(
            id: 'new_${DateTime.now().millisecondsSinceEpoch}',
            bookingId: '',
            serviceId: service.id,
            serviceName: service.name,
            serviceCategory: service.category,
            quantity: qty,
            pricePerUnit: service.price,
            totalPrice: service.price * qty,
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
      expand: false,
      initialChildSize: 0.6,
      maxChildSize: 0.85,
      builder: (_, scroll) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          // Handle
          Container(
              margin: const EdgeInsets.only(top: 10, bottom: 10),
              width: 40,
              height: 4,
              decoration:
                  BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2))),
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
                  onTap: s.isInStock
                      ? () {
                          HapticFeedback.selectionClick();
                          setState(() {
                            _selected = s;
                            _qty = 1;
                          });
                        }
                      : null,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isSelected ? brand.withOpacity(0.06) : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: isSelected ? brand.withOpacity(0.6) : AppColors.borderLight,
                          width: isSelected ? 1.5 : 1),
                    ),
                    child: Row(children: [
                      Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                              color: s.isInStock ? AppColors.success : AppColors.error,
                              shape: BoxShape.circle)),
                      const SizedBox(width: 10),
                      Expanded(
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(s.name,
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: s.isInStock ? AppColors.textPrimary : AppColors.textHint)),
                        if (s.category != null)
                          Text(s.category!,
                              style: const TextStyle(fontSize: 10, color: AppColors.textHint)),
                      ])),
                      if (!s.isInStock)
                        const Text('Hết hàng', style: TextStyle(fontSize: 10, color: AppColors.error))
                      else
                        Text('${_fmtP(s.price)}/${s.unit.label}',
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: isSelected ? brand : AppColors.textPrimary)),
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
          if (_selected != null)
            Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              decoration: BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 10,
                    offset: const Offset(0, -3))
              ]),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Row(children: [
                  Expanded(
                      child: Text(_selected!.name, style: const TextStyle(fontWeight: FontWeight.bold))),
                  // Qty spinner
                  Row(children: [
                    _QtyBtn(
                        icon: Icons.remove_rounded,
                        onTap: _qty > 1 ? () => setState(() => _qty--) : null),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: Text('$_qty',
                          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                    ),
                    _QtyBtn(icon: Icons.add_rounded, onTap: () => setState(() => _qty++)),
                  ]),
                ]),
                const SizedBox(height: 8),
                Row(children: [
                  Text('Tổng: ${_fmtP(_selected!.price * _qty)}đ',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: brand)),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () {
                      HapticFeedback.mediumImpact();
                      widget.onAdd(_selected!, _qty);
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: brand,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                    child: const Text('Thêm vào',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ]),
              ]),
            ),
        ]),
      ),
    );
  }

  String _fmtP(double v) {
    if (v >= 1000) return '${(v / 1000).round()}K';
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
          width: 30,
          height: 30,
          decoration: BoxDecoration(
              color: onTap != null
                  ? const Color(0xFF7C3AED).withOpacity(0.1)
                  : AppColors.borderLight,
              borderRadius: BorderRadius.circular(8)),
          child: Icon(icon,
              size: 16,
              color: onTap != null ? const Color(0xFF7C3AED) : AppColors.textHint),
        ),
      );
}
