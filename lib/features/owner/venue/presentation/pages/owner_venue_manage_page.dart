import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart'; // DateFormat for schedule exceptions
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/features/owner/venue/data/models/venue_models.dart';
import 'package:dat_san_247_mobile/features/owner/venue/presentation/pages/owner_courts_page.dart';
import 'package:dat_san_247_mobile/features/owner/venue/presentation/pages/owner_venue_services_page.dart';
import 'package:dat_san_247_mobile/features/owner/venue/presentation/pages/owner_refund_policy_page.dart';
import 'package:dat_san_247_mobile/features/owner/staff/presentation/pages/owner_staff_page.dart';
import 'package:dat_san_247_mobile/features/owner/review/presentation/pages/owner_reviews_page.dart';
import 'package:dat_san_247_mobile/features/owner/venue/presentation/pages/owner_verification_page.dart';


// ══════════════════════════════════════════════════════════════════════════════
// O-03: Quản Lý Venue (chi tiết + chỉnh sửa)
// DB: venues UPDATE, sport_assignments, amenities, media_attachments,
//     venue_operating_hours, venue_schedule_exceptions
// ══════════════════════════════════════════════════════════════════════════════
class OwnerVenueManagePage extends StatefulWidget {
  final String venueId;
  const OwnerVenueManagePage({super.key, required this.venueId});

  @override
  State<OwnerVenueManagePage> createState() => _OwnerVenueManagePageState();
}

