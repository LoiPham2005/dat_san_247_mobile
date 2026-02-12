import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  final String? imageUrl;
  final String? name; // For fallback initials
  final double radius;
  final VoidCallback? onTap;

  const UserAvatar({super.key, this.imageUrl, this.name, this.radius = 24, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        radius: radius,
        backgroundImage: imageUrl != null ? NetworkImage(imageUrl!) : null,
        child: imageUrl == null
            ? Text(
                (name?.isNotEmpty == true) ? name![0].toUpperCase() : '?',
                style: TextStyle(fontSize: radius),
              )
            : null,
      ),
    );
  }
}
