import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/features/customer/support/data/models/support_models.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/profile_tab.dart';
import '../widgets/notification_tab.dart';
import '../widgets/sport_interests_tab.dart';

// ──────────────────────────────────────────────────────────────────────────
// C-22: Hồ Sơ & Cài Đặt
// ──────────────────────────────────────────────────────────────────────────
class ProfileSettingsPage extends StatefulWidget {
  const ProfileSettingsPage({super.key});

  @override
  State<ProfileSettingsPage> createState() => _ProfileSettingsPageState();
}

class _ProfileSettingsPageState extends State<ProfileSettingsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Mock user data
  final UserModel _user = UserModel(
    id: 'u1',
    email: 'nguyen.van.a@gmail.com',
    fullName: 'Nguyễn Văn A',
    phone: '0912345678',
    avatarUrl: null,
    gender: Gender.MALE,
    dateOfBirth: DateTime(1995, 6, 15),
    kycStatus: KycStatus.UNVERIFIED,
    isEmailVerified: true,
    isPhoneVerified: true,
    createdAt: DateTime(2025, 1, 1),
    profile: const UserProfileModel(
      id: 'up1',
      userId: 'u1',
      bio: 'Mê đá bóng cuối tuần và cầu lông mỗi sáng!',
      city: 'Hà Nội',
      district: 'Cầu Giấy',
      address: '123 Phạm Văn Đồng',
      referralCode: 'NVAN2025',
      notifPush: true,
      notifEmail: true,
      notifSms: false,
      notifBooking: true,
      notifPromotion: true,
      notifPayment: true,
      notifSystem: true,
      notifStaff: false,
      sportPreferences: [
        SportPreferenceModel(id: 's1', userProfileId: 'up1', sportType: 'FOOTBALL', skillLevel: 3),
        SportPreferenceModel(id: 's2', userProfileId: 'up1', sportType: 'BADMINTON', skillLevel: 2),
      ],
    ),
  );

  bool _notifPush = true;
  bool _notifEmail = true;
  bool _notifSms = false;
  bool _notifBooking = true;
  bool _notifPromotion = true;
  bool _notifPayment = true;
  bool _notifSystem = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    final p = _user.profile;
    if (p != null) {
      _notifPush = p.notifPush;
      _notifEmail = p.notifEmail;
      _notifSms = p.notifSms;
      _notifBooking = p.notifBooking;
      _notifPromotion = p.notifPromotion;
      _notifPayment = p.notifPayment;
      _notifSystem = p.notifSystem;
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      body: NestedScrollView(
        headerSliverBuilder: (ctx, _) => [
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            backgroundColor: AppColors.primaryLightBrand,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.white),
              onPressed: () => context.pop(),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF0F7A35), Color(0xFF22C55E)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 42,
                            backgroundColor: AppColors.white.withOpacity(0.2),
                            child: _user.avatarUrl != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(42),
                                    child: Image.network(
                                      _user.avatarUrl!,
                                      fit: BoxFit.cover,
                                      width: 84,
                                      height: 84,
                                    ),
                                  )
                                : Text(
                                    _user.fullName.isNotEmpty
                                        ? _user.fullName[0].toUpperCase()
                                        : 'U',
                                    style: const TextStyle(
                                      fontSize: 36,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.white,
                                    ),
                                  ),
                          ),
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: GestureDetector(
                              onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('📷 Chọn ảnh đại diện...')),
                              ),
                              child: Container(
                                width: 28,
                                height: 28,
                                decoration: const BoxDecoration(
                                  color: AppColors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.camera_alt_rounded,
                                  size: 16,
                                  color: AppColors.primaryLightBrand,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        _user.fullName,
                        style: const TextStyle(
                          color: AppColors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _kycBadge(_user.kycStatus),
                          const SizedBox(width: 8),
                          if (_user.isEmailVerified) _verifyBadge('Email', Icons.email_rounded),
                          const SizedBox(width: 4),
                          if (_user.isPhoneVerified) _verifyBadge('SĐT', Icons.phone_rounded),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(44),
              child: Container(
                color: AppColors.white,
                child: TabBar(
                  controller: _tabController,
                  labelColor: AppColors.primaryLightBrand,
                  unselectedLabelColor: AppColors.textHint,
                  indicatorColor: AppColors.primaryLightBrand,
                  labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
                  tabs: const [
                    Tab(text: 'Hồ sơ'),
                    Tab(text: 'Thông báo'),
                    Tab(text: 'Sở thích'),
                  ],
                ),
              ),
            ),
          ),
        ],
        body: TabBarView(
          controller: _tabController,
          children: [
            ProfileTab(
              user: _user,
              onEditField: (label, current, {multiline = false}) => _editField(label, current, multiline: multiline),
              onPickGender: () => _pickGender(context),
              onGoKyc: () => _goKyc(context),
              onLogout: () => _confirmLogout(context),
            ),
            NotificationTab(
              notifPush: _notifPush,
              notifEmail: _notifEmail,
              notifSms: _notifSms,
              notifBooking: _notifBooking,
              notifPromotion: _notifPromotion,
              notifPayment: _notifPayment,
              notifSystem: _notifSystem,
              onPushChanged: (v) => setState(() => _notifPush = v),
              onEmailChanged: (v) => setState(() => _notifEmail = v),
              onSmsChanged: (v) => setState(() => _notifSms = v),
              onBookingChanged: (v) => setState(() => _notifBooking = v),
              onPromotionChanged: (v) => setState(() => _notifPromotion = v),
              onPaymentChanged: (v) => setState(() => _notifPayment = v),
              onSystemChanged: (v) => setState(() => _notifSystem = v),
              onSave: () => _showSavedSnackBar('Cài đặt thông báo'),
            ),
            SportInterestsTab(
              user: _user,
              onSave: () => _showSavedSnackBar('Sở thích thể thao'),
            )
          ],
        ),
      ),
    );
  }

  void _showSavedSnackBar(String subject) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('✅ Đã lưu $subject'),
        backgroundColor: AppColors.primaryLightBrand,
      ),
    );
  }

  // ── Dialogs & Actions ──────────────────────────────────────────────────
  void _editField(String label, String current, {bool multiline = false}) {
    final ctrl = TextEditingController(text: current);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Chỉnh sửa $label'),
        content: TextField(
          controller: ctrl,
          maxLines: multiline ? 4 : 1,
          autofocus: true,
          decoration: InputDecoration(
            hintText: label,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Huỷ')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('✅ Đã cập nhật $label'),
                  backgroundColor: AppColors.primaryLightBrand,
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryLightBrand,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Lưu', style: TextStyle(color: AppColors.white)),
          ),
        ],
      ),
    );
  }

  void _pickGender(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: Gender.values
            .map(
              (g) => ListTile(
                title: Text(g.label),
                trailing: _user.gender == g
                    ? const Icon(Icons.check_rounded, color: AppColors.primaryLightBrand)
                    : null,
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('✅ Đã chọn: ${g.label}'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
              ),
            )
            .toList(),
      ),
    );
  }

  void _goKyc(BuildContext context) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('→ Trang xác minh danh tính KYC')));
  }

  Future<void> _confirmLogout(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Đăng xuất?'),
        content: const Text('Bạn sẽ cần đăng nhập lại để sử dụng ứng dụng.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Huỷ')),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Đăng xuất', style: TextStyle(color: AppColors.white)),
          ),
        ],
      ),
    );
    if (ok == true && mounted) {
      context.go('/login');
    }
  }

  Widget _kycBadge(KycStatus status) {
    final (color, bg, icon) = switch (status) {
      KycStatus.VERIFIED => (
        AppColors.success,
        AppColors.success.withOpacity(0.15),
        Icons.verified_rounded,
      ),
      KycStatus.PENDING => (
        AppColors.warning,
        AppColors.warning.withOpacity(0.15),
        Icons.pending_rounded,
      ),
      KycStatus.REJECTED => (
        AppColors.error,
        AppColors.error.withOpacity(0.15),
        Icons.cancel_rounded,
      ),
      _ => (AppColors.white70, AppColors.white.withOpacity(0.15), Icons.shield_outlined),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            status.label,
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: color),
          ),
        ],
      ),
    );
  }

  Widget _verifyBadge(String label, IconData icon) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
    decoration: BoxDecoration(
      color: AppColors.white.withOpacity(0.2),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 11, color: AppColors.white),
        const SizedBox(width: 3),
        Text(
          label,
          style: const TextStyle(fontSize: 10, color: AppColors.white, fontWeight: FontWeight.bold),
        ),
      ],
    ),
  );
}
