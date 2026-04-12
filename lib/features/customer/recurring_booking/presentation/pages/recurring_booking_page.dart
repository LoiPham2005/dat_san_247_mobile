import 'package:dat_san_247_mobile/core/base/state/bloc/base_state.dart';
import 'package:dat_san_247_mobile/features/customer/recurring_booking/data/models/recurring_booking_model.dart';
import 'package:dat_san_247_mobile/features/customer/recurring_booking/presentation/cubit/recurring_booking_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import '../widgets/recurring_booking_card.dart';

// ──────────────────────────────────────────────────────────────────────────
// C-13: Lịch Định Kỳ
// ──────────────────────────────────────────────────────────────────────────
class RecurringBookingPage extends StatefulWidget {
  const RecurringBookingPage({super.key});

  @override
  State<RecurringBookingPage> createState() => _RecurringBookingPageState();
}

class _RecurringBookingPageState extends State<RecurringBookingPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedTab = 0; // 0=Đang hoạt động, 1=Đã dừng

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) setState(() => _selectedTab = _tabController.index);
    });
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
        title: const Text('Lịch đặt định kỳ',
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
            tabs: const [Tab(text: 'Đang hoạt động'), Tab(text: 'Đã dừng')],
          ),
        ),
      ),
      body: BlocBuilder<RecurringBookingCubit, BaseState<List<RecurringBookingModel>>>(
        builder: (context, state) {
          return state.when(
            initial: () => const Center(child: CircularProgressIndicator()),
            loading: (previousData) => previousData == null 
                ? const Center(child: CircularProgressIndicator()) 
                : _buildList(previousData),
            success: (data, message) {
              final filtered = data.where((r) => _selectedTab == 0 ? r.isActive : !r.isActive).toList();
              return filtered.isEmpty ? _buildEmpty() : _buildList(filtered);
            },
            failure: (error, data) => Center(child: Text(error)),
            empty: (message) => _buildEmpty(),
          );
        },
      ),
    );
  }

  Widget _buildList(List<RecurringBookingModel> filteredList) {
    return RefreshIndicator(
      onRefresh: () => context.read<RecurringBookingCubit>().getBookings(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: filteredList.length,
        itemBuilder: (ctx, i) => RecurringBookingCard(
          item: filteredList[i],
          onToggle: (item) => _toggleActive(item),
        ),
      ),
    );
  }

  void _toggleActive(RecurringBookingModel item) async {
    final action = item.isActive ? 'tạm dừng' : 'kích hoạt lại';
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('${item.isActive ? 'Tạm dừng' : 'Kích hoạt'} lịch định kỳ?'),
        content: Text('Bạn muốn $action lịch đặt "${item.courtName}" tại "${item.venueName}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Huỷ')),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: item.isActive ? AppColors.error : AppColors.primaryLightBrand,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text(item.isActive ? 'Tạm dừng' : 'Kích hoạt',
                style: const TextStyle(color: AppColors.white)),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      context.read<RecurringBookingCubit>().toggleStatus(item.id, item.isActive);
    }
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
                color: AppColors.primaryLightBrand.withOpacity(0.08), shape: BoxShape.circle),
            child: const Icon(Icons.repeat_rounded, size: 44, color: AppColors.primaryLightBrand),
          ),
          const SizedBox(height: 16),
          const Text('Chưa có lịch định kỳ',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          const Text('Lịch định kỳ được tạo khi bạn đặt sân hằng tuần',
              style: TextStyle(color: AppColors.textHint, fontSize: 13)),
        ],
      ),
    );
  }
}
