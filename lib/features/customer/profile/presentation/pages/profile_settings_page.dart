import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/features/customer/support/data/models/support_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

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
          children: [_buildProfileTab(), _buildNotifTab(), _buildSportTab()],
        ),
      ),
    );
  }

  // ── Tab 1: Hồ sơ ──────────────────────────────────────────────────────
  Widget _buildProfileTab() {
    final p = _user.profile;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // ── Basic info ──
          _SettingCard(
            title: 'Thông tin cơ bản',
            children: [
              _EditRow(
                label: 'Họ và tên',
                value: _user.fullName,
                onEdit: () => _editField(context, 'Họ và tên', _user.fullName),
              ),
              _EditRow(
                label: 'Email',
                value: _user.email,
                trailing: _user.isEmailVerified ? const _VerifiedChip() : null,
                onEdit: null,
              ),
              _EditRow(
                label: 'Số điện thoại',
                value: _user.phone ?? 'Chưa cập nhật',
                onEdit: () => _editField(context, 'Số điện thoại', _user.phone ?? ''),
              ),
              _EditRow(
                label: 'Giới tính',
                value: _user.gender?.label ?? 'Chưa chọn',
                onEdit: () => _pickGender(context),
              ),
              _EditRow(
                label: 'Ngày sinh',
                value: _user.dateOfBirth != null
                    ? DateFormat('dd/MM/yyyy').format(_user.dateOfBirth!)
                    : 'Chưa cập nhật',
                onEdit: () {},
              ),
            ],
          ),
          const SizedBox(height: 14),

          // ── Profile info ──
          _SettingCard(
            title: 'Hồ sơ công khai',
            children: [
              _EditRow(
                label: 'Tiểu sử',
                value: p?.bio ?? 'Chưa cập nhật',
                onEdit: () => _editField(context, 'Tiểu sử', p?.bio ?? ''),
                multiline: true,
              ),
              _EditRow(label: 'Thành phố', value: p?.city ?? 'Chưa chọn', onEdit: () {}),
              _EditRow(label: 'Quận/Huyện', value: p?.district ?? 'Chưa chọn', onEdit: () {}),
            ],
          ),
          const SizedBox(height: 14),

          // ── Referral code ──
          if (p?.referralCode != null)
            _SettingCard(
              title: 'Mời bạn bè',
              children: [_ReferralRow(code: p!.referralCode!)],
            ),
          const SizedBox(height: 14),

          // ── KYC ──
          _SettingCard(
            title: 'Xác minh danh tính (KYC)',
            children: [_KycRow(status: _user.kycStatus, onTap: () => _goKyc(context))],
          ),
          const SizedBox(height: 14),

          // ── Bank accounts ──
          _SettingCard(
            title: 'Tài khoản ngân hàng',
            children: [
              ListTile(
                dense: true,
                leading: const Icon(
                  Icons.account_balance_rounded,
                  color: AppColors.primaryLightBrand,
                  size: 20,
                ),
                title: const Text('Quản lý tài khoản rút tiền', style: TextStyle(fontSize: 14)),
                trailing: const Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.textHint,
                  size: 20,
                ),
                onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('→ Trang quản lý tài khoản ngân hàng')),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // ── Logout / Security ──
          _SettingCard(
            title: 'Bảo mật',
            children: [
              ListTile(
                dense: true,
                leading: const Icon(
                  Icons.lock_outline_rounded,
                  color: AppColors.textSecondary,
                  size: 20,
                ),
                title: const Text('Đổi mật khẩu', style: TextStyle(fontSize: 14)),
                trailing: const Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.textHint,
                  size: 20,
                ),
                onTap: () {},
              ),
              ListTile(
                dense: true,
                leading: const Icon(
                  Icons.devices_rounded,
                  color: AppColors.textSecondary,
                  size: 20,
                ),
                title: const Text('Thiết bị đã đăng nhập', style: TextStyle(fontSize: 14)),
                trailing: const Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.textHint,
                  size: 20,
                ),
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: 14),

          // ── Logout ──
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _confirmLogout(context),
              icon: const Icon(Icons.logout_rounded, color: AppColors.error),
              label: const Text(
                'Đăng xuất',
                style: TextStyle(color: AppColors.error, fontWeight: FontWeight.bold),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.error, width: 1.5),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // ── Tab 2: Thông báo ──────────────────────────────────────────────────
  Widget _buildNotifTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _SettingCard(
            title: 'Kênh thông báo',
            children: [
              _SwitchRow(
                label: 'Push Notification',
                subtitle: 'Thông báo đẩy trực tiếp',
                value: _notifPush,
                icon: Icons.notifications_active_rounded,
                onChanged: (v) => setState(() => _notifPush = v),
              ),
              _SwitchRow(
                label: 'Email',
                subtitle: 'Gửi vào hộp thư email',
                value: _notifEmail,
                icon: Icons.email_rounded,
                onChanged: (v) => setState(() => _notifEmail = v),
              ),
              _SwitchRow(
                label: 'SMS',
                subtitle: 'Tin nhắn điện thoại',
                value: _notifSms,
                icon: Icons.sms_rounded,
                onChanged: (v) => setState(() => _notifSms = v),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _SettingCard(
            title: 'Loại thông báo',
            children: [
              _SwitchRow(
                label: 'Đặt sân & Booking',
                subtitle: 'Xác nhận, nhắc lịch, check-in',
                value: _notifBooking,
                icon: Icons.sports_soccer_rounded,
                onChanged: (v) => setState(() => _notifBooking = v),
              ),
              _SwitchRow(
                label: 'Khuyến mãi',
                subtitle: 'Voucher, ưu đãi mới',
                value: _notifPromotion,
                icon: Icons.local_offer_rounded,
                onChanged: (v) => setState(() => _notifPromotion = v),
              ),
              _SwitchRow(
                label: 'Thanh toán',
                subtitle: 'Biến động số dư ví',
                value: _notifPayment,
                icon: Icons.account_balance_wallet_rounded,
                onChanged: (v) => setState(() => _notifPayment = v),
              ),
              _SwitchRow(
                label: 'Hệ thống',
                subtitle: 'Cập nhật ứng dụng, chính sách',
                value: _notifSystem,
                icon: Icons.info_outline_rounded,
                onChanged: (v) => setState(() => _notifSystem = v),
              ),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('✅ Đã lưu cài đặt thông báo'),
                  backgroundColor: AppColors.primaryLightBrand,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryLightBrand,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text(
                'Lưu cài đặt',
                style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // ── Tab 3: Sở thích ──────────────────────────────────────────────────
  Widget _buildSportTab() {
    final prefs = _user.profile?.sportPreferences ?? [];
    final allSports = [
      'FOOTBALL',
      'FUTSAL',
      'BADMINTON',
      'TENNIS',
      'PICKLEBALL',
      'BASKETBALL',
      'VOLLEYBALL',
    ];
    final selectedSports = prefs.map((p) => p.sportType).toSet();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SettingCard(
            title: 'Môn thể thao yêu thích',
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Chọn các môn bạn yêu thích để nhận gợi ý sân phù hợp:',
                      style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: allSports.map((sport) {
                        final sel = selectedSports.contains(sport);
                        return GestureDetector(
                          onTap: () => HapticFeedback.selectionClick(),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: sel
                                  ? AppColors.primaryLightBrand.withOpacity(0.1)
                                  : AppColors.mutedLight,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: sel ? AppColors.primaryLightBrand : AppColors.borderLight,
                                width: sel ? 1.5 : 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(_sportEmoji(sport), style: const TextStyle(fontSize: 16)),
                                const SizedBox(width: 6),
                                Text(
                                  _sportLabel(sport),
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: sel
                                        ? AppColors.primaryLightBrand
                                        : AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Skill levels for selected sports
          if (prefs.isNotEmpty) ...[
            _SettingCard(
              title: 'Trình độ của bạn',
              children: [
                ...prefs.map(
                  (pref) => _SkillRow(
                    sport: pref.sportType,
                    skillLevel: pref.skillLevel,
                    onChanged: (_) {},
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
          ],

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('✅ Đã lưu sở thích thể thao'),
                  backgroundColor: AppColors.primaryLightBrand,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryLightBrand,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text(
                'Lưu sở thích',
                style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // ── Dialogs & Actions ──────────────────────────────────────────────────
  void _editField(BuildContext context, String label, String current, {bool multiline = false}) {
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

  String _sportEmoji(String sport) {
    return switch (sport.toUpperCase()) {
      'FOOTBALL' => '⚽',
      'FUTSAL' => '🥅',
      'BADMINTON' => '🏸',
      'TENNIS' => '🎾',
      'PICKLEBALL' => '🏓',
      'BASKETBALL' => '🏀',
      'VOLLEYBALL' => '🏐',
      _ => '🏅',
    };
  }

  String _sportLabel(String sport) {
    return switch (sport.toUpperCase()) {
      'FOOTBALL' => 'Bóng đá',
      'FUTSAL' => 'Futsal',
      'BADMINTON' => 'Cầu lông',
      'TENNIS' => 'Tennis',
      'PICKLEBALL' => 'Pickleball',
      'BASKETBALL' => 'Bóng rổ',
      'VOLLEYBALL' => 'Bóng chuyền',
      _ => sport,
    };
  }
}

// ──────────────────────────────────────────────────────────────────────────
// Sub-widgets
// ──────────────────────────────────────────────────────────────────────────
class _SettingCard extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const _SettingCard({required this.title, required this.children});

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(14),
      boxShadow: [BoxShadow(color: AppColors.black.withOpacity(0.04), blurRadius: 8)],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 8),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppColors.textHint,
              letterSpacing: 0.5,
            ),
          ),
        ),
        const Divider(height: 1, color: AppColors.borderLight),
        ...children,
      ],
    ),
  );
}

class _EditRow extends StatelessWidget {
  final String label;
  final String value;
  final Widget? trailing;
  final VoidCallback? onEdit;
  final bool multiline;
  const _EditRow({
    required this.label,
    required this.value,
    this.trailing,
    this.onEdit,
    this.multiline = false,
  });

  @override
  Widget build(BuildContext context) => ListTile(
    dense: true,
    title: Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textHint)),
    subtitle: Text(
      value,
      style: const TextStyle(
        fontSize: 13,
        color: AppColors.textPrimary,
        fontWeight: FontWeight.w500,
      ),
    ),
    trailing:
        trailing ??
        (onEdit != null
            ? IconButton(
                icon: const Icon(Icons.edit_outlined, size: 16, color: AppColors.textHint),
                onPressed: onEdit,
              )
            : null),
    onTap: onEdit,
  );
}

class _SwitchRow extends StatelessWidget {
  final String label;
  final String subtitle;
  final bool value;
  final IconData icon;
  final ValueChanged<bool> onChanged;
  const _SwitchRow({
    required this.label,
    required this.subtitle,
    required this.value,
    required this.icon,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) => ListTile(
    dense: true,
    leading: Icon(icon, size: 20, color: value ? AppColors.primaryLightBrand : AppColors.textHint),
    title: Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
    subtitle: Text(subtitle, style: const TextStyle(fontSize: 11, color: AppColors.textHint)),
    trailing: Switch.adaptive(
      value: value,
      onChanged: (v) {
        HapticFeedback.selectionClick();
        onChanged(v);
      },
      activeColor: AppColors.primaryLightBrand,
    ),
  );
}

class _SkillRow extends StatelessWidget {
  final String sport;
  final int skillLevel;
  final ValueChanged<int> onChanged;
  const _SkillRow({required this.sport, required this.skillLevel, required this.onChanged});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(14, 10, 14, 8),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _label(sport),
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        Row(
          children: List.generate(
            5,
            (i) => Expanded(
              child: GestureDetector(
                onTap: () => onChanged(i + 1),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  height: 6,
                  decoration: BoxDecoration(
                    color: i < skillLevel ? AppColors.primaryLightBrand : AppColors.borderLight,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          _skillLabel(skillLevel),
          style: const TextStyle(fontSize: 11, color: AppColors.textHint),
        ),
      ],
    ),
  );

  String _label(String sport) {
    return switch (sport.toUpperCase()) {
      'FOOTBALL' => '⚽ Bóng đá',
      'BADMINTON' => '🏸 Cầu lông',
      'TENNIS' => '🎾 Tennis',
      _ => sport,
    };
  }

  String _skillLabel(int level) {
    return switch (level) {
      1 => 'Mới bắt đầu',
      2 => 'Cơ bản',
      3 => 'Trung bình',
      4 => 'Khá',
      _ => 'Chuyên nghiệp',
    };
  }
}

class _VerifiedChip extends StatelessWidget {
  const _VerifiedChip();
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
    decoration: BoxDecoration(
      color: AppColors.success.withOpacity(0.1),
      borderRadius: BorderRadius.circular(20),
    ),
    child: const Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.verified_rounded, size: 11, color: AppColors.success),
        SizedBox(width: 3),
        Text(
          'Đã xác minh',
          style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.success),
        ),
      ],
    ),
  );
}

class _KycRow extends StatelessWidget {
  final KycStatus status;
  final VoidCallback onTap;
  const _KycRow({required this.status, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isVerified = status == KycStatus.VERIFIED;
    return ListTile(
      dense: true,
      leading: Icon(
        isVerified ? Icons.verified_user_rounded : Icons.shield_outlined,
        color: isVerified ? AppColors.success : AppColors.warning,
        size: 22,
      ),
      title: Text(
        status.label,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: isVerified ? AppColors.success : AppColors.warning,
        ),
      ),
      subtitle: Text(
        isVerified
            ? 'Tài khoản đã được xác minh danh tính'
            : 'Xác minh để mở khoá đầy đủ tính năng',
        style: const TextStyle(fontSize: 11, color: AppColors.textHint),
      ),
      trailing: isVerified
          ? null
          : ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.warning,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text(
                'Xác minh',
                style: TextStyle(color: AppColors.white, fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),
    );
  }
}

class _ReferralRow extends StatelessWidget {
  final String code;
  const _ReferralRow({required this.code});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(14),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Mã giới thiệu của bạn',
          style: TextStyle(fontSize: 12, color: AppColors.textHint),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.primaryLightBrand.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.primaryLightBrand.withOpacity(0.3)),
                ),
                child: Text(
                  code,
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    color: AppColors.primaryLightBrand,
                    fontSize: 18,
                    letterSpacing: 2,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: () {
                Clipboard.setData(ClipboardData(text: code));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('📋 Đã sao chép "$code"'),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primaryLightBrand,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.copy_rounded, color: AppColors.white, size: 18),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Text(
          'Chia sẻ mã này với bạn bè để cả hai nhận ưu đãi!',
          style: TextStyle(fontSize: 11, color: AppColors.textHint),
        ),
      ],
    ),
  );
}
