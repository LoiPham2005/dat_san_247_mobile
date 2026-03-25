import 'package:flutter/material.dart';
import '../widgets/deals_app_bar.dart';
import '../widgets/deals_promo_banner.dart';
import '../widgets/deals_category_filter.dart';
import '../widgets/voucher_card.dart';

export 'package:dat_san_247_mobile/features/customer/booking/presentation/pages/my_bookings_page.dart' show MyBookingsPage;

class DealsPage extends StatefulWidget {
  const DealsPage({super.key});

  @override
  State<DealsPage> createState() => _DealsPageState();
}

class _DealsPageState extends State<DealsPage> {
  int _selectedCategoryIndex = 0;
  final List<String> _categories = ['Tất cả', 'Sân cỏ', 'Cầu lông', 'Tennis', 'Ưu đãi mới'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
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
          _buildVoucherList(),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  Widget _buildVoucherList() {
    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) => VoucherCard(index: index),
          childCount: 8,
        ),
      ),
    );
  }
}
