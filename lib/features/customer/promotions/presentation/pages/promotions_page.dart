import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/features/customer/promotions/data/models/promotion_model.dart';
import '../widgets/promo_card.dart';
import '../widgets/voucher_card.dart';

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
        title: const Text('Khuyến mãi & Voucher',
            style: TextStyle(
                fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
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
        children: [_buildPromotionsList(), _buildMyVouchers()],
      ),
    );
  }

  Widget _buildPromotionsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _promotions.length,
      itemBuilder: (ctx, i) => PromoCard(
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
            ...unused.map((v) => VoucherCard(voucher: v, fmt: fmt)),
            const SizedBox(height: 16),
          ],
          if (history.isNotEmpty) ...[
            _sectionLabel('Đã dùng / Hết hạn'),
            const SizedBox(height: 10),
            ...history.map((v) => VoucherCard(voucher: v, fmt: fmt, dimmed: true)),
          ],
          if (_myVouchers.isEmpty)
            const Padding(
              padding: EdgeInsets.only(top: 80),
              child: Center(
                  child: Text('Chưa có voucher nào', style: TextStyle(color: AppColors.textHint))),
            ),
        ],
      ),
    );
  }

  Widget _sectionLabel(String text) => Text(text,
      style: const TextStyle(
          fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textSecondary));

  void _saveVoucher(PromotionModel promo) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text('✅ Đã lưu voucher "${promo.code}"'),
          backgroundColor: AppColors.primaryLightBrand),
    );
  }
}
