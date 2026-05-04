import 'package:dat_san_247_mobile/core/base/state/riverpod/riverpod_listeners.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/features/customer/profile/data/models/profile_models.dart';
import 'package:dat_san_247_mobile/features/customer/profile/presentation/providers/profile_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../widgets/notification_tab.dart';
import '../widgets/profile_tab.dart';
import '../widgets/sport_interests_tab.dart';

class ProfileSettingsPage extends HookConsumerWidget {
  const ProfileSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabController = useTabController(initialLength: 3);
    final state = ref.watch(profileProvider);
    final notifier = ref.read(profileProvider.notifier);

    useAsyncValueListener(provider: profileProvider, ref: ref);

    return switch (state) {
      AsyncData(:final value) => _buildContent(context, ref, tabController, notifier, value),
      AsyncError(:final error) => Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('$error'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: notifier.refresh,
                  child: const Text('Thử lại'),
                ),
              ],
            ),
          ),
        ),
      _ => const Scaffold(body: Center(child: CircularProgressIndicator())),
    };
  }

  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    TabController tabController,
    ProfileNotifier notifier,
    UserModel user,
  ) {
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
                              onTap: () {},
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
                          if (user.isEmailVerified)
                            _verifyBadge('Email', Icons.email_rounded),
                          const SizedBox(width: 4),
                          if (user.isPhoneVerified)
                            _verifyBadge('SĐT', Icons.phone_rounded),
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
                  controller: tabController,
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
          controller: tabController,
          children: [
            ProfileTab(
              user: user,
              onEditField: (label, current, {multiline = false}) =>
                  _editField(context, notifier, label, current, multiline: multiline),
              onPickGender: () => _pickGender(context, notifier, user),
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
              onPushChanged: (v) => notifier.updateNotificationSettings(notifPush: v),
              onEmailChanged: (v) => notifier.updateNotificationSettings(notifEmail: v),
              onSmsChanged: (v) => notifier.updateNotificationSettings(notifSms: v),
              onBookingChanged: (v) => notifier.updateNotificationSettings(notifBooking: v),
              onPromotionChanged: (v) => notifier.updateNotificationSettings(notifPromotion: v),
              onPaymentChanged: (v) => notifier.updateNotificationSettings(notifPayment: v),
              onSystemChanged: (v) => notifier.updateNotificationSettings(notifSystem: v),
              onSave: () {},
            ),
            SportInterestsTab(
              user: user,
              onSkillChanged: notifier.updateSportPreference,
              onSave: () {},
            ),
          ],
        ),
      ),
    );
  }

  void _editField(
    BuildContext context,
    ProfileNotifier notifier,
    String label,
    String current, {
    bool multiline = false,
  }) {
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
                notifier.updateBasicProfile(fullName: newValue);
              } else if (label == 'Địa chỉ') {
                notifier.updateBasicProfile(address: newValue);
              } else if (label == 'Tiểu sử') {
                notifier.updateBasicProfile(bio: newValue);
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

  void _pickGender(BuildContext context, ProfileNotifier notifier, UserModel user) {
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
                  notifier.updateBasicProfile(gender: g);
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
    if (ok == true && context.mounted) {
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
      _ => (
          AppColors.white70,
          AppColors.white.withOpacity(0.15),
          Icons.shield_outlined,
        ),
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
              style: const TextStyle(
                  fontSize: 10, color: AppColors.white, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      );
}
