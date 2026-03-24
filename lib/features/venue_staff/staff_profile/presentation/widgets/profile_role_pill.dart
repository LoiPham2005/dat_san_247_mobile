import 'package:flutter/material.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/features/venue_staff/check_in/data/models/check_in_models.dart';

class ProfileRolePill extends StatelessWidget {
  final VenueStaffRole role;
  const ProfileRolePill({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    final (emoji, color) = switch (role) {
      VenueStaffRole.OWNER => ('🔑', AppColors.error),
      VenueStaffRole.MANAGER => ('👑', AppColors.warning),
      VenueStaffRole.STAFF => ('👤', const Color(0xFF7C3AED)),
      VenueStaffRole.RECEPTIONIST => ('🎧', AppColors.info),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
          color: color.withOpacity(0.25),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.4))),
      child: Text('$emoji ${role.label}',
          style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }
}
