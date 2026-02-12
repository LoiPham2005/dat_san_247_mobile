import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class VenueActionButtons extends StatelessWidget {
  final String phone;
  final String? email;
  final String? message;
  final VoidCallback onDirectionsPressed;
  final ColorScheme colorScheme;

  const VenueActionButtons({
    super.key,
    required this.phone,
    this.email,
    this.message,
    required this.onDirectionsPressed,
    required this.colorScheme,
  });

  Future<void> _callPhone(BuildContext context) async {
    final Uri uri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không thể thực hiện cuộc gọi')),
      );
    }
  }

  void _showContactSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Liên hệ với sân',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.phone, color: Colors.green),
              title: const Text('Gọi điện'),
              onTap: () async {
                final uri = Uri(scheme: 'tel', path: phone);
                if (await canLaunchUrl(uri)) await launchUrl(uri);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.sms, color: Colors.blue),
              title: const Text('Nhắn tin SMS'),
              onTap: () async {
                final uri = Uri(scheme: 'sms', path: phone);
                if (await canLaunchUrl(uri)) await launchUrl(uri);
                Navigator.pop(context);
              },
            ),
            if (email != null)
              ListTile(
                leading: const Icon(Icons.email, color: Colors.red),
                title: const Text('Gửi Email'),
                onTap: () async {
                  final uri = Uri(scheme: 'mailto', path: email);
                  if (await canLaunchUrl(uri)) await launchUrl(uri);
                  Navigator.pop(context);
                },
              ),
            // Zalo (dùng url scheme, cần app Zalo cài trên máy)
            ListTile(
              leading: const Icon(Icons.chat, color: Colors.blueAccent),
              title: const Text('Zalo'),
              onTap: () async {
                final zaloUrl = Uri.parse('https://zalo.me/$phone');
                if (await canLaunchUrl(zaloUrl)) await launchUrl(zaloUrl);
                Navigator.pop(context);
              },
            ),
            // Messenger (nếu có link hoặc username)
            ListTile(
              leading: const Icon(Icons.message, color: Colors.indigo),
              title: const Text('Messenger'),
              onTap: () async {
                // Thay 'username' bằng username hoặc link Messenger của sân
                final messengerUrl = Uri.parse('https://m.me/username');
                if (await canLaunchUrl(messengerUrl))
                  await launchUrl(messengerUrl);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4F8AF4), // Xanh dương đậm
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
                elevation: 6,
                shadowColor: const Color(0xFF4F8AF4).withOpacity(0.3),
              ),
              icon: const Icon(Icons.chat),
              label: const Text(
                "Liên hệ",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                _showContactSheet(context);
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFB74D), // Cam nhạt
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
                elevation: 6,
                shadowColor: const Color(0xFFFFB74D).withOpacity(0.3),
              ),
              onPressed: onDirectionsPressed,
              child: const Icon(Icons.directions),
            ),
          ),
        ],
      ),
    );
  }
}
