import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/base/di/injection.dart';
import '../../../../../core/base/state/bloc/base_state.dart';
import '../../../../../design/theme/styles/app_colors.dart';
import '../cubit/profile_cubit.dart';
import '../widgets/notification_tab.dart';
import '../widgets/profile_tab.dart';
import '../widgets/sport_interests_tab.dart';
import '../../data/models/profile_models.dart';

class ProfileSettingsPage extends StatefulWidget {
  const ProfileSettingsPage({super.key});

  @override
  State<ProfileSettingsPage> createState() => _ProfileSettingsPageState();
}

class _ProfileSettingsPageState extends State<ProfileSettingsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ProfileCubit>()..fetchProfile(),
      child: BlocBuilder<ProfileCubit, BaseState<UserModel>>(
        builder: (context, state) {
          final user = state.data;

          if (state.isLoading && user == null) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (state.isFailure && user == null) {
            return Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(state.error ?? 'Đã xảy ra lỗi'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => context.read<ProfileCubit>().fetchProfile(),
                      child: const Text('Thử lại'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (user == null) {
            return const Scaffold(
              body: Center(child: Text('Không tìm thấy thông tin người dùng')),
            );
          }

          return Scaffold(
            backgroundColor: const Color(0xFFF4F6FA),
            body: NestedScrollView(
              headerSliverBuilder: (ctx, _) => [
                SliverAppBar(
                  expandedHeight: 250,
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
                            // const SizedBox(height: 40),
                            Stack(
                              children: [
                                CircleAvatar(
                                  radius: 42,
                                  backgroundColor: AppColors.white.withOpacity(0.2),
                                  child: user.avatarUrl != null
                                      ? ClipRRect(
                                          borderRadius: BorderRadius.circular(42),
                                          child: Image.network(
                                            user.avatarUrl!,
                                            fit: BoxFit.cover,
                                            width: 84,
                                            height: 84,
                                          ),
                                        )
                                      : Text(
                                          user.fullName.isNotEmpty
                                              ? user.fullName[0].toUpperCase()
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
                                    onTap: () {
                                      // TODO: Upload avatar
                                    },
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
                              user.fullName,
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
                                _kycBadge(user.kycStatus),
                                const SizedBox(width: 8),
                                if (user.isEmailVerified) _verifyBadge('Email', Icons.email_rounded),
                                const SizedBox(width: 4),
                                if (user.isPhoneVerified) _verifyBadge('SĐT', Icons.phone_rounded),
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
                    user: user,
                    onEditField: (label, current, {multiline = false}) =>
                        _editField(context, label, current, multiline: multiline),
                    onPickGender: () => _pickGender(context, user),
                    onGoKyc: () => context.push('/kyc'),
                    onLogout: () => _confirmLogout(context),
                  ),
                  NotificationTab(
                    notifPush: user.profile?.notifPush ?? true,
                    notifEmail: user.profile?.notifEmail ?? true,
                    notifSms: user.profile?.notifSms ?? false,
                    notifBooking: user.profile?.notifBooking ?? true,
                    notifPromotion: user.profile?.notifPromotion ?? true,
                    notifPayment: user.profile?.notifPayment ?? true,
                    notifSystem: user.profile?.notifSystem ?? true,
                    onPushChanged: (v) => context.read<ProfileCubit>().updateNotificationSettings(notifPush: v),
                    onEmailChanged: (v) => context.read<ProfileCubit>().updateNotificationSettings(notifEmail: v),
                    onSmsChanged: (v) => context.read<ProfileCubit>().updateNotificationSettings(notifSms: v),
                    onBookingChanged: (v) => context.read<ProfileCubit>().updateNotificationSettings(notifBooking: v),
                    onPromotionChanged: (v) => context.read<ProfileCubit>().updateNotificationSettings(notifPromotion: v),
                    onPaymentChanged: (v) => context.read<ProfileCubit>().updateNotificationSettings(notifPayment: v),
                    onSystemChanged: (v) => context.read<ProfileCubit>().updateNotificationSettings(notifSystem: v),
                    onSave: () {}, // Handled by individual changes
                  ),
                  SportInterestsTab(
                    user: user,
                    onSkillChanged: (sport, level) => context.read<ProfileCubit>().updateSportPreference(sport, level),
                    onSave: () {}, // Handled by individual changes
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

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
              final newValue = ctrl.text.trim();
              if (label == 'Họ và tên') {
                context.read<ProfileCubit>().updateBasicProfile(fullName: newValue);
              } else if (label == 'Địa chỉ') {
                context.read<ProfileCubit>().updateBasicProfile(address: newValue);
              } else if (label == 'Tiểu sử') {
                context.read<ProfileCubit>().updateBasicProfile(bio: newValue);
              }
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

  void _pickGender(BuildContext context, UserModel user) {
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
                trailing: user.gender == g
                    ? const Icon(Icons.check_rounded, color: AppColors.primaryLightBrand)
                    : null,
                onTap: () {
                  Navigator.pop(context);
                  context.read<ProfileCubit>().updateBasicProfile(gender: g);
                },
              ),
            )
            .toList(),
      ),
    );
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
      // TODO: Perform logout via AuthCubit/AuthService
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
