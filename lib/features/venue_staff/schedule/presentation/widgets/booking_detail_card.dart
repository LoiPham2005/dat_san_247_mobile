import 'package:flutter/material.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';

class BookingDetailCard extends StatelessWidget {
  final String? title;
  final Widget? trailing;
  final Widget child;
  const BookingDetailCard({super.key, this.title, this.trailing, required this.child});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)]),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          if (title != null) ...[
            Row(children: [
              Text(title!,
                  style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textHint,
                      letterSpacing: 0.4)),
              if (trailing != null) ...[const Spacer(), trailing!],
            ]),
            const Divider(height: 14, color: AppColors.borderLight),
          ],
          child,
        ]),
      );
}
