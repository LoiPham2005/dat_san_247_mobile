import 'package:dat_san_247_mobile/core/base/di/injection.dart';
import 'package:dat_san_247_mobile/core/base/state/base_status.dart';
import 'package:dat_san_247_mobile/core/base/state/bloc/base_state.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/features/owner/venue/data/models/venue_models.dart';
import 'package:dat_san_247_mobile/features/owner/venue/presentation/cubit/owner_venue_cubit.dart';
import 'package:dat_san_247_mobile/features/owner/venue/presentation/pages/owner_add_venue_page.dart';
import 'package:dat_san_247_mobile/features/owner/venue/presentation/pages/owner_venue_manage_page.dart';
import 'package:dat_san_247_mobile/features/owner/venue/presentation/widgets/venue_card.dart';
import 'package:dat_san_247_mobile/features/owner/venue/presentation/widgets/venue_empty_state.dart';
import 'package:dat_san_247_mobile/features/owner/venue/presentation/widgets/venue_filter_pill.dart';
import 'package:dat_san_247_mobile/features/owner/venue/presentation/widgets/venue_stats_chip.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ──────────────────────────────────────────────────────────────────────────
// O-02: Owner Venue List
// ──────────────────────────────────────────────────────────────────────────
class OwnerVenueListPage extends StatelessWidget {
  const OwnerVenueListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<OwnerVenueCubit>()..fetchVenues(),
      child: const _OwnerVenueListView(),
    );
  }
}

class _OwnerVenueListView extends StatefulWidget {
  const _OwnerVenueListView();

  @override
  State<_OwnerVenueListView> createState() => _OwnerVenueListViewState();
}

class _OwnerVenueListViewState extends State<_OwnerVenueListView> {
  static const Color _brand = Color(0xFF1565C0);
  static const Color _brandDark = Color(0xFF0D47A1);

  bool _isSearching = false;
  final _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      body: BlocBuilder<OwnerVenueCubit, BaseState<OwnerVenueListState>>(
        builder: (context, state) {
          if (state.status == BaseStatus.initial || (state.isLoading && !state.hasData)) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.isFailure) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.error ?? 'Lỗi tải danh sách sân'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.read<OwnerVenueCubit>().refresh(),
                    child: const Text('Thử lại'),
                  ),
                ],
              ),
            );
          }

          final data = state.data!;
          final venues = data.venues;
          final filtered = data.filteredVenues;

          return RefreshIndicator(
            onRefresh: () => context.read<OwnerVenueCubit>().refresh(),
            child: CustomScrollView(
              slivers: [
                // ── AppBar ──
                SliverAppBar(
                  pinned: true,
                  expandedHeight: 120,
                  backgroundColor: _brand,
                  automaticallyImplyLeading: false,
                  centerTitle: false,
                  title: Text(_isSearching ? 'Tìm kiếm...' : 'Quản lý sân bãi',
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                  actions: [
                    IconButton(
                        icon: Icon(_isSearching ? Icons.close_rounded : Icons.search_rounded,
                            color: Colors.white),
                        onPressed: () {
                          setState(() {
                            _isSearching = !_isSearching;
                            if (!_isSearching) {
                              _searchCtrl.clear();
                              context.read<OwnerVenueCubit>().updateSearch('');
                            }
                          });
                        }),
                    IconButton(
                        icon: const Icon(Icons.add_business_rounded, color: Colors.white),
                        onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => BlocProvider.value(
                                  value: context.read<OwnerVenueCubit>(),
                                  child: const OwnerAddVenuePage(),
                                )))),
                  ],
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      decoration: const BoxDecoration(
                          gradient: LinearGradient(
                              colors: [_brandDark, _brand],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight)),
                      child: SafeArea(
                          child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 48, 20, 0),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          if (_isSearching)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(12)),
                              child: TextField(
                                controller: _searchCtrl,
                                autofocus: true,
                                style: const TextStyle(color: Colors.white),
                                decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Tìm địa điểm...',
                                    hintStyle: TextStyle(color: Colors.white60)),
                                onChanged: (v) => context.read<OwnerVenueCubit>().updateSearch(v),
                              ),
                            )
                          else ...[
                            Text('${venues.length} địa điểm đang quản lý',
                                style: const TextStyle(color: Colors.white70, fontSize: 12)),
                          ],
                          const SizedBox(height: 12),
                          // Stats row
                          if (!_isSearching)
                            Row(children: [
                              VenueStatsChip(
                                  label: 'Đã duyệt',
                                  count: data.countStatus(VenueStatus.APPROVED),
                                  color: AppColors.success),
                              const SizedBox(width: 8),
                              VenueStatsChip(
                                  label: 'Chờ duyệt',
                                  count: data.countStatus(VenueStatus.PENDING),
                                  color: AppColors.warning),
                              const SizedBox(width: 8),
                              VenueStatsChip(
                                  label: 'Từ chối',
                                  count: data.countStatus(VenueStatus.REJECTED),
                                  color: AppColors.error),
                            ]),
                        ]),
                      )),
                    ),
                  ),
                ),

                // ── Status filter ──
                SliverToBoxAdapter(
                  child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(children: [
                        VenueFilterPill(
                            label: 'Tất cả',
                            selected: data.filterStatus == null,
                            brand: _brand,
                            onTap: () => context.read<OwnerVenueCubit>().setFilter(null)),
                        ...[
                          VenueStatus.APPROVED,
                          VenueStatus.PENDING,
                          VenueStatus.REJECTED,
                          VenueStatus.SUSPENDED
                        ].map(
                          (s) => VenueFilterPill(
                              label: s.label,
                              selected: data.filterStatus == s,
                              brand: _brand,
                              count: data.countStatus(s),
                              onTap: () => context.read<OwnerVenueCubit>().setFilter(s)),
                        ),
                      ]),
                    ),
                  ),
                ),

                // ── Venue list ──
                filtered.isEmpty
                    ? SliverFillRemaining(
                        child: VenueEmptyState(
                            message: venues.isEmpty
                                ? 'Bạn chưa có sân nào. Thêm ngay!'
                                : 'Không có sân nào khớp với lọc của bạn'))
                    : SliverPadding(
                        padding: const EdgeInsets.fromLTRB(12, 10, 12, 80),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (_, i) => VenueCard(
                              venue: filtered[i],
                              brand: _brand,
                              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                                  builder: (_) => OwnerVenueManagePage(venueId: filtered[i].id))),
                              onToggleActive: () => HapticFeedback.mediumImpact(),
                            ),
                            childCount: filtered.length,
                          ),
                        ),
                      ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => BlocProvider.value(
                  value: context.read<OwnerVenueCubit>(),
                  child: const OwnerAddVenuePage(),
                ))),
        backgroundColor: _brand,
        icon: const Icon(Icons.add_business_rounded, color: Colors.white),
        label: const Text('Thêm Sân bãi',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
