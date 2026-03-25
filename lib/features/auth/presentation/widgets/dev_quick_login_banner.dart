import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../pages/dev_quick_login_page.dart';

class DevQuickLoginBanner extends StatelessWidget {
  const DevQuickLoginBanner({super.key});

  @override
  Widget build(BuildContext context) {
    if (!kDebugMode) return const SizedBox.shrink();

    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const DevQuickLoginPage()),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
          ),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFF334155)),
        ),
        child: const Row(
          children: [
            Icon(Icons.developer_mode_rounded, color: Color(0xFF94A3B8), size: 20),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '🛠 Dev Mode — Đăng nhập nhanh',
                    style: TextStyle(
                      color: Color(0xFFF1F5F9),
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  Text(
                    'Chọn vai trò: Customer · Owner · Staff',
                    style: TextStyle(color: Color(0xFF94A3B8), fontSize: 11),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded, color: Color(0xFF94A3B8), size: 14),
          ],
        ),
      ),
    );
  }
}
