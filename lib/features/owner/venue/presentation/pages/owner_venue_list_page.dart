import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/features/owner/venue/data/models/venue_models.dart';
import 'package:dat_san_247_mobile/features/owner/venue/presentation/pages/owner_venue_manage_page.dart';
import 'package:dat_san_247_mobile/features/owner/venue/presentation/widgets/venue_card.dart';
import 'package:dat_san_247_mobile/features/owner/venue/presentation/widgets/venue_empty_state.dart';
import 'package:dat_san_247_mobile/features/owner/venue/presentation/widgets/venue_filter_pill.dart';
import 'package:dat_san_247_mobile/features/owner/venue/presentation/widgets/venue_stats_chip.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ══════════════════════════════════════════════════════════════════════════════
// O-02: Danh Sách Venue Của Tôi
// DB: venues (owner_id=me, deleted_at IS NULL), courts (venue_id, is_active)
// ══════════════════════════════════════════════════════════════════════════════
class OwnerVenueListPage extends StatefulWidget {
  const OwnerVenueListPage({super.key});

  @override
  State<OwnerVenueListPage> createState() => _OwnerVenueListPageState();
}

class _OwnerVenueListPageState extends State<OwnerVenueListPage> {
  static const Color _brand = Color(0xFF1565C0); // Owner brand = cyan/teal
  static const Color _brandDark = Color(0xFF1565C0);

  VenueStatus? _filterStatus;
  bool _isSearching = false;
  String _searchQuery = '';
  final _searchCtrl = TextEditingController();

  final List<OwnerVenueModel> _venues = _buildMock();

  static List<OwnerVenueModel> _buildMock() {
    final now = DateTime.now();
    return [
      OwnerVenueModel(
        id: 'v1',
        ownerId: 'u1',
        name: 'Sân K34 Phạm Văn Đồng',
        slug: 'san-k34-pham-van-dong',
        description: 'Cụm sân bóng đá chất lượng cao, có đèn chiếu sáng, bãi đỗ xe rộng.',
        address: '34 Phạm Văn Đồng',
        city: 'Hà Nội',
        district: 'Bắc Từ Liêm',
        phone: '02438569900',
        email: 'k34@example.com',
        status: VenueStatus.APPROVED,
        isActive: true,
        isFeatured: true,
        rating: 4.7,
        totalReviews: 128,
        autoAcceptBookings: true,
        vatRate: 8,
        minBookingHours: 1,
        cancellationBeforeHours: 24,
        courtCount: 6,
        sportTypes: ['FOOTBALL'],
        createdAt: now.subtract(const Duration(days: 365)),
        updatedAt: now,
      ),
      OwnerVenueModel(
        id: 'v2',
        ownerId: 'u1',
        name: 'Cầu Lông Tây Hồ',
        slug: 'cau-long-tay-ho',
        description: 'Sân cầu lông tiêu chuẩn, có máy lạnh.',
        address: '12 Nguyễn Đình Thi',
        city: 'Hà Nội',
        district: 'Tây Hồ',
        phone: '02432551234',
        status: VenueStatus.APPROVED,
        isActive: true,
        rating: 4.5,
        totalReviews: 76,
        autoAcceptBookings: false,
        vatRate: 0,
        minBookingHours: 1,
        cancellationBeforeHours: 12,
        courtCount: 3,
        sportTypes: ['BADMINTON'],
        createdAt: now.subtract(const Duration(days: 180)),
        updatedAt: now,
      ),
      OwnerVenueModel(
        id: 'v3',
        ownerId: 'u1',
        name: 'Thể Thao Cầu Giấy',
        slug: 'the-thao-cau-giay',
        description: 'Sân đa năng: bóng đá, bóng rổ, cầu lông.',
        address: '88 Dịch Vọng Hậu',
        city: 'Hà Nội',
        district: 'Cầu Giấy',
        phone: '02437651122',
        status: VenueStatus.PENDING,
        isActive: false,
        rating: 0,
        totalReviews: 0,
        courtCount: 0,
        sportTypes: ['FOOTBALL', 'BASKETBALL', 'BADMINTON'],
        createdAt: now.subtract(const Duration(days: 7)),
        updatedAt: now,
      ),
      OwnerVenueModel(
        id: 'v4',
        ownerId: 'u1',
        name: 'Sân Đất Nện Hoàng Mai',
        slug: 'san-dat-nen-hoang-mai',
        description: 'Sân tennis đất nện cao cấp.',
        address: '56 Tam Trinh',
        city: 'Hà Nội',
        district: 'Hoàng Mai',
        status: VenueStatus.REJECTED,
        rejectionReason: 'Giấy phép kinh doanh chưa hợp lệ.',
        isActive: false,
        rating: 0,
        totalReviews: 0,
        courtCount: 0,
        sportTypes: ['TENNIS'],
        createdAt: now.subtract(const Duration(days: 14)),
        updatedAt: now,
      ),
    ];
  }

