import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/base/di/injection.dart';
import '../../../../../core/base/state/bloc/base_state.dart';
import '../../../../../design/theme/styles/app_colors.dart';
import '../../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../main/presentation/pages/main_shell_page.dart';
import '../../data/models/profile_models.dart';
import '../cubit/profile_cubit.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<ProfileCubit>()..fetchProfile()),
        BlocProvider(create: (context) => getIt<AuthCubit>()),
      ],
      child: BlocBuilder<ProfileCubit, BaseState<UserModel>>(
        builder: (context, state) {
          final user = state.data;
          return _buildProfile(context, state, user);
        },
      ),
    );
  }

  Widget _buildProfile(BuildContext context, BaseState<UserModel> state, UserModel? user) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading:
                context.canPop() && context.findAncestorWidgetOfExactType<MainShellPage>() == null,
            expandedHeight: 180,
            pinned: true,
            backgroundColor: AppColors.primaryLightBrand,
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
                      const SizedBox(height: 8),
                      Container(
                        width: 76,
                        height: 76,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.white.withOpacity(0.2),
                          border: Border.all(color: AppColors.white, width: 3),
                        ),
                        child: user?.avatarUrl != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(38),
                                child: Image.network(
                                  user!.avatarUrl!,
                                  fit: BoxFit.cover,
                                  width: 70,
                                  height: 70,
                                ),
                              )
                            : const Icon(Icons.person_rounded, color: AppColors.white, size: 40),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        user?.fullName ?? (state.isLoading ? 'Đang tải...' : 'Chưa đăng nhập'),
                        style: const TextStyle(
                            color: AppColors.white, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        user?.email ?? '',
                        style: const TextStyle(color: AppColors.white70, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _ProfileSection(
                    title: 'Tài khoản',
                    items: [
                      _ProfileTile(
                          icon: Icons.person_outline_rounded,
                          label: 'Thông tin cá nhân & Cài đặt',
                          onTap: () => context.push('/profile-settings')),
                      // _ProfileTile(icon: Icons.account_balance_wallet_rounded, label: 'Ví của tôi', trailing: '1.250.000đ', onTap: () => context.push('/wallet')),
                      _ProfileTile(
                          icon: Icons.receipt_long_rounded,
                          label: 'Hóa đơn',
                          onTap: () => context.push('/invoices')),
                      _ProfileTile(
                          icon: Icons.favorite_border_rounded,
                          label: 'Sân yêu thích',
                          onTap: () => context.push('/favorite-venues')),
                      _ProfileTile(
                          icon: Icons.repeat_rounded,
                          label: 'Lịch đặt định kỳ',
                          onTap: () => context.push('/recurring-bookings')),
                      _ProfileTile(
                          icon: Icons.queue_rounded,
                          label: 'Danh sách chờ',
                          onTap: () => context.push('/my-waitlist')),
                      _ProfileTile(
                          icon: Icons.queue_rounded,
                          label: 'map',
                          onTap: () => context.push('/venue-map')),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _ProfileSection(
                    title: 'Tiện ích',
                    items: [
                      _ProfileTile(
                          icon: Icons.local_offer_rounded,
                          label: 'Khuyến mãi & Voucher',
                          onTap: () => context.push('/promotions')),
                      _ProfileTile(
                          icon: Icons.notifications_outlined,
                          label: 'Thông báo',
                          trailing: '3',
                          trailingColor: AppColors.error,
                          onTap: () => context.push('/notifications')),
                      // _ProfileTile(
                      //     icon: Icons.history_rounded,
                      //     label: 'Lịch sử giao dịch',
                      //     onTap: () => context.push('/wallet')),
                      _ProfileTile(
                          icon: Icons.support_agent_rounded,
                          label: 'Hỗ trợ & CSKH',
                          onTap: () => context.push('/support-tickets')),
                      _ProfileTile(
                          icon: Icons.policy_outlined,
                          label: 'Điều khoản & Chính sách',
                          onTap: () {}),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        final ok = await showDialog<bool>(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            title: const Text('Đăng xuất?'),
                            content: const Text('Bạn sẽ cần đăng nhập lại để sử dụng ứng dụng.'),
                            actions: [
                              TextButton(
                                  onPressed: () => Navigator.pop(ctx, false),
                                  child: const Text('Huỷ')),
                              ElevatedButton(
                                onPressed: () => Navigator.pop(ctx, true),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.error,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                ),
                                child: const Text('Đăng xuất',
                                    style: TextStyle(color: AppColors.white)),
                              ),
                            ],
                          ),
                        );
                        if (ok == true && context.mounted) {
                          context.read<AuthCubit>().logout();
                        }
                      },
                      icon: const Icon(Icons.logout_rounded, color: AppColors.error),
                      label: const Text('Đăng xuất',
                          style: TextStyle(color: AppColors.error, fontWeight: FontWeight.bold)),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.error, width: 1.5),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileSection extends StatelessWidget {
  final String title;
  final List<Widget> items;
  const _ProfileSection({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: AppColors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
            child: Text(title,
                style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textHint,
                    letterSpacing: 0.5)),
          ),
          const Divider(height: 1, color: AppColors.borderLight),
          ...items,
        ],
      ),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? trailing;
  final Color? trailingColor;
  final VoidCallback onTap;
  const _ProfileTile(
      {required this.icon,
      required this.label,
      this.trailing,
      this.trailingColor,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
            color: AppColors.primaryLightBrand.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, color: AppColors.primaryLightBrand, size: 20),
      ),
      title: Text(label, style: const TextStyle(fontSize: 14, color: AppColors.textPrimary)),
      trailing: trailing != null
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: (trailingColor ?? AppColors.primaryLightBrand).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(trailing!,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: trailingColor ?? AppColors.primaryLightBrand,
                      fontSize: 12)),
            )
          : const Icon(Icons.chevron_right_rounded, color: AppColors.textHint, size: 20),
      onTap: onTap,
    );
  }
}
