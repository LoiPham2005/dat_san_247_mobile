import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:dat_san_247_mobile/core/base/di/injection.dart';
import 'package:dat_san_247_mobile/core/services/manager/toast_service.dart';
import 'package:dat_san_247_mobile/core/base/state/base_status.dart';
import 'package:dat_san_247_mobile/core/base/state/bloc/base_state.dart';
import 'package:dat_san_247_mobile/features/owner/venue/presentation/cubit/owner_venue_detail_cubit.dart';
import 'package:dat_san_247_mobile/features/owner/venue/presentation/cubit/owner_venue_detail_sub_cubits.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
class OwnerVenueManagePage extends StatelessWidget {
  final String venueId;
  const OwnerVenueManagePage({super.key, required this.venueId});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<OwnerVenueDetailCubit>()..fetchVenueDetail(venueId)),
        BlocProvider(create: (_) => getIt<OwnerVenueAmenitiesCubit>()..fetchAmenities(venueId)),
        BlocProvider(create: (_) => getIt<OwnerVenueHoursCubit>()..fetchHours(venueId)),
        BlocProvider(create: (_) => getIt<OwnerVenueMediaCubit>()..fetchMedia(venueId)),
      ],
      child: _OwnerVenueManageView(venueId: venueId),
    );
  }
}

class _OwnerVenueManageView extends StatefulWidget {
  final String venueId;
  const _OwnerVenueManageView({required this.venueId});

  @override
  State<_OwnerVenueManageView> createState() => _OwnerVenueManageViewState();
}

