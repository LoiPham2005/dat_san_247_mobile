import 'package:dat_san_247_mobile/core/base/state/riverpod/riverpod_listeners.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/features/customer/promotions/data/models/promotion_model.dart';
import 'package:dat_san_247_mobile/features/customer/promotions/data/models/user_voucher_model.dart';
import 'package:dat_san_247_mobile/features/customer/promotions/presentation/providers/promotion_notifier.dart';
import 'package:dat_san_247_mobile/features/customer/promotions/presentation/widgets/voucher_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../widgets/promo_card.dart';

class PromotionsPage extends HookConsumerWidget {
  const PromotionsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabController = useTabController(initialLength: 2);
    final fmt = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');

    final state = ref.watch(promotionProvider);
    final notifier = ref.read(promotionProvider.notifier);

    useAsyncValueListener(provider: promotionProvider, ref: ref);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Khuyến mãi & Voucher',
          style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(44),
          child: TabBar(
            controller: tabController,
            labelColor: AppColors.primaryLightBrand,
            unselectedLabelColor: AppColors.textHint,
            indicatorColor: AppColors.primaryLightBrand,
            labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
            tabs: const [
              Tab(text: '🎁 Khuyến mãi'),
              Tab(text: '🎟️ Voucher của tôi'),
            ],
          ),
        ),
      ),
      body: switch (state) {
        AsyncData(:final value) => TabBarView(
            controller: tabController,
            children: [
              _buildPromotionsList(context, notifier, fmt, value.promotions),
              _buildMyVouchers(context, notifier, fmt, value.myVouchers),
            ],
          ),
        AsyncError(:final error) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: AppColors.error),
                const SizedBox(height: 16),
                Text('$error'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: notifier.refresh,
                  child: const Text('Thử lại'),
                ),
              ],
            ),
          ),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }

  Widget _buildPromotionsList(
    BuildContext context,
    PromotionNotifier notifier,
    NumberFormat fmt,
    List<PromotionModel> promotions,
  ) {
    if (promotions.isEmpty) {
      return RefreshIndicator(
        onRefresh: notifier.refresh,
        child: ListView(
          children: const [
            SizedBox(height: 200),
            Center(child: Text('Hiện không có khuyến mãi nào')),
          ],
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: notifier.refresh,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: promotions.length,
        itemBuilder: (ctx, i) => PromoCard(
          promo: promotions[i],
          fmt: fmt,
          onSave: () => _saveVoucher(context, notifier, promotions[i]),
        ),
      ),
    );
  }

  Widget _buildMyVouchers(
    BuildContext context,
    PromotionNotifier notifier,
    NumberFormat fmt,
    List<UserVoucherModel> vouchers,
  ) {
    if (vouchers.isEmpty) {
      return RefreshIndicator(
        onRefresh: notifier.refresh,
        child: ListView(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.2),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.confirmation_num_outlined,
                      size: 64,
                      color: AppColors.textHint.withOpacity(0.3)),
                  const SizedBox(height: 16),
                  const Text('Bạn chưa có voucher nào',
                      style: TextStyle(color: AppColors.textHint, fontSize: 13)),
                  const SizedBox(height: 6),
                  const Text('Lưu khuyến mãi để sử dụng khi đặt sân',
                      style: TextStyle(color: AppColors.textHint, fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
      );
    }

    final unused = vouchers.where((v) => v.status == VoucherStatus.UNUSED).toList();
    final history = vouchers.where((v) => v.status != VoucherStatus.UNUSED).toList();

    return RefreshIndicator(
      onRefresh: notifier.refresh,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
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
          ],
        ),
      ),
    );
  }

  Widget _sectionLabel(String text) => Text(
        text,
        style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: AppColors.textSecondary),
      );

  void _saveVoucher(
    BuildContext context,
    PromotionNotifier notifier,
    PromotionModel promo,
  ) {
    notifier.collectPromotion(promo.id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('⏳ Đang lưu voucher "${promo.code}"...'),
        backgroundColor: AppColors.primaryLightBrand,
      ),
    );
  }
}