class _OwnerVenueManagePageState extends State<OwnerVenueManagePage>
    with SingleTickerProviderStateMixin {
  static const Color _brand = Color(0xFF0891B2);
  static const Color _brandDark = Color(0xFF0E7490);

  late TabController _tabCtrl;

  // Mock data
  late OwnerVenueModel _venue = _buildMockVenue();
  List<VenueOperatingHoursModel> _operatingHours = _buildMockHours();
  List<VenueScheduleExceptionModel> _exceptions = _buildMockExceptions();
  List<AmenityModel> _amenities = _buildMockAmenities();
  List<String> _sportTypes = ['FOOTBALL'];
  List<MediaAttachmentModel> _media = [];

  static OwnerVenueModel _buildMockVenue() {
    final now = DateTime.now();
    return OwnerVenueModel(
      id:'v1', ownerId:'u1', name:'Sân K34 Phạm Văn Đồng', slug:'san-k34-pham-van-dong',
      description:'Cụm sân bóng đá chất lượng cao, nằm ngay trung tâm Bắc Từ Liêm. Có đèn chiếu sáng, máy phát điện dự phòng, bãi đỗ xe rộng rãi.',
      address:'34 Phạm Văn Đồng', city:'Hà Nội', district:'Bắc Từ Liêm', ward:'Xuân Đỉnh',
      phone:'02438569900', email:'k34sanball@gmail.com',
      fbUrl:'https://facebook.com/k34sanball', zaloUrl:'https://zalo.me/k34',
      status:VenueStatus.APPROVED, isActive:true, isFeatured:true,
      rating:4.7, ratingCleanliness:4.8, ratingFacilities:4.6, ratingStaff:4.9, totalReviews:128,
      commissionRate:10, vatRate:8,
      autoAcceptBookings:true, minBookingHours:1, maxBookingHours:4, minBookingBeforeHours:2, cancellationBeforeHours:24,
      courtCount:6, sportTypes:['FOOTBALL'],
      createdAt:now.subtract(const Duration(days: 365)), updatedAt:now,
    );
  }

  static List<VenueOperatingHoursModel> _buildMockHours() => OwnerDayOfWeek.values.map((d) =>
    VenueOperatingHoursModel(id: d.name, venueId:'v1', dayOfWeek: d, openingTime:'06:00', closingTime:'22:00', isClosed: false)
  ).toList();

  static List<VenueScheduleExceptionModel> _buildMockExceptions() {
    final now = DateTime.now();
    return [
      VenueScheduleExceptionModel(id:'ex1', venueId:'v1', date:DateTime(now.year, now.month + 1, 1), isClosed:true, reason:'Nghỉ lễ Quốc tế Lao động', createdAt:now),
      VenueScheduleExceptionModel(id:'ex2', venueId:'v1', date:DateTime(now.year, now.month, 28), isClosed:false, openTime:'09:00', closeTime:'17:00', reason:'Giải đấu nội bộ – giò mở rút', createdAt:now),
    ];
  }

  static List<AmenityModel> _buildMockAmenities() => [
    const AmenityModel(id:'a1', venueId:'v1', name:'Bãi đỗ xe', icon:'local_parking', isFree:true),
    const AmenityModel(id:'a2', venueId:'v1', name:'Phòng thay đồ', icon:'dry', isFree:true),
    const AmenityModel(id:'a3', venueId:'v1', name:'Nhà vệ sinh', icon:'wc', isFree:true),
    const AmenityModel(id:'a4', venueId:'v1', name:'Căng-tin / Quầy nước', icon:'local_cafe', isFree:false),
    const AmenityModel(id:'a5', venueId:'v1', name:'Máy bơm bóng', icon:'sports', isFree:true),
    const AmenityModel(id:'a6', venueId:'v1', name:'WiFi', icon:'wifi', isFree:true),
  ];

  final _allSports = {'FOOTBALL':'⚽ Bóng đá', 'BADMINTON':'🏸 Cầu lông', 'TENNIS':'🎾 Tennis', 'BASKETBALL':'🏀 Bóng rổ', 'VOLLEYBALL':'🏐 Bóng chuyền', 'SWIMMING':'🏊 Bơi lội'};

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      body: NestedScrollView(
        headerSliverBuilder: (_, __) => [
          SliverAppBar(
            pinned: true,
            expandedHeight: 150,
            backgroundColor: _brand,
            leading: IconButton(icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white, size: 18), onPressed: () => Navigator.pop(context)),
            actions: [
              IconButton(icon: const Icon(Icons.sports_rounded, color: Colors.white), tooltip: 'Quản lý sân', onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => OwnerCourtsPage(venueId: _venue.id, venueName: _venue.name)))),
              IconButton(icon: const Icon(Icons.room_service_rounded, color: Colors.white), tooltip: 'Dịch vụ', onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => OwnerVenueServicesPage(venueId: _venue.id, venueName: _venue.name)))),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert_rounded, color: Colors.white),
                onSelected: (v) {
                  if (v == 'refund') Navigator.of(context).push(MaterialPageRoute(builder: (_) => OwnerRefundPolicyPage(venueId: _venue.id, venueName: _venue.name)));
                  if (v == 'staff')  Navigator.of(context).push(MaterialPageRoute(builder: (_) => OwnerStaffPage(venueId: _venue.id, venueName: _venue.name)));
                  if (v == 'reviews') Navigator.of(context).push(MaterialPageRoute(builder: (_) => OwnerReviewsPage(venueId: _venue.id, venueName: _venue.name)));
                  if (v == 'verify') Navigator.of(context).push(MaterialPageRoute(builder: (_) => OwnerVerificationPage(venueId: _venue.id, venueName: _venue.name)));
                },
                itemBuilder: (_) => [
                  const PopupMenuItem(value:'refund', child: Row(children: [Icon(Icons.policy_rounded, size: 16), SizedBox(width: 8), Text('Chính sách hoàn tiền')])),
                  const PopupMenuItem(value:'staff', child: Row(children: [Icon(Icons.people_rounded, size: 16), SizedBox(width: 8), Text('Nhân viên')])),
                  const PopupMenuItem(value:'reviews', child: Row(children: [Icon(Icons.rate_review_rounded, size: 16), SizedBox(width: 8), Text('Đánh giá của khách')])),
                  const PopupMenuItem(value:'verify', child: Row(children: [Icon(Icons.verified_rounded, size: 16), SizedBox(width: 8), Text('Xác minh venue')])),
                ],
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(gradient: LinearGradient(colors: [_brandDark, _brand], begin: Alignment.topLeft, end: Alignment.bottomRight)),
                child: SafeArea(child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 48, 20, 0),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(children: [
                      Expanded(child: Text(_venue.name, style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w900), maxLines: 1, overflow: TextOverflow.ellipsis)),
                      _StatusDot(status: _venue.status),
                    ]),
                    const SizedBox(height: 4),
                    Row(children: [
                      const Icon(Icons.location_on_rounded, size: 12, color: Colors.white70),
                      const SizedBox(width: 4),
                      Expanded(child: Text('${_venue.district}, ${_venue.city}', style: const TextStyle(color: Colors.white70, fontSize: 11))),
                      _RatingBadge(rating: _venue.rating, reviews: _venue.totalReviews),
                    ]),
                    const SizedBox(height: 8),
                    Row(children: [
                      _QuickStat('${_venue.courtCount} sân'),
                      const SizedBox(width: 8),
                      _QuickStat('VAT ${_venue.vatRate.toStringAsFixed(0)}%'),
                      const SizedBox(width: 8),
                      _QuickStat(_venue.autoAcceptBookings ? 'Tự chấp nhận' : 'Xét thủ công'),
                    ]),
                  ]),
                )),
              ),
              title: Text(_venue.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14), maxLines: 1, overflow: TextOverflow.ellipsis),
            ),
            bottom: TabBar(
              controller: _tabCtrl,
              indicatorColor: Colors.white,
              indicatorWeight: 3,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white60,
              labelStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
              isScrollable: true,
              tabs: const [
                Tab(text: 'Thông Tin'),
                Tab(text: 'Tiện Ích'),
                Tab(text: 'Giờ Mở Cửa'),
                Tab(text: 'Ảnh Venue'),
              ],
            ),
          ),
        ],
        body: TabBarView(
          controller: _tabCtrl,
          children: [
            _BasicInfoTab(venue: _venue, sportTypes: _sportTypes, allSports: _allSports,
              onSportToggle: (s) => setState(() { if (_sportTypes.contains(s)) _sportTypes.remove(s); else _sportTypes.add(s); }),
              onSave: (v) => setState(() => _venue = v),
            ),
            _AmenitiesTab(amenities: _amenities,
              onAdd: (a) => setState(() => _amenities.add(a)),
              onDelete: (id) => setState(() => _amenities.removeWhere((a) => a.id == id)),
              onToggleFree: (id) => setState(() {
                final i = _amenities.indexWhere((a) => a.id == id);
                if (i >= 0) { final a = _amenities[i]; _amenities[i] = AmenityModel(id:a.id, venueId:a.venueId, courtId:a.courtId, name:a.name, icon:a.icon, isFree:!a.isFree); }
              }),
            ),
            _OperatingHoursTab(
              hours: _operatingHours, exceptions: _exceptions,
              onHoursChange: (d, opening, closing, closed) => setState(() {
                final i = _operatingHours.indexWhere((h) => h.dayOfWeek == d);
                if (i >= 0) _operatingHours[i] = VenueOperatingHoursModel(id:_operatingHours[i].id, venueId:'v1', dayOfWeek:d, openingTime:opening, closingTime:closing, isClosed:closed);
              }),
              onAddException: (ex) => setState(() => _exceptions.add(ex)),
              onDeleteException: (id) => setState(() => _exceptions.removeWhere((e) => e.id == id)),
            ),
            _MediaTab(media: _media, onAdd: () {}),
          ],
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// Tab 1 – Thông Tin Cơ Bản + Cài đặt booking + VAT
// ══════════════════════════════════════════════════════════════════════════════
class _BasicInfoTab extends StatelessWidget {
  final OwnerVenueModel venue;
  final List<String> sportTypes;
  final Map<String, String> allSports;
  final void Function(String) onSportToggle;
  final void Function(OwnerVenueModel) onSave;
  const _BasicInfoTab({required this.venue, required this.sportTypes, required this.allSports, required this.onSportToggle, required this.onSave});

  @override
  Widget build(BuildContext context) {
    const brand = Color(0xFF0891B2);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(14),
      child: Column(children: [
        // ── Basic info ──
        _SectionCard(title:'Thông Tin Cơ Bản', icon:Icons.info_outline_rounded, color:brand, children:[
          _EditRow(label:'Tên venue', value:venue.name, onEdit:() => _editField(context, 'Tên Venue', venue.name)),
          _EditRow(label:'Mô tả', value:venue.description ?? 'Chưa có mô tả', isMultiline:true, onEdit:() => _editField(context, 'Mô tả', venue.description ?? '', multiline:true)),
          _EditRow(label:'Địa chỉ', value:venue.address, onEdit:() => _editField(context, 'Địa chỉ', venue.address)),
          _EditRow(label:'Quận/Huyện', value:'${venue.district}, ${venue.city}', onEdit:() {}),
          _EditRow(label:'Điện thoại', value:venue.phone ?? '—', onEdit:() => _editField(context, 'Điện thoại', venue.phone ?? '')),
          _EditRow(label:'Email', value:venue.email ?? '—', onEdit:() => _editField(context, 'Email', venue.email ?? '')),
        ]),
        const SizedBox(height: 12),

        // ── Social Links ──
        _SectionCard(title:'Mạng Xã Hội', icon:Icons.share_rounded, color:const Color(0xFF4267B2), children:[
          _SocialRow(icon:Icons.facebook_rounded, label:'Facebook', value:venue.fbUrl, color:const Color(0xFF4267B2), onEdit:() => _editField(context, 'Facebook URL', venue.fbUrl ?? '')),
          _SocialRow(icon:Icons.camera_alt_rounded, label:'Instagram', value:venue.instagramUrl, color:const Color(0xFFE1306C), onEdit:() => _editField(context, 'Instagram URL', venue.instagramUrl ?? '')),
          _SocialRow(icon:Icons.chat_bubble_rounded, label:'Zalo', value:venue.zaloUrl, color:const Color(0xFF0068FF), onEdit:() => _editField(context, 'Zalo URL', venue.zaloUrl ?? '')),
        ]),
        const SizedBox(height: 12),

        // ── Môn thể thao ──
        _SectionCard(title:'Môn Thể Thao', icon:Icons.sports_rounded, color:AppColors.success, children:[
          Wrap(spacing:8, runSpacing:8, children: allSports.entries.map((e) {
            final selected = sportTypes.contains(e.key);
            return GestureDetector(
              onTap: () { HapticFeedback.selectionClick(); onSportToggle(e.key); },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(color: selected ? AppColors.success : Colors.transparent, borderRadius: BorderRadius.circular(20), border: Border.all(color: selected ? AppColors.success : AppColors.borderLight)),
                child: Text(e.value, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: selected ? Colors.white : AppColors.textSecondary)),
              ),
            );
          }).toList()),
        ]),
        const SizedBox(height: 12),

        // ── Cài đặt Booking ──
        _SectionCard(title:'Cài Đặt Booking', icon:Icons.tune_rounded, color:AppColors.warning, children:[
          _ToggleRow(label:'Tự động chấp nhận booking', value:venue.autoAcceptBookings, onToggle:() {}),
          const Divider(height: 12, color: AppColors.borderLight),
          _EditRow(label:'Đặt trước tối thiểu', value:'${venue.minBookingBeforeHours}h', onEdit:() {}),
          _EditRow(label:'Thời gian min/max', value:'${venue.minBookingHours}h – ${venue.maxBookingHours}h', onEdit:() {}),
          _EditRow(label:'Hủy trước', value:'${venue.cancellationBeforeHours}h', onEdit:() {}),
        ]),
        const SizedBox(height: 12),

        // ── VAT & Hoa hồng ──
        _SectionCard(title:'Thuế & Hoa Hồng', icon:Icons.percent_rounded, color:brand, children:[
          _EditRow(label:'VAT rate', value:'${venue.vatRate.toStringAsFixed(0)}%', onEdit:() {}),
          _InfoOnlyRow(label:'Hoa hồng nền tảng', value:'${venue.commissionRate.toStringAsFixed(0)}% (do admin cài)'),
        ]),
        const SizedBox(height: 30),
      ]),
    );
  }

  void _editField(BuildContext context, String label, String current, {bool multiline = false}) {
    final ctrl = TextEditingController(text: current);
    showModalBottomSheet(
      context: context, isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(18))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
            Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 14),
            Text('Chỉnh sửa: $label', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            const SizedBox(height: 12),
            TextField(
              controller: ctrl, maxLines: multiline ? 4 : 1, autofocus: true,
              decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)), contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10)),
            ),
            const SizedBox(height: 12),
            SizedBox(width: double.infinity, child: ElevatedButton(
              onPressed: () { Navigator.pop(ctx); HapticFeedback.mediumImpact();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('✅ Đã cập nhật $label'), backgroundColor: AppColors.success)); },
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0891B2), elevation: 0, padding: const EdgeInsets.symmetric(vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
              child: const Text('Lưu', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            )),
          ]),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// Tab 2 – Tiện Ích
