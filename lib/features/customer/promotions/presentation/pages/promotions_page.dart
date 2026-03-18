import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/features/customer/promotions/data/models/promotion_model.dart';

// ──────────────────────────────────────────────────────────────────────────
// C-17: Khuyến Mãi & Voucher
// ──────────────────────────────────────────────────────────────────────────
class PromotionsPage extends StatefulWidget {
  const PromotionsPage({super.key});

  @override
  State<PromotionsPage> createState() => _PromotionsPageState();
}

class _PromotionsPageState extends State<PromotionsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final fmt = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');

  // Mock: promotions công khai
  final List<PromotionModel> _promotions = [
    PromotionModel(
      id: 'p1', code: 'WELCOME50K', name: 'Chào mừng – Giảm 50K',
      description: 'Giảm 50.000đ cho đơn đặt sân đầu tiên từ 200K',
      discountType: PromotionDiscountType.FIXED_AMOUNT, discountValue: 50000,
      minBookingAmount: 200000, usageLimit: 1000, usageCount: 345, maxUsagePerUser: 1,
      isPublic: true, validFrom: DateTime(2026, 1, 1), validTo: DateTime(2026, 6, 30),
      status: PromotionStatus.ACTIVE,
    ),
    PromotionModel(
      id: 'p2', code: 'SUMMER20', name: 'Mùa hè 2026 – Giảm 20%',
      description: 'Giảm 20% tối đa 100K. Áp dụng sân trong nhà',
      discountType: PromotionDiscountType.PERCENTAGE, discountValue: 20, maxDiscountAmount: 100000,
      minBookingAmount: 100000, usageLimit: 500, usageCount: 122, maxUsagePerUser: 3,
      isPublic: true, validFrom: DateTime(2026, 3, 1), validTo: DateTime(2026, 8, 31),
      status: PromotionStatus.ACTIVE,
    ),
    PromotionModel(
      id: 'p3', code: 'WEEKEND15', name: 'Thứ 7 CN – Giảm 15%',
      description: 'Ưu đãi cuối tuần, không giới hạn số lần dùng mỗi người',
      discountType: PromotionDiscountType.PERCENTAGE, discountValue: 15, maxDiscountAmount: 80000,
      minBookingAmount: 80000, usageLimit: null, usageCount: 0, maxUsagePerUser: 99,
      isPublic: true, validFrom: DateTime(2026, 3, 15), validTo: DateTime(2026, 4, 30),
      status: PromotionStatus.ACTIVE,
    ),
  ];

  // Mock: voucher của user
  final List<UserVoucherModel> _myVouchers = [
    UserVoucherModel(
      id: 'uv1', userId: 'u1', promotionId: 'p1', status: VoucherStatus.UNUSED,
      expiresAt: DateTime(2026, 6, 30), createdAt: DateTime(2026, 1, 5),
      promotion: PromotionModel(
        id: 'p1', code: 'WELCOME50K', name: 'Chào mừng – Giảm 50K',
        discountType: PromotionDiscountType.FIXED_AMOUNT, discountValue: 50000,
        minBookingAmount: 200000, usageCount: 345, maxUsagePerUser: 1, isPublic: true,
        validFrom: DateTime(2026, 1, 1), validTo: DateTime(2026, 6, 30), status: PromotionStatus.ACTIVE,
      ),
    ),
    UserVoucherModel(
      id: 'uv2', userId: 'u1', promotionId: 'p4', status: VoucherStatus.USED,
      usedAt: DateTime(2026, 2, 20), createdAt: DateTime(2026, 2, 1),
      promotion: PromotionModel(
        id: 'p4', code: 'NEWYEAR30K', name: 'Tết 2026 – Giảm 30K',
        discountType: PromotionDiscountType.FIXED_AMOUNT, discountValue: 30000,
        minBookingAmount: 150000, usageCount: 1, maxUsagePerUser: 1, isPublic: false,
        validFrom: DateTime(2026, 1, 27), validTo: DateTime(2026, 2, 28), status: PromotionStatus.ACTIVE,
      ),
    ),
    UserVoucherModel(
      id: 'uv3', userId: 'u1', promotionId: 'p5', status: VoucherStatus.EXPIRED,
      expiresAt: DateTime(2026, 1, 31), createdAt: DateTime(2026, 1, 1),
      promotion: PromotionModel(
        id: 'p5', code: 'FLASH10', name: 'Flash Sale – Giảm 10%',
        discountType: PromotionDiscountType.PERCENTAGE, discountValue: 10,
        minBookingAmount: 100000, usageCount: 0, maxUsagePerUser: 1, isPublic: false,
        validFrom: DateTime(2026, 1, 1), validTo: DateTime(2026, 1, 31), status: PromotionStatus.EXPIRED,
      ),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: const Text('Khuyến mãi & Voucher', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(44),
          child: TabBar(
            controller: _tabController,
            labelColor: AppColors.primaryLightBrand,
            unselectedLabelColor: AppColors.textHint,
            indicatorColor: AppColors.primaryLightBrand,
            labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
            tabs: const [Tab(text: '🎁 Khuyến mãi'), Tab(text: '🎟️ Voucher của tôi')],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildPromotionsList(),
          _buildMyVouchers(),
        ],
      ),
    );
  }

  Widget _buildPromotionsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _promotions.length,
      itemBuilder: (ctx, i) => _PromoCard(
        promo: _promotions[i],
        fmt: fmt,
        onSave: () => _saveVoucher(_promotions[i]),
      ),
    );
  }

  Widget _buildMyVouchers() {
    final unused = _myVouchers.where((v) => v.status == VoucherStatus.UNUSED).toList();
    final history = _myVouchers.where((v) => v.status != VoucherStatus.UNUSED).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (unused.isNotEmpty) ...[
            _sectionLabel('Chưa dùng (${unused.length})'),
            const SizedBox(height: 10),
            ...unused.map((v) => _VoucherCard(voucher: v, fmt: fmt)),
            const SizedBox(height: 16),
          ],
          if (history.isNotEmpty) ...[
            _sectionLabel('Đã dùng / Hết hạn'),
            const SizedBox(height: 10),
            ...history.map((v) => _VoucherCard(voucher: v, fmt: fmt, dimmed: true)),
          ],
          if (_myVouchers.isEmpty)
            const Padding(
              padding: EdgeInsets.only(top: 80),
              child: Center(child: Text('Chưa có voucher nào', style: TextStyle(color: AppColors.textHint))),
            ),
        ],
      ),
    );
  }

  Widget _sectionLabel(String text) =>
      Text(text, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textSecondary));

  void _saveVoucher(PromotionModel promo) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('✅ Đã lưu voucher "${promo.code}"'), backgroundColor: AppColors.primaryLightBrand),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────
