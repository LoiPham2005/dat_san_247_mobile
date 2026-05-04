import 'package:dat_san_247_mobile/core/base/state/riverpod/riverpod_listeners.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/features/owner/venue/data/models/venue_models.dart';
import 'package:dat_san_247_mobile/features/owner/venue/presentation/pages/owner_add_venue_page.dart';
import 'package:dat_san_247_mobile/features/owner/venue/presentation/pages/owner_venue_manage_page.dart';
import 'package:dat_san_247_mobile/features/owner/venue/presentation/providers/owner_venue_notifier.dart';
import 'package:dat_san_247_mobile/features/owner/venue/presentation/widgets/venue_card.dart';
import 'package:dat_san_247_mobile/features/owner/venue/presentation/widgets/venue_empty_state.dart';
import 'package:dat_san_247_mobile/features/owner/venue/presentation/widgets/venue_filter_pill.dart';
import 'package:dat_san_247_mobile/features/owner/venue/presentation/widgets/venue_stats_chip.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// ──────────────────────────────────────────────────────────────────────────
// O-02: Owner Venue List
// ──────────────────────────────────────────────────────────────────────────
class OwnerVenueListPage extends HookConsumerWidget {
  const OwnerVenueListPage({super.key});

  static const Color _brand = Color(0xFF1565C0);
  static const Color _brandDark = Color(0xFF0D47A1);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSearching = useState(false);
    final searchCtrl = useTextEditingController();

    final state = ref.watch(ownerVenueProvider);
    final notifier = ref.read(ownerVenueProvider.notifier);

    useAsyncValueListener(provider: ownerVenueProvider, ref: ref);

    if (state.isLoading && state.value == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (state.hasError && state.value == null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('${state.error}'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: notifier.refresh,
                child: const Text('Thử lại'),
              ),
            ],
          ),
        ),
      );
    }

    final data = state.value!;
    final venues = data.venues;
    final filtered = data.filteredVenues;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      body: RefreshIndicator(
        onRefresh: notifier.refresh,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              expandedHeight: 120,
              backgroundColor: _brand,
              automaticallyImplyLeading: false,
              centerTitle: false,
              title: Text(isSearching.value ? 'Tìm kiếm...' : 'Quản lý sân bãi',
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18)),
              actions: [
                IconButton(
                  icon: Icon(
                      isSearching.value ? Icons.close_rounded : Icons.search_rounded,
                      color: Colors.white),
                  onPressed: () {
                    isSearching.value = !isSearching.value;
                    if (!isSearching.value) {
                      searchCtrl.clear();
                      notifier.updateSearch('');
                    }
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.add_business_rounded, color: Colors.white),
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const OwnerAddVenuePage()),
                  ),
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        colors: [_brandDark, _brand],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight),
                  ),
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 48, 20, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (isSearching.value)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(12)),
                              child: TextField(
                                controller: searchCtrl,
                                autofocus: true,
                                style: const TextStyle(color: Colors.white),
                                decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Tìm địa điểm...',
                                    hintStyle: TextStyle(color: Colors.white60)),
                                onChanged: notifier.updateSearch,
                              ),
                            )
                          else
                            Text('${venues.length} địa điểm đang quản lý',
                                style: const TextStyle(
                                    color: Colors.white70, fontSize: 12)),
                          const SizedBox(height: 12),
                          if (!isSearching.value)
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
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
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
                      onTap: () => notifier.setFilter(null),
                    ),
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
                        onTap: () => notifier.setFilter(s),
                      ),
                    ),
                  ]),
                ),
              ),
            ),
            filtered.isEmpty
                ? SliverFillRemaining(
                    child: VenueEmptyState(
                      message: venues.isEmpty
                          ? 'Bạn chưa có sân nào. Thêm ngay!'
                          : 'Không có sân nào khớp với lọc của bạn',
                    ),
                  )
                : SliverPadding(
                    padding: const EdgeInsets.fromLTRB(12, 10, 12, 80),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (_, i) => VenueCard(
                          venue: filtered[i],
                          brand: _brand,
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) =>
                                  OwnerVenueManagePage(venueId: filtered[i].id),
                            ),
                          ),
                          onToggleActive: () => HapticFeedback.mediumImpact(),
                        ),
                        childCount: filtered.length,
                      ),
                    ),
                  ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const OwnerAddVenuePage()),
        ),
        backgroundColor: _brand,
        icon: const Icon(Icons.add_business_rounded, color: Colors.white),
        label: const Text('Thêm Sân bãi',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