// ══════════════════════════════════════════════════════════════════════════════
class _AmenitiesTab extends StatelessWidget {
  final List<AmenityModel> amenities;
  final void Function(AmenityModel) onAdd;
  final void Function(String) onDelete;
  final void Function(String) onToggleFree;
  const _AmenitiesTab({required this.amenities, required this.onAdd, required this.onDelete, required this.onToggleFree});

  final _preset = const [
    {'name':'WiFi','icon':'wifi'},{'name':'Bãi đỗ xe','icon':'local_parking'},
    {'name':'Phòng thay đồ','icon':'dry'},{'name':'Nhà vệ sinh','icon':'wc'},
    {'name':'Căng-tin','icon':'local_cafe'},{'name':'Máy lạnh','icon':'ac_unit'},
    {'name':'Điểm sạc điện thoại','icon':'electric_bolt'},{'name':'Tủ đồ','icon':'lock'},
    {'name':'Camera an ninh','icon':'videocam'},{'name':'Đèn chiếu sáng','icon':'light'},
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(14),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Preset quick-add
        _SectionCard(title:'Thêm Nhanh Tiện Ích', icon:Icons.playlist_add_rounded, color:AppColors.info, children:[
          Wrap(spacing:8, runSpacing:8, children: _preset.map((p) {
            final exists = amenities.any((a) => a.name == p['name']);
            return GestureDetector(
              onTap: exists ? null : () { HapticFeedback.selectionClick(); onAdd(AmenityModel(id:'new_${DateTime.now().millisecondsSinceEpoch}', venueId:'v1', name:p['name']!, icon:p['icon'], isFree:true)); },
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 150),
                opacity: exists ? 0.4 : 1.0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(color: exists ? AppColors.success.withOpacity(0.1) : Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: exists ? AppColors.success : AppColors.borderLight)),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    if (exists) const Icon(Icons.check_rounded, size: 11, color: AppColors.success),
                    if (exists) const SizedBox(width: 4),
                    Text(p['name']!, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: exists ? AppColors.success : AppColors.textSecondary)),
                  ]),
                ),
              ),
            );
          }).toList()),
        ]),
        const SizedBox(height: 12),

        // Current amenities
        _SectionCard(title:'Tiện Ích Hiện Tại (${amenities.length})', icon:Icons.check_circle_outline_rounded, color:AppColors.success, children:[
          if (amenities.isEmpty)
            const Padding(padding: EdgeInsets.symmetric(vertical: 8), child: Text('Chưa cài tiện ích', style: TextStyle(color: AppColors.textHint, fontSize: 12))),
          ...amenities.map((a) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(children: [
              const Icon(Icons.check_circle_rounded, size: 14, color: AppColors.success),
              const SizedBox(width: 10),
              Expanded(child: Text(a.name, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600))),
              GestureDetector(
                onTap: () => onToggleFree(a.id),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                  decoration: BoxDecoration(color: a.isFree ? AppColors.success.withOpacity(0.1) : AppColors.warning.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                  child: Text(a.isFree ? 'Miễn phí' : 'Tính phí', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: a.isFree ? AppColors.success : AppColors.warning)),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(onTap: () => onDelete(a.id), child: const Icon(Icons.close_rounded, size: 16, color: AppColors.error)),
            ]),
          )),
        ]),
        const SizedBox(height: 30),
      ]),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// Tab 3 – Giờ Mở Cửa + Ngày Ngoại Lệ