class _OwnerVenueManageViewState extends State<_OwnerVenueManageView>
    with SingleTickerProviderStateMixin {
  static const Color _brand = Color(0xFF0891B2);
  static const Color _brandDark = Color(0xFF0E7490);

  late TabController _tabCtrl;

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
    return BlocBuilder<OwnerVenueDetailCubit, BaseState<OwnerVenueModel>>(
      builder: (context, state) {
        if (state.status == BaseStatus.initial || (state.isLoading && !state.hasData)) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        return BlocListener<OwnerVenueDetailCubit, BaseState<OwnerVenueModel>>(
          listenWhen: (prev, curr) => prev.status != curr.status,
          listener: (context, state) {
            if (state.isSuccess) {
              getIt<ToastService>().success('Cập nhật thông tin thành công');
            } else if (state.isFailure) {
              getIt<ToastService>().error(state.error ?? 'Cập nhật thất bại');
            }
          },
          child: _buildScaffold(context, state),
        );
      },
    );
  }

  Widget _buildScaffold(BuildContext context, BaseState<OwnerVenueModel> state) {
    if (state.isFailure && !state.hasData) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(state.error ?? 'Lỗi tải chi tiết sân'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.read<OwnerVenueDetailCubit>().refresh(widget.venueId),
                child: const Text('Thử lại'),
              ),
            ],
          ),
        ),
      );
    }

    final venue = state.data!;

    return Scaffold(
          backgroundColor: const Color(0xFFF4F6FA),
          body: NestedScrollView(
            headerSliverBuilder: (_, __) => [
              SliverAppBar(
                pinned: true,
                expandedHeight: 120,
                backgroundColor: _brand,
                titleSpacing: 0,
                leading: IconButton(icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white, size: 18), onPressed: () => Navigator.pop(context)),
                title: Text(venue.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                actions: [
                  IconButton(icon: const Icon(Icons.sports_rounded, color: Colors.white), tooltip: 'Quản lý sân', onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => OwnerCourtsPage(venueId: venue.id, venueName: venue.name)))),
                  IconButton(icon: const Icon(Icons.room_service_rounded, color: Colors.white), tooltip: 'Dịch vụ', onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => OwnerVenueServicesPage(venueId: venue.id, venueName: venue.name)))),
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert_rounded, color: Colors.white),
                    onSelected: (v) {
                      if (v == 'refund') Navigator.of(context).push(MaterialPageRoute(builder: (_) => OwnerRefundPolicyPage(venueId: venue.id, venueName: venue.name)));
                      if (v == 'staff')  Navigator.of(context).push(MaterialPageRoute(builder: (_) => OwnerStaffPage(venueId: venue.id, venueName: venue.name)));
                      if (v == 'reviews') Navigator.of(context).push(MaterialPageRoute(builder: (_) => OwnerReviewsPage(venueId: venue.id, venueName: venue.name)));
                      if (v == 'verify') Navigator.of(context).push(MaterialPageRoute(builder: (_) => OwnerVerificationPage(venueId: venue.id, venueName: venue.name)));
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
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [_brandDark, _brand],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 50, top: 48),
                      child: Row(
                        children: [
                          _StatusDot(status: venue.status),
                          const SizedBox(width: 8),
                          _RatingBadge(rating: venue.rating, reviews: venue.totalReviews),
                        ],
                      ),
                    ),
                  ),
                ),
                bottom: TabBar(
                  controller: _tabCtrl,
                  indicatorColor: Colors.white,
                  indicatorWeight: 3,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white60,
                  labelStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                  isScrollable: true,
                  tabAlignment: TabAlignment.start,
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
                _BasicInfoTab(venue: venue, sportTypes: venue.sportTypes, allSports: _allSports,
                  onSportToggle: (newList) {
                    context.read<OwnerVenueDetailCubit>().updateVenue(venue.id, {'sport_types': newList});
                  },
                  onSave: (data) {
                    context.read<OwnerVenueDetailCubit>().updateVenue(venue.id, data);
                  },
                ),
                BlocBuilder<OwnerVenueAmenitiesCubit, BaseState<List<AmenityModel>>>(
                  builder: (context, amState) => _AmenitiesTab(
                    amenities: amState.data ?? [],
                    isLoading: amState.isLoading,
                    onAdd: (a) => context.read<OwnerVenueAmenitiesCubit>().addAmenity(venue.id, a.name, a.icon),
                    onDelete: (id) => context.read<OwnerVenueAmenitiesCubit>().deleteAmenity(venue.id, id),
                    onToggleFree: (id) => context.read<OwnerVenueAmenitiesCubit>().toggleFree(venue.id, id),
                  ),
                ),
                BlocBuilder<OwnerVenueHoursCubit, BaseState<VenueHoursState>>(
                  builder: (context, hrState) => _OperatingHoursTab(
                    hours: hrState.data?.hours ?? [],
                    exceptions: hrState.data?.exceptions ?? [],
                    isLoading: hrState.isLoading,
                    onHoursChange: (day, opening, closing, closed) {
                      final currentHours = hrState.data?.hours ?? [];
                      final updated = currentHours.map((h) {
                        if (h.dayOfWeek == day) {
                          return h.copyWith(openingTime: opening, closingTime: closing, isClosed: closed);
                        }
                        return h;
                      }).toList();
                      context.read<OwnerVenueHoursCubit>().updateHours(venue.id, updated);
                    },
                    onAddException: (ex) => context.read<OwnerVenueHoursCubit>().addException(venue.id, ex),
                    onDeleteException: (id) => context.read<OwnerVenueHoursCubit>().deleteException(venue.id, id),
                  ),
                ),
                BlocBuilder<OwnerVenueMediaCubit, BaseState<VenueMediaState>>(
                  builder: (context, mState) => _MediaTab(
                    media: mState.data?.media ?? [],
                    pendingFiles: mState.data?.pendingFiles ?? [],
                    isLoading: mState.isLoading,
                    onPickImages: () async {
                      final picker = ImagePicker();
                      final xFiles = await picker.pickMultiImage();
                      if (xFiles.isNotEmpty) {
                        context.read<OwnerVenueMediaCubit>().pickImages(xFiles.map((x) => File(x.path)).toList());
                      }
                    },
                    onRemovePending: (index) => context.read<OwnerVenueMediaCubit>().removePending(index),
                    onSavePending: () => context.read<OwnerVenueMediaCubit>().savePending(venue.id),
                    onDelete: (id) => context.read<OwnerVenueMediaCubit>().deleteMedia(venue.id, id),
                    onSetCover: (id) => context.read<OwnerVenueMediaCubit>().setCover(venue.id, id),
                  ),
                ),
              ],
            ),
          ),
        );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// Tab 1 – Thông Tin Cơ Bản + Cài đặt booking + VAT
