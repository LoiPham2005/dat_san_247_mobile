import 'package:dat_san_247_mobile/core/base/state/bloc/base_state.dart';
import 'package:dat_san_247_mobile/features/customer/waitlist/presentation/cubit/waitlist_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/features/customer/waitlist/data/models/waitlist_model.dart';
import '../widgets/waitlist_card.dart';

class MyWaitlistPage extends StatefulWidget {
  const MyWaitlistPage({super.key});

  @override
  State<MyWaitlistPage> createState() => _MyWaitlistPageState();
}

class _MyWaitlistPageState extends State<MyWaitlistPage> {
  Future<void> _cancelWaitlist(WaitlistModel item) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Hủy khỏi danh sách chờ?'),
        content:
            Text('Bạn sẽ mất vị trí #${item.priority} trong danh sách chờ của "${item.courtName}".'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Giữ lại')),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
            child: const Text('Hủy chờ', style: TextStyle(color: AppColors.white)),
          ),
        ],
      ),
    );
    
    if (confirmed == true && mounted) {
      context.read<WaitlistCubit>().cancelWaitlist(item.id);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('✅ Đã gửi yêu cầu hủy danh sách chờ'),
          backgroundColor: AppColors.primaryLightBrand));
    }
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
        title: const Text('Danh sách chờ',
            style: TextStyle(
                fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
      ),
      body: BlocBuilder<WaitlistCubit, BaseState<List<WaitlistModel>>>(
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
                    onPressed: () => context.read<WaitlistCubit>().getWaitlist(),
                    child: const Text('Thử lại'),
                  ),
                ],
              ),
            );
          }

          final list = state.data ?? [];
          if (list.isEmpty) return _buildEmpty();

          final activeList = list.where((w) => w.status == WaitlistStatus.WAITING || w.status == WaitlistStatus.NOTIFIED).toList();
          final historyList = list.where((w) => w.status != WaitlistStatus.WAITING && w.status != WaitlistStatus.NOTIFIED).toList();

          return _buildContent(activeList, historyList);
        },
      ),
    );
  }

  Widget _buildContent(List<WaitlistModel> activeList, List<WaitlistModel> historyList) {
    return RefreshIndicator(
      onRefresh: () => context.read<WaitlistCubit>().getWaitlist(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoBanner(),
            const SizedBox(height: 16),

            if (activeList.isNotEmpty) ...[
              _SectionLabel(label: '⏳ Đang chờ (${activeList.length})'),
              const SizedBox(height: 10),
              ...activeList.map((w) => WaitlistCard(item: w, onCancel: () => _cancelWaitlist(w))),
              const SizedBox(height: 16),
            ],

            if (historyList.isNotEmpty) ...[
              _SectionLabel(label: 'Lịch sử'),
              const SizedBox(height: 10),
              ...historyList.map((w) => WaitlistCard(item: w, onCancel: null)),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoBanner() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.info.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.info.withOpacity(0.2)),
      ),
      child: const Row(
        children: [
          Icon(Icons.info_outline_rounded, color: AppColors.info, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Bạn sẽ nhận thông báo khi có slot trống. Thứ tự ưu tiên càng thấp → được thông báo trước.',
              style: TextStyle(fontSize: 12, color: AppColors.info),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty() {
    return RefreshIndicator(
      onRefresh: () => context.read<WaitlistCubit>().getWaitlist(),
      child: ListView(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.2),
          const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.queue_rounded, size: 64, color: AppColors.primaryLightBrand),
                SizedBox(height: 16),
                Text('Danh sách chờ trống',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                SizedBox(height: 6),
                Text('Đăng ký chờ khi sân đầy để không bỏ lỡ slot',
                    style: TextStyle(color: AppColors.textHint, fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) => Text(label,
      style: const TextStyle(
          fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textSecondary));
}