// ══════════════════════════════════════════════════════════════════════════════
class _OperatingHoursTab extends StatelessWidget {
  final List<VenueOperatingHoursModel> hours;
  final List<VenueScheduleExceptionModel> exceptions;
  final void Function(OwnerDayOfWeek, String, String, bool) onHoursChange;
  final void Function(VenueScheduleExceptionModel) onAddException;
  final void Function(String) onDeleteException;
  const _OperatingHoursTab({required this.hours, required this.exceptions, required this.onHoursChange, required this.onAddException, required this.onDeleteException});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(14),
      child: Column(children: [
        // Weekly hours
        _SectionCard(title:'Giờ Mở Cửa Hàng Tuần', icon:Icons.schedule_rounded, color:const Color(0xFF0891B2), children:[
          ...hours.map((h) => _HoursRow(h: h, onTap: () => _editHours(context, h))),
        ]),
        const SizedBox(height: 12),

        // Schedule exceptions
        _SectionCard(title:'Ngày Đặc Biệt (${exceptions.length})', icon:Icons.event_busy_rounded, color:AppColors.error,
          action: GestureDetector(onTap: () => _addException(context), child: Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: AppColors.error.withOpacity(0.1), borderRadius: BorderRadius.circular(8)), child: const Text('+ Thêm', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.error)))),
          children:[
          if (exceptions.isEmpty)
            const Padding(padding: EdgeInsets.symmetric(vertical: 8), child: Text('Không có ngày đặc biệt', style: TextStyle(color: AppColors.textHint, fontSize: 12))),
          ...exceptions.map((ex) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(children: [
              Container(width: 40, height: 40, decoration: BoxDecoration(color: ex.isClosed ? AppColors.error.withOpacity(0.1) : AppColors.warning.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(DateFormat('dd').format(ex.date), style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: ex.isClosed ? AppColors.error : AppColors.warning)),
                  Text(DateFormat('MM').format(ex.date), style: TextStyle(fontSize: 9, color: ex.isClosed ? AppColors.error : AppColors.warning)),
                ])),
              const SizedBox(width: 10),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(ex.isClosed ? '🔒 Đóng cửa' : '⏰ Giờ đặc biệt: ${ex.openTime}–${ex.closeTime}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                if (ex.reason != null) Text(ex.reason!, style: const TextStyle(fontSize: 10, color: AppColors.textHint), maxLines: 1, overflow: TextOverflow.ellipsis),
              ])),
              GestureDetector(onTap: () => onDeleteException(ex.id), child: const Icon(Icons.delete_outline_rounded, size: 18, color: AppColors.error)),
            ]),
          )),
        ]),
        const SizedBox(height: 30),
      ]),
    );
  }

  void _editHours(BuildContext context, VenueOperatingHoursModel h) {
    bool closed = h.isClosed;
    TimeOfDay opening = _toTOD(h.openingTime);
    TimeOfDay closing = _toTOD(h.closingTime);
    showModalBottomSheet(
      context: context, isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(18))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, ss) => Padding(
          padding: const EdgeInsets.all(20),
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
            Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 14),
            Text(h.dayOfWeek.short, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 16),
            _ToggleRow(label: 'Ngày nghỉ (đóng cửa)', value: closed, onToggle: () => ss(() => closed = !closed)),
            if (!closed) ...[
              const SizedBox(height: 12),
              Row(children: [
                Expanded(child: _TimePick(label: 'Mở cửa', time: opening, onPick: (t) => ss(() => opening = t))),
                const SizedBox(width: 12),
                Expanded(child: _TimePick(label: 'Đóng cửa', time: closing, onPick: (t) => ss(() => closing = t))),
              ]),
            ],
            const SizedBox(height: 16),
            SizedBox(width: double.infinity, child: ElevatedButton(
              onPressed: () { Navigator.pop(ctx); onHoursChange(h.dayOfWeek, _todStr(opening), _todStr(closing), closed); HapticFeedback.mediumImpact(); },
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0891B2), elevation: 0, padding: const EdgeInsets.symmetric(vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
              child: const Text('Lưu', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            )),
          ]),
        ),
      ),
    );
  }

  void _addException(BuildContext context) {
    DateTime? pickedDate;
    bool isClosed = true;
    final reasonCtrl = TextEditingController();
    showModalBottomSheet(
      context: context, isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(18))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, ss) => Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
          child: Padding(padding: const EdgeInsets.all(20), child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
            Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 14),
            const Text('Thêm Ngày Đặc Biệt', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () async { final d = await showDatePicker(context: ctx, initialDate: DateTime.now(), firstDate: DateTime.now(), lastDate: DateTime.now().add(const Duration(days: 365))); if (d != null) ss(() => pickedDate = d); },
              child: Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(border: Border.all(color: AppColors.borderLight), borderRadius: BorderRadius.circular(10)),
                child: Row(children: [const Icon(Icons.calendar_today_rounded, size: 16, color: AppColors.textHint), const SizedBox(width: 8), Text(pickedDate != null ? DateFormat('dd/MM/yyyy').format(pickedDate!) : 'Chọn ngày *', style: TextStyle(color: pickedDate != null ? AppColors.textPrimary : AppColors.textHint))]),
              ),
            ),
            const SizedBox(height: 12),
            _ToggleRow(label: 'Đóng cửa ngày này', value: isClosed, onToggle: () => ss(() => isClosed = !isClosed)),
            const SizedBox(height: 10),
            TextField(controller: reasonCtrl, decoration: InputDecoration(labelText: 'Lý do (tuỳ chọn)', border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)), contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10))),
            const SizedBox(height: 14),
            SizedBox(width: double.infinity, child: ElevatedButton(
              onPressed: pickedDate == null ? null : () {
                Navigator.pop(ctx);
                onAddException(VenueScheduleExceptionModel(id:'ex_${DateTime.now().millisecondsSinceEpoch}', venueId:'v1', date:pickedDate!, isClosed:isClosed, reason:reasonCtrl.text.isEmpty ? null : reasonCtrl.text, createdAt:DateTime.now()));
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.error, elevation: 0, padding: const EdgeInsets.symmetric(vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
              child: const Text('Thêm', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            )),
          ])),
        ),
      ),
    );
  }

  TimeOfDay _toTOD(String s) { final p = s.split(':'); return TimeOfDay(hour: int.tryParse(p[0]) ?? 0, minute: int.tryParse(p.length > 1 ? p[1] : '0') ?? 0); }
  String _todStr(TimeOfDay t) => '${t.hour.toString().padLeft(2,'0')}:${t.minute.toString().padLeft(2,'0')}';
}