// PromoCard
// ──────────────────────────────────────────────────────────────────────────
class _PromoCard extends StatelessWidget {
  final PromotionModel promo;
  final NumberFormat fmt;
  final VoidCallback onSave;
  const _PromoCard({required this.promo, required this.fmt, required this.onSave});

  @override
  Widget build(BuildContext context) {
    final daysLeft = promo.daysLeft;
    final isUrgent = daysLeft <= 3;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: AppColors.black.withOpacity(0.04), blurRadius: 8)],
      ),
      child: Stack(
        children: [
          Row(
            children: [
              // ── Left accent ──
              Container(
                width: 6,
                height: 120,
                decoration: BoxDecoration(
                  color: AppColors.primaryLightBrand,
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(14), bottomLeft: Radius.circular(14)),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // discount badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(color: AppColors.primaryLightBrand.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
                        child: Text(
                          promo.discountType == PromotionDiscountType.PERCENTAGE
                              ? 'Giảm ${promo.discountValue.toStringAsFixed(0)}%'
                              : 'Giảm ${fmt.format(promo.discountValue)}',
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: AppColors.primaryLightBrand),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(promo.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                      if (promo.description != null) ...[
                        const SizedBox(height: 3),
                        Text(promo.description!, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary), maxLines: 2),
                      ],
                      const SizedBox(height: 8),
                      Row(children: [
                        const Icon(Icons.event_available_rounded, size: 12, color: AppColors.textHint),
                        const SizedBox(width: 4),
                        Text('Còn $daysLeft ngày', style: TextStyle(fontSize: 11, color: isUrgent ? AppColors.error : AppColors.textHint, fontWeight: isUrgent ? FontWeight.bold : FontWeight.normal)),
                        const SizedBox(width: 12),
                        const Icon(Icons.shopping_cart_outlined, size: 12, color: AppColors.textHint),
                        const SizedBox(width: 4),
                        Text('Từ ${fmt.format(promo.minBookingAmount)}', style: const TextStyle(fontSize: 11, color: AppColors.textHint)),
                      ]),
                    ],
                  ),
                ),
              ),
              // ── Save button ──
              Padding(
                padding: const EdgeInsets.only(right: 14),
                child: GestureDetector(
                  onTap: () {
                    HapticFeedback.mediumImpact();
                    onSave();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(color: AppColors.primaryLightBrand, borderRadius: BorderRadius.circular(10)),
                    child: const Column(mainAxisSize: MainAxisSize.min, children: [
                      Icon(Icons.bookmark_add_rounded, color: AppColors.white, size: 18),
                      SizedBox(height: 2),
                      Text('Lưu', style: TextStyle(color: AppColors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                    ]),
                  ),
                ),
              ),
            ],
          ),
          // Code tag
          Positioned(
            top: 8, right: 60,
            child: GestureDetector(
              onTap: () { Clipboard.setData(ClipboardData(text: promo.code)); ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('📋 Đã sao chép "${promo.code}"'), duration: const Duration(seconds: 1))); },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: AppColors.mutedLight, borderRadius: BorderRadius.circular(6), border: Border.all(color: AppColors.borderLight, style: BorderStyle.solid)),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Text(promo.code, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.textSecondary, letterSpacing: 0.5)),
                  const SizedBox(width: 4),
                  const Icon(Icons.copy_rounded, size: 10, color: AppColors.textHint),
                ]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────
