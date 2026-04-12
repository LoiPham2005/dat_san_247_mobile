import 'package:dat_san_247_mobile/core/base/state/bloc/base_state.dart';
import 'package:dat_san_247_mobile/features/customer/promotions/data/models/user_voucher_model.dart';
import 'package:dat_san_247_mobile/features/customer/promotions/presentation/cubit/promotion_cubit.dart';
import 'package:dat_san_247_mobile/features/customer/promotions/presentation/widgets/voucher_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/features/customer/promotions/data/models/promotion_model.dart';
import '../widgets/promo_card.dart';

class PromotionsPage extends StatefulWidget {
  const PromotionsPage({super.key});

  @override
  State<PromotionsPage> createState() => _PromotionsPageState();
}

class _PromotionsPageState extends State<PromotionsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final fmt = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');

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
      body: BlocBuilder<PromotionCubit, BaseState<PromotionData>>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.isFailure) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: AppColors.error),
                  const SizedBox(height: 16),
                  Text(state.message ?? 'Đã có lỗi xảy ra'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.read<PromotionCubit>().fetchAll(),
                    child: const Text('Thử lại'),
                  ),
                ],
              ),
            );
          }

          final data = state.data ?? PromotionData();

          return TabBarView(
            controller: _tabController,
            children: [
              _buildPromotionsList(data.promotions),
              _buildMyVouchers(data.myVouchers),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPromotionsList(List<PromotionModel> promotions) {
    if (promotions.isEmpty) {
      return const Center(child: Text('Hiện không có khuyến mãi nào'));
    }

    return RefreshIndicator(
      onRefresh: () => context.read<PromotionCubit>().fetchAll(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: promotions.length,
        itemBuilder: (ctx, i) => PromoCard(
          promo: promotions[i],
          fmt: fmt,
          onSave: () => _saveVoucher(promotions[i]),
        ),
      ),
    );
  }

  Widget _buildMyVouchers(List<UserVoucherModel> vouchers) {
    if (vouchers.isEmpty) {
      return RefreshIndicator(
        onRefresh: () => context.read<PromotionCubit>().fetchAll(),
        child: ListView(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.2),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.confirmation_num_outlined, size: 64, color: AppColors.textHint.withOpacity(0.3)),
                  const SizedBox(height: 16),
                  const Text('Bạn chưa có voucher nào', style: TextStyle(color: AppColors.textHint, fontSize: 13)),
                  const SizedBox(height: 6),
                  const Text('Lưu khuyến mãi để sử dụng khi đặt sân', style: TextStyle(color: AppColors.textHint, fontSize: 12)),
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
      onRefresh: () => context.read<PromotionCubit>().fetchAll(),
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

  Widget _sectionLabel(String text) => Text(text,
      style: const TextStyle(
          fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textSecondary));

  void _saveVoucher(PromotionModel promo) {
    context.read<PromotionCubit>().collectPromotion(promo.id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text('⏳ Đang lưu voucher "${promo.code}"...'),
          backgroundColor: AppColors.primaryLightBrand),
    );
  }
}