// ══════════════════════════════════════════════════════════════════════════════
// Tab 4 – Ảnh Venue
// ══════════════════════════════════════════════════════════════════════════════
class _MediaTab extends StatelessWidget {
  final List<MediaAttachmentModel> media;
  final VoidCallback onAdd;
  const _MediaTab({required this.media, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(14),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Text('Ảnh Venue', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
          const Spacer(),
          ElevatedButton.icon(
            onPressed: onAdd,
            icon: const Icon(Icons.add_photo_alternate_rounded, size: 16, color: Colors.white),
            label: const Text('Tải ảnh', style: TextStyle(color: Colors.white, fontSize: 11)),
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0891B2), elevation: 0, padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
          ),
        ]),
        const SizedBox(height: 12),
        if (media.isEmpty)
          Container(
            height: 160, width: double.infinity,
            decoration: BoxDecoration(color: AppColors.borderLight.withOpacity(0.3), borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.borderLight, style: BorderStyle.solid, width: 2)),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(Icons.add_photo_alternate_outlined, size: 40, color: AppColors.textHint.withOpacity(0.5)),
              const SizedBox(height: 8),
              const Text('Chưa có ảnh — Tải ảnh đại diện venue', style: TextStyle(color: AppColors.textHint, fontSize: 12)),
            ]),
          )
        else
          GridView.builder(
            shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 6, mainAxisSpacing: 6),
            itemCount: media.length,
            itemBuilder: (_, i) { final m = media[i]; return Stack(children: [
              Container(decoration: BoxDecoration(color: AppColors.borderLight, borderRadius: BorderRadius.circular(8), image: DecorationImage(image: NetworkImage(m.publicUrl), fit: BoxFit.cover))),
              if (m.isCover) Positioned(top: 4, left: 4, child: Container(padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2), decoration: BoxDecoration(color: AppColors.warning, borderRadius: BorderRadius.circular(4)), child: const Text('Cover', style: TextStyle(fontSize: 8, color: Colors.white, fontWeight: FontWeight.bold)))),
            ]); },
          ),
        const SizedBox(height: 8),
        const Text('Mẹo: Ảnh đầu tiên sẽ được đặt là ảnh bìa venue.', style: TextStyle(fontSize: 10, color: AppColors.textHint)),
        const SizedBox(height: 30),
      ]),
    );
  }
}