// ══════════════════════════════════════════════════════════════════════════════
class _BasicInfoTab extends StatefulWidget {
  final OwnerVenueModel venue;
  final List<String> sportTypes;
  final Map<String, String> allSports;
  final void Function(List<String>) onSportToggle; // Updated to pass the full list or handle inside
  final void Function(Map<String, dynamic>) onSave;
  const _BasicInfoTab({required this.venue, required this.sportTypes, required this.allSports, required this.onSportToggle, required this.onSave});

  @override
  State<_BasicInfoTab> createState() => _BasicInfoTabState();
}

class _BasicInfoTabState extends State<_BasicInfoTab> {
  late OwnerVenueModel _draft;
  late List<String> _draftSports;
  bool _isChanged = false;

  @override
  void initState() {
    super.initState();
    _draft = widget.venue;
    _draftSports = List.from(widget.sportTypes);
  }

  @override
  void didUpdateWidget(_BasicInfoTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.venue != widget.venue) {
      _draft = widget.venue;
      _isChanged = false;
    }
  }

  void _updateDraft(OwnerVenueModel newDraft) {
    setState(() {
      _draft = newDraft;
      _isChanged = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    const brand = Color(0xFF0891B2);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(14),
      child: Column(children: [
        // ── Basic info ──
        _SectionCard(title:'Thông Tin Cơ Bản', icon:Icons.info_outline_rounded, color:brand, children:[
          _EditRow(label:'Tên venue', value:_draft.name, onEdit:() => _editField('name', 'Tên Venue', _draft.name)),
          _EditRow(label:'Mô tả', value:_draft.description ?? 'Chưa có mô tả', isMultiline:true, onEdit:() => _editField('description', 'Mô tả', _draft.description ?? '', multiline:true)),
          _EditRow(label:'Địa chỉ', value:_draft.address, onEdit:() => _editField('address', 'Địa chỉ', _draft.address)),
          _EditRow(label:'Quận/Huyện', value:'${_draft.district}, ${_draft.city}', onEdit:() {}),
          _EditRow(label:'Điện thoại', value:_draft.phone ?? '—', onEdit:() => _editField('phone', 'Điện thoại', _draft.phone ?? '')),
          _EditRow(label:'Email', value:_draft.email ?? '—', onEdit:() => _editField('email', 'Email', _draft.email ?? '')),
        ]),
        const SizedBox(height: 12),

        // ── Social Links ──
        _SectionCard(title:'Mạng Xã Hội', icon:Icons.share_rounded, color:const Color(0xFF4267B2), children:[
          _SocialRow(icon:Icons.facebook_rounded, label:'Facebook', value:_draft.fbUrl, color:const Color(0xFF4267B2), onEdit:() => _editField('fb_url', 'Facebook URL', _draft.fbUrl ?? '')),
          _SocialRow(icon:Icons.camera_alt_rounded, label:'Instagram', value:_draft.instagramUrl, color:const Color(0xFFE1306C), onEdit:() => _editField('instagram_url', 'Instagram URL', _draft.instagramUrl ?? '')),
          _SocialRow(icon:Icons.chat_bubble_rounded, label:'Zalo', value:_draft.zaloUrl, color:const Color(0xFF0068FF), onEdit:() => _editField('zalo_url', 'Zalo URL', _draft.zaloUrl ?? '')),
        ]),
        const SizedBox(height: 12),

        // ── Môn thể thao ──
        _SectionCard(title:'Môn Thể Thao', icon:Icons.sports_rounded, color:AppColors.success, children:[
          Wrap(spacing:8, runSpacing:8, children: widget.allSports.entries.map((e) {
            final selected = _draftSports.contains(e.key);
            return GestureDetector(
              onTap: () { 
                HapticFeedback.selectionClick(); 
                setState(() {
                  if (selected) _draftSports.remove(e.key);
                  else _draftSports.add(e.key);
                  _isChanged = true;
                });
              },
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
          _ToggleRow(label:'Tự động chấp nhận booking', value:_draft.autoAcceptBookings, onToggle:() {
            _updateDraft(_draft.copyWith(autoAcceptBookings: !_draft.autoAcceptBookings));
          }),
          const Divider(height: 12, color: AppColors.borderLight),
          _EditRow(label:'Đặt trước tối thiểu', value:'${_draft.minBookingBeforeHours}h', onEdit:() => _editNumeric('min_booking_before_hours', 'Đặt trước tối thiểu (giờ)', _draft.minBookingBeforeHours)),
          _EditRow(label:'Thời gian min/max', value:'${_draft.minBookingHours}h – ${_draft.maxBookingHours}h', onEdit:() {}), // Complex, skip for now or implement dual picker
          _EditRow(label:'Hủy trước', value:'${_draft.cancellationBeforeHours}h', onEdit:() => _editNumeric('cancellation_before_hours', 'Hủy trước tối thiểu (giờ)', _draft.cancellationBeforeHours)),
        ]),
        const SizedBox(height: 12),

        // ── VAT & Hoa hồng ──
        _SectionCard(title:'Thuế & Hoa Hồng', icon:Icons.percent_rounded, color:brand, children:[
          _EditRow(label:'VAT rate', value:'${_draft.vatRate.toStringAsFixed(0)}%', onEdit:() => _editNumeric('vat_rate', 'VAT Rate (%)', _draft.vatRate.toInt())),
          _InfoOnlyRow(label:'Hoa hồng nền tảng', value:'${_draft.commissionRate.toStringAsFixed(0)}% (do admin cài)'),
        ]),
        
        if (_isChanged) ...[
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                final data = <String, dynamic>{
                  'name': _draft.name,
                  'description': _draft.description,
                  'address': _draft.address,
                  'phone': _draft.phone,
                  'email': _draft.email,
                  'fb_url': _draft.fbUrl,
                  'instagram_url': _draft.instagramUrl,
                  'zalo_url': _draft.zaloUrl,
                  'auto_accept_bookings': _draft.autoAcceptBookings,
                  'min_booking_before_hours': _draft.minBookingBeforeHours,
                  'cancellation_before_hours': _draft.cancellationBeforeHours,
                  'vat_rate': _draft.vatRate,
                  'sport_types': _draftSports,
                };
                // Filter out null values to avoid backend validation errors
                data.removeWhere((key, value) => value == null);

                widget.onSave(data);
                setState(() => _isChanged = false);
              },
              style: ElevatedButton.styleFrom(backgroundColor: brand, padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              child: const Text('Lưu Thay Đổi', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
        const SizedBox(height: 30),
      ]),
    );
  }

  void _editField(String field, String label, String current, {bool multiline = false}) {
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
              onPressed: () {
                Navigator.pop(ctx);
                final val = ctrl.text.trim();
                OwnerVenueModel next = _draft;
                if (field == 'name') next = _draft.copyWith(name: val);
                else if (field == 'description') next = _draft.copyWith(description: val);
                else if (field == 'address') next = _draft.copyWith(address: val);
                else if (field == 'phone') next = _draft.copyWith(phone: val);
                else if (field == 'email') next = _draft.copyWith(email: val);
                else if (field == 'fb_url') next = _draft.copyWith(fbUrl: val);
                else if (field == 'instagram_url') next = _draft.copyWith(instagramUrl: val);
                else if (field == 'zalo_url') next = _draft.copyWith(zaloUrl: val);
                _updateDraft(next);
              },
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0891B2), elevation: 0, padding: const EdgeInsets.symmetric(vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
              child: const Text('OK', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            )),
          ]),
        ),
      ),
    );
  }

  void _editNumeric(String field, String label, int current) {
    final ctrl = TextEditingController(text: current.toString());
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
              controller: ctrl, keyboardType: TextInputType.number, autofocus: true,
              decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)), contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10)),
            ),
            const SizedBox(height: 12),
            SizedBox(width: double.infinity, child: ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                final val = int.tryParse(ctrl.text.trim()) ?? current;
                OwnerVenueModel next = _draft;
                if (field == 'min_booking_before_hours') next = _draft.copyWith(minBookingBeforeHours: val);
                else if (field == 'cancellation_before_hours') next = _draft.copyWith(cancellationBeforeHours: val);
                else if (field == 'vat_rate') next = _draft.copyWith(vatRate: val.toDouble());
                _updateDraft(next);
              },
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0891B2), elevation: 0, padding: const EdgeInsets.symmetric(vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
              child: const Text('OK', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
  final bool isLoading;
  final void Function(AmenityModel) onAdd;
  final void Function(String) onDelete;
  final void Function(String) onToggleFree;
  const _AmenitiesTab({required this.amenities, this.isLoading = false, required this.onAdd, required this.onDelete, required this.onToggleFree});

  final _preset = const [
    {'name':'WiFi','icon':'wifi'},{'name':'Bãi đỗ xe','icon':'local_parking'},
    {'name':'Phòng thay đồ','icon':'dry'},{'name':'Nhà vệ sinh','icon':'wc'},
    {'name':'Căng-tin','icon':'local_cafe'},{'name':'Máy lạnh','icon':'ac_unit'},
    {'name':'Điểm sạc điện thoại','icon':'electric_bolt'},{'name':'Tủ đồ','icon':'lock'},
    {'name':'Camera an ninh','icon':'videocam'},{'name':'Đèn chiếu sáng','icon':'light'},
  ];

  @override
  Widget build(BuildContext context) {
    if (isLoading && amenities.isEmpty) return const Center(child: CircularProgressIndicator());
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
  final bool isLoading;
  final void Function(OwnerDayOfWeek, String, String, bool) onHoursChange;
  final void Function(VenueScheduleExceptionModel) onAddException;
  final void Function(String) onDeleteException;
  const _OperatingHoursTab({required this.hours, required this.exceptions, this.isLoading = false, required this.onHoursChange, required this.onAddException, required this.onDeleteException});

  @override
  Widget build(BuildContext context) {
    if (isLoading && hours.isEmpty) return const Center(child: CircularProgressIndicator());
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
    TimeOfDay op = const TimeOfDay(hour: 8, minute: 0);
    TimeOfDay cl = const TimeOfDay(hour: 22, minute: 0);
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
            _ToggleRow(label: 'Đóng cửa cả ngày', value: isClosed, onToggle: () => ss(() => isClosed = !isClosed)),
            if (!isClosed) ...[
              const SizedBox(height: 12),
              Row(children: [
                Expanded(child: _TimePick(label: 'Mở cửa', time: op, onPick: (t) => ss(() => op = t))),
                const SizedBox(width: 12),
                Expanded(child: _TimePick(label: 'Đóng cửa', time: cl, onPick: (t) => ss(() => cl = t))),
              ]),
            ],
            const SizedBox(height: 12),
            TextField(controller: reasonCtrl, decoration: InputDecoration(labelText: 'Lý do (tuỳ chọn)', border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)), contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10))),
            const SizedBox(height: 16),
            SizedBox(width: double.infinity, child: ElevatedButton(
              onPressed: pickedDate == null ? null : () {
                Navigator.pop(ctx);
                onAddException(VenueScheduleExceptionModel(
                  id: '', // Backend gen
                  venueId: '',
                  date: pickedDate!,
                  isClosed: isClosed,
                  openTime: isClosed ? null : _todStr(op),
                  closeTime: isClosed ? null : _todStr(cl),
                  reason: reasonCtrl.text.isEmpty ? null : reasonCtrl.text,
                ));
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.info, elevation: 0, padding: const EdgeInsets.symmetric(vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
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
  final List<File> pendingFiles;
  final bool isLoading;
  final VoidCallback onPickImages;
  final VoidCallback onSavePending;
  final void Function(int) onRemovePending;
  final void Function(String) onDelete;
  final void Function(String) onSetCover;

  const _MediaTab({
    required this.media,
    required this.pendingFiles,
    this.isLoading = false,
    required this.onPickImages,
    required this.onSavePending,
    required this.onRemovePending,
    required this.onDelete,
    required this.onSetCover,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading && media.isEmpty && pendingFiles.isEmpty) return const Center(child: CircularProgressIndicator());
    return SingleChildScrollView(
      padding: const EdgeInsets.all(14),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Text('Ảnh Venue', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
          const Spacer(),
          if (pendingFiles.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ElevatedButton.icon(
                onPressed: isLoading ? null : onSavePending,
                icon: isLoading ? const SizedBox(width: 12, height: 12, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Icon(Icons.check_circle_outline_rounded, size: 16, color: Colors.white),
                label: Text(isLoading ? 'Đang lưu...' : 'Lưu (${pendingFiles.length})', style: const TextStyle(color: Colors.white, fontSize: 11)),
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.success, elevation: 0, padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
              ),
            ),
          ElevatedButton.icon(
            onPressed: onPickImages,
            icon: const Icon(Icons.add_photo_alternate_rounded, size: 16, color: Colors.white),
            label: const Text('Chọn ảnh', style: TextStyle(color: Colors.white, fontSize: 11)),
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0891B2), elevation: 0, padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
          ),
        ]),
        const SizedBox(height: 12),

        // --- PENDING IMAGES ---
        if (pendingFiles.isNotEmpty) ...[
          const Text('Ảnh mới (Chờ lưu)', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.success)),
          const SizedBox(height: 6),
          SizedBox(
            height: 100,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: pendingFiles.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) => Stack(children: [
                Container(
                  width: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(image: FileImage(pendingFiles[i]), fit: BoxFit.cover),
                    border: Border.all(color: AppColors.success.withOpacity(0.5), width: 2),
                  ),
                ),
                Positioned(
                  top: 2, right: 2,
                  child: GestureDetector(
                    onTap: () => onRemovePending(i),
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                      child: const Icon(Icons.close, size: 14, color: AppColors.error),
                    ),
                  ),
                ),
              ]),
            ),
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 16),
        ],

        if (media.isEmpty && pendingFiles.isEmpty)
          Container(
            height: 160, width: double.infinity,
            decoration: BoxDecoration(color: AppColors.borderLight.withOpacity(0.3), borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.borderLight, style: BorderStyle.solid, width: 2)),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(Icons.add_photo_alternate_outlined, size: 40, color: AppColors.textHint.withOpacity(0.5)),
              const SizedBox(height: 8),
              const Text('Chưa có ảnh — Tải ảnh đại diện venue', style: TextStyle(color: AppColors.textHint, fontSize: 12)),
            ]),
          )
        else ...[
          if (media.isNotEmpty) ...[
            const Text('Thư viện ảnh', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textHint)),
            const SizedBox(height: 8),
            GridView.builder(
              shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 6, mainAxisSpacing: 6),
              itemCount: media.length,
              itemBuilder: (_, i) {
                final m = media[i];
                return GestureDetector(
                  onLongPress: () => _showActions(context, m),
                  child: Stack(children: [
                  Container(decoration: BoxDecoration(color: AppColors.borderLight, borderRadius: BorderRadius.circular(8), image: DecorationImage(image: NetworkImage(m.publicUrl), fit: BoxFit.cover))),
                  if (m.isCover) Positioned(top: 4, left: 4, child: Container(padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2), decoration: BoxDecoration(color: AppColors.warning, borderRadius: BorderRadius.circular(4)), child: const Text('Cover', style: TextStyle(fontSize: 8, color: Colors.white, fontWeight: FontWeight.bold)))),
                  Positioned(top: 0, right: 0, child: Container(decoration: BoxDecoration(color: Colors.black.withOpacity(0.3), borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(8), topRight: Radius.circular(8))), child: IconButton(icon: const Icon(Icons.more_vert, size: 14, color: Colors.white), onPressed: () => _showActions(context, m), padding: EdgeInsets.zero, constraints: const BoxConstraints(minWidth: 24, minHeight: 24)))),
                ]));
              },
            ),
          ],
        ],
        const SizedBox(height: 8),
        const Text('Mẹo: Nhấn lâu hoặc bấm menu để Xóa hoặc đặt làm Ảnh Bìa.', style: TextStyle(fontSize: 10, color: AppColors.textHint)),
        const SizedBox(height: 30),
      ]),
    );
  }

  void _showActions(BuildContext context, MediaAttachmentModel m) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(18))),
      builder: (ctx) => SafeArea(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          if (!m.isCover) ListTile(leading: const Icon(Icons.star_rounded, color: AppColors.warning), title: const Text('Đặt làm ảnh bìa'), onTap: () { Navigator.pop(ctx); onSetCover(m.id); }),
          ListTile(leading: const Icon(Icons.delete_outline_rounded, color: AppColors.error), title: const Text('Xóa ảnh'), onTap: () { Navigator.pop(ctx); onDelete(m.id); }),
        ]),
      ),
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