  List<OwnerVenueModel> get _filtered {
    var list = _venues.where((v) => _filterStatus == null || v.status == _filterStatus).toList();
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      list = list
          .where((v) => v.name.toLowerCase().contains(q) || v.district.toLowerCase().contains(q))
          .toList();
    }
    return list;
  }

  int _countStatus(VenueStatus s) => _venues.where((v) => v.status == s).length;

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      body: CustomScrollView(
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
                        _searchQuery = '';
                        _searchCtrl.clear();
                      }
                    });
                  }),
              IconButton(
                  icon: const Icon(Icons.add_business_rounded, color: Colors.white),
                  onPressed: () => _showCreateVenueSheet(context)),
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
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12)),
                        child: TextField(
                          controller: _searchCtrl,
                          autofocus: true,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Tìm venue...',
                              hintStyle: TextStyle(color: Colors.white60)),
                          onChanged: (v) => setState(() => _searchQuery = v),
                        ),
                      )
                    else ...[
                      // const SizedBox(height: 38),
                      // const Text('Sân của tôi',
                      //     style: TextStyle(
                      //         color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900)),
                      Text('${_venues.length} địa điểm đang quản lý',
                          style: const TextStyle(color: Colors.white70, fontSize: 12)),
                    ],
                    const SizedBox(height: 12),
                    // Stats row
                    if (!_isSearching)
                      Row(children: [
                        VenueStatsChip(
                            label: 'Đã duyệt',
                            count: _countStatus(VenueStatus.APPROVED),
                            color: AppColors.success),
                        const SizedBox(width: 8),
                        VenueStatsChip(
                            label: 'Chờ duyệt',
                            count: _countStatus(VenueStatus.PENDING),
                            color: AppColors.warning),
                        const SizedBox(width: 8),
                        VenueStatsChip(
                            label: 'Từ chối',
                            count: _countStatus(VenueStatus.REJECTED),
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
                      selected: _filterStatus == null,
                      brand: _brand,
                      onTap: () => setState(() => _filterStatus = null)),
                  ...[
                    VenueStatus.APPROVED,
                    VenueStatus.PENDING,
                    VenueStatus.REJECTED,
                    VenueStatus.SUSPENDED
                  ].map(
                    (s) => VenueFilterPill(
                        label: s.label,
                        selected: _filterStatus == s,
                        brand: _brand,
                        count: _countStatus(s),
                        onTap: () => setState(() => _filterStatus = _filterStatus == s ? null : s)),
                  ),
                ]),
              ),
            ),
          ),

          // ── Venue list ──
          filtered.isEmpty
              ? const SliverFillRemaining(child: VenueEmptyState(message: 'Không có venue nào'))
              : SliverPadding(
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 80),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (_, i) => VenueCard(
                        venue: filtered[i],
                        brand: _brand,
                        onTap: () => Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => OwnerVenueManagePage(venueId: filtered[i].id))),
                        onToggleActive: () => setState(() {
                          HapticFeedback.selectionClick();
                        }),
                      ),
                      childCount: filtered.length,
                    ),
                  ),
                ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateVenueSheet(context),
        backgroundColor: _brand,
        icon: const Icon(Icons.add_business_rounded, color: Colors.white),
        label: const Text('Thêm Venue',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  void _showCreateVenueSheet(BuildContext context) {
    final nameCtrl = TextEditingController();
    final addressCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                    child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                            color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)))),
                const SizedBox(height: 14),
                const Row(children: [
                  Icon(Icons.add_business_rounded, color: _brand, size: 22),
                  SizedBox(width: 8),
                  Text('Tạo Venue Mới',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ]),
                const SizedBox(height: 4),
                const Text('Thông tin cơ bản — bổ sung chi tiết sau khi tạo',
                    style: TextStyle(fontSize: 11, color: AppColors.textHint)),
                const SizedBox(height: 16),
                _FormField(
                    controller: nameCtrl, label: 'Tên venue *', hint: 'VD: Sân K34 Phạm Văn Đồng'),
                const SizedBox(height: 10),
                _FormField(
                    controller: addressCtrl,
                    label: 'Địa chỉ *',
                    hint: '34 Phạm Văn Đồng, Bắc Từ Liêm, Hà Nội'),
                const SizedBox(height: 10),
                _FormField(
                    controller: phoneCtrl,
                    label: 'Số điện thoại liên hệ',
                    hint: '024...',
                    keyboardType: TextInputType.phone),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: AppColors.warning.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.warning.withOpacity(0.3))),
                  child: const Row(children: [
                    Icon(Icons.info_outline_rounded, size: 16, color: AppColors.warning),
                    SizedBox(width: 8),
                    Expanded(
                        child: Text(
                            'Sau khi tạo, bạn cần nộp hồ sơ xác minh để venue được duyệt hoạt động.',
                            style: TextStyle(fontSize: 11, color: AppColors.warning))),
                  ]),
                ),
                const SizedBox(height: 16),
                SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (nameCtrl.text.isEmpty || addressCtrl.text.isEmpty) return;
                        Navigator.pop(ctx);
                        HapticFeedback.mediumImpact();
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('✅ Đã tạo venue: ${nameCtrl.text}'),
                            backgroundColor: AppColors.success));
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: _brand,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                      child: const Text('Tạo Venue',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    )),
              ]),
        ),
      ),
    );
  }
}

class _FormField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final TextInputType keyboardType;
  const _FormField(
      {required this.controller,
      required this.label,
      required this.hint,
      this.keyboardType = TextInputType.text});

  @override
  Widget build(BuildContext context) =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label,
            style: const TextStyle(
                fontSize: 11, color: AppColors.textHint, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        TextField(
            controller: controller,
            keyboardType: keyboardType,
            decoration: InputDecoration(
                hintText: hint,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10))),
      ]);
}