// ── Shared sub-widgets ────────────────────────────────────────────────────────
class _SectionCard extends StatelessWidget {
  final String title; final IconData icon; final Color color; final List<Widget> children; final Widget? action;
  const _SectionCard({required this.title, required this.icon, required this.color, required this.children, this.action});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)]),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 6),
        Text(title, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: color, letterSpacing: 0.3)),
        const Spacer(),
        if (action != null) action!,
      ]),
      const Divider(height: 12, color: AppColors.borderLight),
      ...children,
    ]),
  );
}

class _EditRow extends StatelessWidget {
  final String label, value; final bool isMultiline; final VoidCallback onEdit;
  const _EditRow({required this.label, required this.value, this.isMultiline = false, required this.onEdit});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onEdit,
    child: Padding(padding: const EdgeInsets.symmetric(vertical: 6), child: Row(crossAxisAlignment: isMultiline ? CrossAxisAlignment.start : CrossAxisAlignment.center, children: [
      SizedBox(width: 120, child: Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary))),
      Expanded(child: Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600), maxLines: isMultiline ? 2 : 1, overflow: TextOverflow.ellipsis)),
      const Icon(Icons.edit_rounded, size: 14, color: AppColors.textHint),
    ])),
  );
}

class _InfoOnlyRow extends StatelessWidget {
  final String label, value;
  const _InfoOnlyRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) => Padding(padding: const EdgeInsets.symmetric(vertical: 6), child: Row(children: [
    SizedBox(width: 120, child: Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary))),
    Expanded(child: Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600))),
  ]));
}

