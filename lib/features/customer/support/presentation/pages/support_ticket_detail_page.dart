import 'package:flutter/material.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/features/customer/support/data/models/support_models.dart';
import '../widgets/message_bubble.dart';

class SupportTicketDetailPage extends StatefulWidget {
  final SupportTicketModel ticket;
  const SupportTicketDetailPage({super.key, required this.ticket});

  @override
  State<SupportTicketDetailPage> createState() => _SupportTicketDetailPageState();
}

class _SupportTicketDetailPageState extends State<SupportTicketDetailPage> {
  final _msgCtrl = TextEditingController();
  final _scrollCtrl = ScrollController();
  late List<TicketMessageModel> _messages;
  bool _showRating = false;
  int _selectedRating = 0;

  @override
  void initState() {
    super.initState();
    _messages = List.from(widget.ticket.messages);
    _showRating = widget.ticket.status == SupportTicketStatus.RESOLVED &&
        widget.ticket.customerRating == null;
  }

  @override
  void dispose() {
    _msgCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_msgCtrl.text.trim().isEmpty) return;
    setState(() {
      _messages.add(TicketMessageModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        ticketId: widget.ticket.id,
        senderId: 'u1',
        senderName: 'Bạn',
        message: _msgCtrl.text.trim(),
        isStaff: false,
        createdAt: DateTime.now(),
      ));
    });
    _msgCtrl.clear();
    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollCtrl.animateTo(_scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
    });
  }

  @override
  Widget build(BuildContext context) {
    final (statusColor, _) = _statusStyle(widget.ticket.status);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded,
                color: AppColors.textPrimary),
            onPressed: () => Navigator.pop(context)),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.ticket.ticketNumber,
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                    letterSpacing: 0.5)),
            Text(widget.ticket.status.label,
                style: TextStyle(fontSize: 11, color: statusColor)),
          ],
        ),
      ),
      body: Column(
        children: [
          // ── Subject banner ──
          Container(
            color: AppColors.white,
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${widget.ticket.category.icon} ${widget.ticket.subject}',
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary)),
                if (widget.ticket.bookingCode != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text('Booking: ${widget.ticket.bookingCode}',
                        style: const TextStyle(
                            fontSize: 11, color: AppColors.textSecondary)),
                  ),
              ],
            ),
          ),

          // ── Star rating if just resolved ──
          if (_showRating)
            Container(
              color: AppColors.warning.withOpacity(0.06),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Column(
                children: [
                  const Text('Ticket đã giải quyết! Hãy đánh giá trải nghiệm của bạn:',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                        5,
                        (i) => GestureDetector(
                              onTap: () => setState(() => _selectedRating = i + 1),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4),
                                child: Icon(
                                  i < _selectedRating
                                      ? Icons.star_rounded
                                      : Icons.star_border_rounded,
                                  size: 32,
                                  color: AppColors.warning,
                                ),
                              ),
                            )),
                  ),
                  const SizedBox(height: 8),
                  if (_selectedRating > 0)
                    ElevatedButton(
                      onPressed: () {
                        setState(() => _showRating = false);
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text('✅ Cảm ơn đánh giá của bạn!'),
                            backgroundColor: AppColors.primaryLightBrand));
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.warning,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 8)),
                      child: const Text('Gửi đánh giá',
                          style: TextStyle(
                              color: AppColors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.bold)),
                    ),
                ],
              ),
            ),

          // ── Messages ──
          Expanded(
            child: ListView.builder(
              controller: _scrollCtrl,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (ctx, i) => MessageBubble(message: _messages[i]),
            ),
          ),

          // ── Input bar (if active) ──
          if (widget.ticket.status.isActive)
            Container(
              color: AppColors.white,
              padding: EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 10,
                  bottom: MediaQuery.of(context).padding.bottom + 10),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _msgCtrl,
                      maxLines: null,
                      decoration: InputDecoration(
                        hintText: 'Nhập tin nhắn...',
                        hintStyle:
                            const TextStyle(color: AppColors.textHint, fontSize: 14),
                        filled: true,
                        fillColor: AppColors.mutedLight,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(22),
                            borderSide: BorderSide.none),
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: _sendMessage,
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: const BoxDecoration(
                          color: AppColors.primaryLightBrand, shape: BoxShape.circle),
                      child: const Icon(Icons.send_rounded,
                          color: AppColors.white, size: 20),
                    ),
                  ),
                ],
              ),
            ),
        ],
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
}
