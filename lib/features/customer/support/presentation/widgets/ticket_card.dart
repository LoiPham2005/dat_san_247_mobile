import 'package:flutter/material.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/features/customer/support/data/models/support_models.dart';

class TicketCard extends StatelessWidget {
  final SupportTicketModel ticket;
  final VoidCallback onTap;

  const TicketCard({
    super.key,
    required this.ticket,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final (statusColor, statusBg) = _statusStyle(ticket.status);
    final (_, priorityColor) = _priorityStyle(ticket.priority);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(color: AppColors.black.withOpacity(0.04), blurRadius: 8)
          ],
          border: ticket.status == SupportTicketStatus.OPEN
              ? Border.all(color: AppColors.warning.withOpacity(0.3))
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(ticket.category.icon, style: const TextStyle(fontSize: 18)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(ticket.subject,
                      style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                  decoration: BoxDecoration(
                      color: statusBg, borderRadius: BorderRadius.circular(20)),
                  child: Text(ticket.status.label,
                      style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: statusColor)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(ticket.ticketNumber,
                    style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textHint,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5)),
                const SizedBox(width: 8),
                Container(
                    width: 4,
                    height: 4,
                    decoration: const BoxDecoration(
                        color: AppColors.borderLight, shape: BoxShape.circle)),
                const SizedBox(width: 8),
                Text(ticket.category.label,
                    style:
                        const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                      color: priorityColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6)),
                  child: Text(ticket.priority.label,
                      style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: priorityColor)),
                ),
              ],
            ),
            if (ticket.bookingCode != null) ...[
              const SizedBox(height: 6),
              Row(children: [
                const Icon(Icons.confirmation_number_outlined,
                    size: 12, color: AppColors.textHint),
                const SizedBox(width: 4),
                Text('Booking: ${ticket.bookingCode}',
                    style:
                        const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
              ]),
            ],
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(children: [
                  const Icon(Icons.chat_bubble_outline_rounded,
                      size: 12, color: AppColors.textHint),
                  const SizedBox(width: 4),
                  Text('${ticket.messages.length} tin nhắn',
                      style:
                          const TextStyle(fontSize: 11, color: AppColors.textHint)),
                ]),
                Text(_timeAgo(ticket.updatedAt),
                    style:
                        const TextStyle(fontSize: 11, color: AppColors.textHint)),
              ],
            ),
            if (ticket.customerRating != null) ...[
              const SizedBox(height: 6),
              Row(
                  children: List.generate(
                      5,
                      (i) => Icon(
                            i < ticket.customerRating!
                                ? Icons.star_rounded
                                : Icons.star_border_rounded,
                            size: 14,
                            color: AppColors.warning,
                          ))),
            ],
          ],
        ),
      ),
    );
  }

  (Color, Color) _statusStyle(SupportTicketStatus s) {
    switch (s) {
      case SupportTicketStatus.OPEN:
        return (AppColors.warning, AppColors.warning.withOpacity(0.12));
      case SupportTicketStatus.IN_PROGRESS:
        return (AppColors.info, AppColors.info.withOpacity(0.1));
      case SupportTicketStatus.RESOLVED:
        return (AppColors.success, AppColors.success.withOpacity(0.1));
      case SupportTicketStatus.CLOSED:
        return (AppColors.textHint, AppColors.mutedLight);
      case SupportTicketStatus.REOPENED:
        return (AppColors.error, AppColors.error.withOpacity(0.08));
    }
  }

  (String, Color) _priorityStyle(SupportTicketPriority p) {
    switch (p) {
      case SupportTicketPriority.LOW:
        return ('Thấp', AppColors.textHint);
      case SupportTicketPriority.MEDIUM:
        return ('Trung bình', AppColors.warning);
      case SupportTicketPriority.HIGH:
        return ('Cao', AppColors.error);
      case SupportTicketPriority.URGENT:
        return ('Khẩn cấp', const Color(0xFF9C27B0));
    }
  }

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes} phút trước';
    if (diff.inHours < 24) return '${diff.inHours} giờ trước';
    return '${diff.inDays} ngày trước';
  }
}