class _ToggleRow extends StatelessWidget {
  final String label; final bool value; final VoidCallback onToggle;
  const _ToggleRow({required this.label, required this.value, required this.onToggle});

  @override
  Widget build(BuildContext context) => Row(children: [
    Expanded(child: Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600))),
    Switch(value: value, onChanged: (_) => onToggle(), activeColor: const Color(0xFF0891B2)),
  ]);
}

class _SocialRow extends StatelessWidget {
  final IconData icon; final String label; final String? value; final Color color; final VoidCallback onEdit;
  const _SocialRow({required this.icon, required this.label, this.value, required this.color, required this.onEdit});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onEdit,
    child: Padding(padding: const EdgeInsets.symmetric(vertical: 6), child: Row(children: [
      Icon(icon, size: 16, color: color),
      const SizedBox(width: 10),
      Expanded(child: Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600))),
      Expanded(flex: 2, child: Text(value ?? 'Chưa cài', style: TextStyle(fontSize: 11, color: value != null ? AppColors.info : AppColors.textHint), maxLines: 1, overflow: TextOverflow.ellipsis)),
      const Icon(Icons.edit_rounded, size: 14, color: AppColors.textHint),
    ])),
  );
}

class _HoursRow extends StatelessWidget {
  final VenueOperatingHoursModel h; final VoidCallback onTap;
  const _HoursRow({required this.h, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Padding(padding: const EdgeInsets.symmetric(vertical: 5), child: Row(children: [
      Container(width: 28, height: 28, decoration: BoxDecoration(color: h.dayOfWeek.isWeekend ? AppColors.success.withOpacity(0.1) : const Color(0xFF0891B2).withOpacity(0.08), borderRadius: BorderRadius.circular(6)),
        child: Center(child: Text(h.dayOfWeek.short, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: h.dayOfWeek.isWeekend ? AppColors.success : const Color(0xFF0891B2))))),
      const SizedBox(width: 10),
      Expanded(child: h.isClosed
          ? const Text('Đóng cửa', style: TextStyle(fontSize: 12, color: AppColors.error, fontWeight: FontWeight.w600))
          : Text('${h.openingTime} – ${h.closingTime}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600))),
      const Icon(Icons.edit_rounded, size: 14, color: AppColors.textHint),
    ])),
  );
}

class _TimePick extends StatelessWidget {
  final String label; final TimeOfDay time; final void Function(TimeOfDay) onPick;
  const _TimePick({required this.label, required this.time, required this.onPick});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: () async { final t = await showTimePicker(context: context, initialTime: time); if (t != null) onPick(t); },
    child: Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10), decoration: BoxDecoration(border: Border.all(color: AppColors.borderLight), borderRadius: BorderRadius.circular(10)),
      child: Row(children: [const Icon(Icons.access_time_rounded, size: 14, color: AppColors.textHint), const SizedBox(width: 8), Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: const TextStyle(fontSize: 9, color: AppColors.textHint)),
        Text('${time.hour.toString().padLeft(2,'0')}:${time.minute.toString().padLeft(2,'0')}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
      ])])),
  );
}

class _StatusDot extends StatelessWidget {
  final VenueStatus status;
  const _StatusDot({required this.status});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
    child: Text(status.label, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
  );
}

class _RatingBadge extends StatelessWidget {
  final double rating; final int reviews;
  const _RatingBadge({required this.rating, required this.reviews});

  @override
  Widget build(BuildContext context) {
    if (reviews == 0) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        const Icon(Icons.star_rounded, size: 12, color: AppColors.warning),
        const SizedBox(width: 3),
        Text('${rating.toStringAsFixed(1)} ($reviews)', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
      ]),
    );
  }
}

class _QuickStat extends StatelessWidget {
  final String label;
  const _QuickStat(this.label);

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
    decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(20)),
    child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
  );
}
