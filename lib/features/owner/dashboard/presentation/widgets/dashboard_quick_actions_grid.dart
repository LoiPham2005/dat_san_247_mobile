import 'package:flutter/material.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/features/owner/dashboard/presentation/widgets/dashboard_quick_actions.dart';
import 'package:dat_san_247_mobile/features/owner/staff/presentation/pages/owner_staff_page.dart';
import 'package:dat_san_247_mobile/features/owner/venue/presentation/pages/owner_refund_policy_page.dart';
import 'package:dat_san_247_mobile/features/owner/venue/presentation/pages/owner_venue_manage_page.dart';
import 'package:dat_san_247_mobile/features/owner/venue/presentation/pages/owner_venue_services_page.dart';
import 'package:dat_san_247_mobile/features/owner/venue/presentation/pages/owner_verification_page.dart';
import 'package:dat_san_247_mobile/features/owner/review/presentation/pages/owner_reviews_page.dart';

class DashboardQuickActionsGrid extends StatelessWidget {
  final String venueId;
  final String venueName;

  const DashboardQuickActionsGrid({super.key, required this.venueId, required this.venueName});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(children: [
          Icon(Icons.flash_on_rounded, size: 18, color: Color(0xFF1565C0)),
          SizedBox(width: 8),
          Text('Phím Tắt Quản Lý',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary)),
        ]),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 1.1,
          children: [
            QuickActionBtn(
                icon: Icons.stadium_rounded,
                label: 'Quản Lý\nVenue',
                color: const Color(0xFF0891B2),
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => OwnerVenueManagePage(venueId: venueId)))),
            QuickActionBtn(
                icon: Icons.room_service_rounded,
                label: 'Dịch Vụ\nBán Kèm',
                color: const Color(0xFFE1306C),
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => OwnerVenueServicesPage(
                        venueId: venueId, venueName: venueName)))),
            QuickActionBtn(
                icon: Icons.people_rounded,
                label: 'Nhân\nViên',
                color: const Color(0xFF4267B2),
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => OwnerStaffPage(
                        venueId: venueId, venueName: venueName)))),
            QuickActionBtn(
                icon: Icons.verified_rounded,
                label: 'Xác Minh\nVenue',
                color: AppColors.success,
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => OwnerVerificationPage(
                        venueId: venueId, venueName: venueName)))),
            QuickActionBtn(
                icon: Icons.policy_rounded,
                label: 'Hoàn Tiền\n(Policy)',
                color: AppColors.warning,
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => OwnerRefundPolicyPage(
                        venueId: venueId, venueName: venueName)))),
            QuickActionBtn(
                icon: Icons.rate_review_rounded,
                label: 'Đánh Giá\n(Reviews)',
                color: const Color(0xFF9C27B0),
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => OwnerReviewsPage(
                        venueId: venueId, venueName: venueName)))),
          ],
        ),
      ],
    );
  }
}
