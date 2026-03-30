import 'package:dat_san_247_mobile/core/base/di/injection.dart';
import 'package:dat_san_247_mobile/core/base/state/bloc/base_state.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/features/customer/venue_search/data/models/search_history_model.dart';
import 'package:dat_san_247_mobile/features/customer/venue_search/presentation/cubit/search_history_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../widgets/venue_search_history_list.dart';
import '../widgets/venue_search_input_field.dart';

class VenueSearchPage extends StatelessWidget {
  final String? initialQuery;

  const VenueSearchPage({super.key, this.initialQuery});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<SearchHistoryCubit>()..getSearchHistory(),
      child: _VenueSearchPageContent(initialQuery: initialQuery),
    );
  }
}

class _VenueSearchPageContent extends StatefulWidget {
  final String? initialQuery;

  const _VenueSearchPageContent({this.initialQuery});

  @override
  State<_VenueSearchPageContent> createState() => _VenueSearchPageContentState();
}

class _VenueSearchPageContentState extends State<_VenueSearchPageContent> {
  late TextEditingController _searchController;
  final FocusNode _searchFocus = FocusNode();

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
    
    // Log history
    context.read<SearchHistoryCubit>().saveSearchHistory(query);
    
    // Navigate to Venue List Page
    context.push('/venues?query=${Uri.encodeComponent(query)}');
  }

  void _onHistoryItemTap(SearchHistoryModel history) {
    if (history.searchQuery != null) {
      _searchController.text = history.searchQuery!;
      _onSearch(history.searchQuery!);
    } else {
      // Handle filters if any
      final sport = history.filters?['sport'];
      if (sport != null) {
        context.push('/venues?sport=${Uri.encodeComponent(sport.toString())}');
      }
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
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      body: BlocBuilder<SearchHistoryCubit, BaseState<List<SearchHistoryModel>>>(
        builder: (context, state) {
          return state.whenReady(
            loading: (data) => const Center(child: CircularProgressIndicator()),
            success: (history, message) => VenueSearchHistoryList(
              history: history,
              onItemTap: _onHistoryItemTap,
              onClearHistory: () => context.read<SearchHistoryCubit>().clearSearchHistory(),
            ),
            failure: (error, data) => Center(child: Text(error)),
            empty: (message) => const SizedBox.shrink(),
          );
        },
      ),
    );
  }
}
