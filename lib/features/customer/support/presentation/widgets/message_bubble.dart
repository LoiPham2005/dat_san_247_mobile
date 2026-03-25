import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/features/customer/support/data/models/support_models.dart';

class MessageBubble extends StatelessWidget {
  final TicketMessageModel message;
  const MessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final isMe = !message.isStaff;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isMe) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.primaryLightBrand.withOpacity(0.15),
              child: const Icon(Icons.support_agent_rounded,
                  size: 18, color: AppColors.primaryLightBrand),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment:
                  isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                if (!isMe)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 3, left: 2),
                    child: Text(message.senderName,
                        style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textHint)),
                  ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: isMe ? AppColors.primaryLightBrand : AppColors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft: Radius.circular(isMe ? 16 : 4),
                      bottomRight: Radius.circular(isMe ? 4 : 16),
                    ),
                    boxShadow: [
                      BoxShadow(color: AppColors.black.withOpacity(0.05), blurRadius: 4)
                    ],
                  ),
                  child: Text(
                    message.message,
                    style: TextStyle(
                        fontSize: 13,
                        color: isMe ? AppColors.white : AppColors.textPrimary,
                        height: 1.4),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 3, left: 2, right: 2),
                  child: Text(DateFormat('HH:mm').format(message.createdAt),
                      style: const TextStyle(fontSize: 10, color: AppColors.textHint)),
                ),
              ],
            ),
          ),
          if (isMe) const SizedBox(width: 4),
        ],
      ),
    );
  }
}
