import 'package:flutter/material.dart';

class SettingsProfileHeader extends StatelessWidget {
  final String name;
  final String type;
  final String avatarLetter;
  final Color brand;
  const SettingsProfileHeader({
    super.key,
    required this.name,
    required this.type,
    required this.avatarLetter,
    required this.brand,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 40, 20, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 36,
            backgroundColor: Colors.white,
            child: Text(avatarLetter,
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: brand)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(name,
                    style: const TextStyle(
                        color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
                  child: Text(type,
                      style: const TextStyle(
                          color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          const Icon(Icons.edit_rounded, color: Colors.white, size: 20),
        ],
      ),
    );
  }
}
