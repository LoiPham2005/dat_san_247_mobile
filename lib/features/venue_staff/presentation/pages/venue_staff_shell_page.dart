import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';

/// Placeholder cho Venue Staff shell — sẽ được build đầy đủ sau
class VenueStaffShellPage extends StatelessWidget {
  const VenueStaffShellPage({super.key});

  static const Color _brand = Color(0xFF7C3AED);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: AppBar(
        backgroundColor: _brand,
        automaticallyImplyLeading: false,
        title: const Text('Venue Staff', style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold, fontSize: 17)),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: AppColors.white),
            onPressed: () => context.go('/login'),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100, height: 100,
              decoration: BoxDecoration(color: _brand.withOpacity(0.1), shape: BoxShape.circle),
              child: const Icon(Icons.badge_rounded, size: 50, color: _brand),
            ),
            const SizedBox(height: 24),
            const Text('Venue Staff Portal', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Check-in · Lịch hôm nay · Addon', textAlign: TextAlign.center, style: TextStyle(fontSize: 14, color: AppColors.textSecondary)),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(color: _brand.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
              child: const Text('Đang phát triển 🚀', style: TextStyle(color: _brand, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
