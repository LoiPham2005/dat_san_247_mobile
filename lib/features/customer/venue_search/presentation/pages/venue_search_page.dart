import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/features/customer/venue_search/data/models/search_history_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/venue_search_history_list.dart';
import '../widgets/venue_search_input_field.dart';

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
        title: VenueSearchInputField(
          controller: _searchController,
          focusNode: _searchFocus,
          onSubmitted: _onSearch,
          onClear: () => _searchController.clear(),
        ),
        titleSpacing: 0,
        backgroundColor: AppColors.white,
        elevation: 0,
      ),
      body: VenueSearchHistoryList(
        history: _mockSearchHistory,
        onItemTap: _onHistoryItemTap,
        onClearHistory: () {
          setState(() {
            _mockSearchHistory.clear();
          });
        },
      ),
    );
  }
}
