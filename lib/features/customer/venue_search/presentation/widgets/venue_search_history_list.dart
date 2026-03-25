import 'package:flutter/material.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import '../../data/models/search_history_model.dart';

class VenueSearchHistoryList extends StatelessWidget {
  final List<SearchHistoryModel> history;
  final ValueChanged<SearchHistoryModel> onItemTap;
  final VoidCallback onClearHistory;

  const VenueSearchHistoryList({
    super.key,
    required this.history,
    required this.onItemTap,
    required this.onClearHistory,
  });

  @override
  Widget build(BuildContext context) {
    if (history.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Lịch sử tìm kiếm',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              InkWell(
                onTap: onClearHistory,
                child: const Text(
                  'Xóa lịch sử',
                  style: TextStyle(color: AppColors.primaryLightBrand, fontSize: 14),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: EdgeInsets.zero,
            itemCount: history.length,
            separatorBuilder: (context, index) =>
                const Divider(height: 1, color: AppColors.borderLight),
            itemBuilder: (context, index) {
              final item = history[index];
              final title = item.searchQuery ??
                  (item.district != null
                      ? 'Khu vực ${item.district}'
                      : (item.sportType != null ? 'Môn thi đấu' : 'Tìm kiếm ẩn danh'));
              return ListTile(
                leading: const Icon(Icons.history_rounded, color: AppColors.textHint),
                title: Text(title, style: const TextStyle(color: AppColors.textPrimary)),
                trailing: const Icon(Icons.north_west_rounded, color: AppColors.textHint, size: 18),
                onTap: () => onItemTap(item),
              );
            },
          ),
        ),
      ],
    );
  }
}