// VoucherCard
// ──────────────────────────────────────────────────────────────────────────
class _VoucherCard extends StatelessWidget {
  final UserVoucherModel voucher;
  final NumberFormat fmt;
  final bool dimmed;
  const _VoucherCard({required this.voucher, required this.fmt, this.dimmed = false});

  @override
  Widget build(BuildContext context) {
    final promo = voucher.promotion;
    final (statusColor, statusLabel) = _voucherStatus(voucher.status);

    return Opacity(
      opacity: dimmed ? 0.55 : 1.0,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(14), boxShadow: [BoxShadow(color: AppColors.black.withOpacity(0.04), blurRadius: 8)]),
        child: Row(
          children: [
            Container(
              width: 6, height: 100,
              decoration: BoxDecoration(
                color: dimmed ? AppColors.greyLight : AppColors.primaryLightBrand,
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(14), bottomLeft: Radius.circular(14)),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Expanded(child: Text(promo.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textPrimary))),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                        decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
                        child: Text(statusLabel, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: statusColor)),
                      ),
                    ]),
                    const SizedBox(height: 4),
                    Text(
                      promo.discountType == PromotionDiscountType.PERCENTAGE
                          ? 'Giảm ${promo.discountValue.toStringAsFixed(0)}%${promo.maxDiscountAmount != null ? ' tối đa ${fmt.format(promo.maxDiscountAmount!)}' : ''}'
                          : 'Giảm ${fmt.format(promo.discountValue)}',
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: AppColors.primaryLightBrand),
                    ),
                    const SizedBox(height: 4),
                    Row(children: [
                      const Icon(Icons.tag_rounded, size: 12, color: AppColors.textHint),
                      const SizedBox(width: 3),
                      Text(promo.code, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.textSecondary, letterSpacing: 0.5)),
                      if (voucher.expiresAt != null) ...[
                        const SizedBox(width: 12),
                        const Icon(Icons.schedule_rounded, size: 12, color: AppColors.textHint),
                        const SizedBox(width: 3),
                        Text('HSD: ${DateFormat('dd/MM/yyyy').format(voucher.expiresAt!)}', style: const TextStyle(fontSize: 11, color: AppColors.textHint)),
                      ],
                    ]),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  (Color, String) _voucherStatus(VoucherStatus s) {
    switch (s) {
      case VoucherStatus.UNUSED: return (AppColors.primaryLightBrand, 'Chưa dùng');
      case VoucherStatus.USED: return (AppColors.textHint, 'Đã dùng');
      case VoucherStatus.EXPIRED: return (AppColors.error, 'Hết hạn');
    }
  }
}
