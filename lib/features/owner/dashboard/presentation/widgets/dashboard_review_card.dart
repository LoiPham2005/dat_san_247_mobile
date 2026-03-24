import 'package:flutter/material.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';

class DashboardReviewCard extends StatelessWidget {
  final Map<String, dynamic> review;
  final VoidCallback onReply;
  const DashboardReviewCard({super.key, required this.review, required this.onReply});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: AppColors.black.withOpacity(0.04), blurRadius: 8)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.warning.withOpacity(0.15),
              child: Text('${review['reviewer'][0]}',
                  style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.warning)),
            ),
            const SizedBox(width: 8),
            Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(review['reviewer'],
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
              Row(children: [
                ...List.generate(
                    5,
                    (i) => Icon(
                        i < review['rating'] ? Icons.star_rounded : Icons.star_border_rounded,
                        size: 13,
                        color: AppColors.warning)),
                const SizedBox(width: 4),
                Text(review['ago'],
                    style: const TextStyle(fontSize: 10, color: AppColors.textHint)),
              ]),
            ])),
            if (!review['replied'])
              GestureDetector(
                onTap: onReply,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                      color: const Color(0xFF1565C0).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8)),
                  child: const Text('Phản hồi',
                      style: TextStyle(
                          fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF1565C0))),
                ),
              )
            else
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                    color: AppColors.success.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8)),
                child: const Text('Đã phản hồi',
                    style: TextStyle(
                        fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.success)),
              ),
          ]),
          if (review['comment'] != null && (review['comment'] as String).isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(review['comment'],
                style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, height: 1.4),
                maxLines: 2,
                overflow: TextOverflow.ellipsis),
          ],
        ],
      ),
    );
  }
}
