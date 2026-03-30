import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dat_san_247_mobile/core/base/di/injection.dart';
import 'package:dat_san_247_mobile/core/base/state/bloc/base_state.dart';
import 'package:dat_san_247_mobile/features/customer/deals/presentation/cubit/deals_cubit.dart';
import 'package:dat_san_247_mobile/features/customer/deals/presentation/widgets/deals_app_bar.dart';
import 'package:dat_san_247_mobile/features/customer/deals/presentation/widgets/deals_promo_banner.dart';
import 'package:dat_san_247_mobile/features/customer/deals/presentation/widgets/deals_category_filter.dart';
import 'package:dat_san_247_mobile/features/customer/deals/presentation/widgets/voucher_card.dart';
import 'package:dat_san_247_mobile/features/customer/deals/data/models/promotion_model.dart';

class DealsPage extends StatefulWidget {
  const DealsPage({super.key});

  @override
  State<DealsPage> createState() => _DealsPageState();
}

class _DealsPageState extends State<DealsPage> {
  int _selectedCategoryIndex = 0;
  final List<String> _categories = ['Tất cả', 'Voucher sân', 'Cầu lông', 'Bóng đá', 'Ưu đãi hot'];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<DealsCubit>()..fetchDeals(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        body: RefreshIndicator(
          onRefresh: () async {
             // Will be handled by BlocProvider if we trigger fetch again
          },
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            slivers: [
              const DealsAppBar(),
              const DealsPromoBanner(),
              DealsCategoryFilter(
                selectedIndex: _selectedCategoryIndex,
                categories: _categories,
                onCategoryChanged: (index) {
                  setState(() {
                    _selectedCategoryIndex = index;
                  });
                },
              ),
              BlocBuilder<DealsCubit, BaseState<PromotionsResponse>>(
                builder: (context, state) {
                  if (state.isLoading && state.data == null) {
                    return const SliverFillRemaining(
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  if (state.isFailure) {
                    return SliverFillRemaining(
                      child: Center(child: Text(state.error ?? 'Lỗi tải khuyến mãi')),
                    );
                  }

                  final deals = state.data?.data ?? [];
                  if (deals.isEmpty) {
                    return const SliverFillRemaining(
                      child: Center(child: Text('Hiện chưa có chương trình ưu đãi nào')),
                    );
                  }

                  return SliverPadding(
                    padding: const EdgeInsets.all(16),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => VoucherCard(promotion: deals[index]),
                        childCount: deals.length,
                      ),
                    ),
                  );
                },
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),
        ),
      ),
    );
  }
}
