import 'package:flutter/material.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/features/customer/venue_search/data/models/search_history_model.dart';
import 'package:go_router/go_router.dart';

class VenueSearchPage extends StatefulWidget {
  final String? initialQuery;

  const VenueSearchPage({super.key, this.initialQuery});

  @override
  State<VenueSearchPage> createState() => _VenueSearchPageState();
}

class _VenueSearchPageState extends State<VenueSearchPage> {
  late TextEditingController _searchController;
  final FocusNode _searchFocus = FocusNode();

  // Mock search history base on prisma model search_history
  final List<SearchHistoryModel> _mockSearchHistory = [
    SearchHistoryModel(
      id: "1",
      userId: "user-1",
      searchQuery: "Sân bóng đá Kỳ Hòa",
      createdAt: DateTime.now().subtract(const Duration(hours: 1)),
    ),
    SearchHistoryModel(
      id: "2",
      userId: "user-1",
      sportType: "BADMINTON",
      searchQuery: "Sân cầu lông Vạn Hạnh",
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    SearchHistoryModel(
      id: "3",
      userId: "user-1",
      district: "Quận 10",
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.initialQuery);
    Future.delayed(const Duration(milliseconds: 100), () {
      _searchFocus.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  void _onSearch(String query) {
    if (query.trim().isEmpty) return;
    // Log history & navigate to Venue List Page
    GoRouter.of(context).push('/venues?query=${Uri.encodeComponent(query)}');
  }

  void _onHistoryItemTap(SearchHistoryModel history) {
    if (history.searchQuery != null) {
      _searchController.text = history.searchQuery!;
      _onSearch(history.searchQuery!);
    } else if (history.district != null) {
      GoRouter.of(context).push('/venues?district=${Uri.encodeComponent(history.district!)}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: _buildSearchInput(),
        titleSpacing: 0,
        backgroundColor: AppColors.white,
        elevation: 0,
      ),
      body: _buildSearchHistory(),
    );
  }

  Widget _buildSearchInput() {
    return Container(
      height: 40,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: AppColors.mutedLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: _searchController,
        focusNode: _searchFocus,
        textInputAction: TextInputAction.search,
        onSubmitted: _onSearch,
        decoration: InputDecoration(
          hintText: 'Tìm kiếm sân...',
          hintStyle: const TextStyle(color: AppColors.textHint, fontSize: 14),
          prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textHint, size: 20),
          suffixIcon: IconButton(
            icon: const Icon(Icons.close_rounded, color: AppColors.textHint, size: 18),
            onPressed: () {
              _searchController.clear();
            },
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 10),
        ),
      ),
    );
  }

  Widget _buildSearchHistory() {
    if (_mockSearchHistory.isEmpty) {
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
                onTap: () {
                  // Xóa lịch sử
                  setState(() {
                    _mockSearchHistory.clear();
                  });
                },
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
            itemCount: _mockSearchHistory.length,
            separatorBuilder: (context, index) => const Divider(height: 1, color: AppColors.borderLight),
            itemBuilder: (context, index) {
              final history = _mockSearchHistory[index];
              final title = history.searchQuery ?? 
                            (history.district != null ? 'Khu vực ${history.district}' : 
                            (history.sportType != null ? 'Môn thi đấu' : 'Tìm kiếm ẩn danh'));
              return ListTile(
                leading: const Icon(Icons.history_rounded, color: AppColors.textHint),
                title: Text(title, style: const TextStyle(color: AppColors.textPrimary)),
                trailing: const Icon(Icons.north_west_rounded, color: AppColors.textHint, size: 18),
                onTap: () => _onHistoryItemTap(history),
              );
            },
          ),
        ),
      ],
    );
  }
}
