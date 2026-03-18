import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/features/customer/support/data/models/support_models.dart';

// ──────────────────────────────────────────────────────────────────────────
// C-20: Hỗ Trợ — Danh Sách Ticket
// ──────────────────────────────────────────────────────────────────────────
class SupportTicketListPage extends StatefulWidget {
  const SupportTicketListPage({super.key});

  @override
  State<SupportTicketListPage> createState() => _SupportTicketListPageState();
}

class _SupportTicketListPageState extends State<SupportTicketListPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<SupportTicketModel> _tickets = [
    SupportTicketModel(
      id: 't1', ticketNumber: 'TK-001234', customerId: 'u1',
      category: SupportTicketCategory.PAYMENT_ISSUE,
      priority: SupportTicketPriority.HIGH,
      status: SupportTicketStatus.IN_PROGRESS,
      subject: 'Thanh toán bị trừ tiền nhưng booking không xác nhận',
      description: 'Tôi vừa thanh toán 300K cho booking DS24799001 nhưng tiền đã bị trừ mà booking vẫn ở trạng thái PENDING.',
      bookingId: 'b2', bookingCode: 'DS24799001',
      firstResponseAt: DateTime.now().subtract(const Duration(hours: 2)),
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      updatedAt: DateTime.now().subtract(const Duration(hours: 2)),
      messages: [
        TicketMessageModel(id: 'm1', ticketId: 't1', senderId: 'u1', senderName: 'Bạn', message: 'Tôi vừa thanh toán 300K cho booking DS24799001 nhưng tiền đã bị trừ mà booking vẫn ở trạng thái PENDING.', isStaff: false, createdAt: DateTime.now().subtract(const Duration(hours: 5))),
        TicketMessageModel(id: 'm2', ticketId: 't1', senderId: 's1', senderName: 'Hỗ trợ DatSan247', message: 'Chào bạn! Chúng tôi đã nhận được yêu cầu của bạn. Đội ngũ đang kiểm tra giao dịch và sẽ phản hồi trong vòng 30 phút.', isStaff: true, createdAt: DateTime.now().subtract(const Duration(hours: 2))),
      ],
    ),
    SupportTicketModel(
      id: 't2', ticketNumber: 'TK-000987', customerId: 'u1',
      category: SupportTicketCategory.BOOKING_ISSUE,
      priority: SupportTicketPriority.MEDIUM,
      status: SupportTicketStatus.RESOLVED,
      subject: 'Không thể check-in bằng QR code',
      description: 'Mã QR của tôi không được quét tại sân K34.',
      bookingId: 'b1', bookingCode: 'DS24701234',
      resolution: 'Đã hỗ trợ nhân viên reset QR code. Booking đã check-in thành công.',
      resolvedAt: DateTime.now().subtract(const Duration(days: 3)),
      customerRating: 5,
      createdAt: DateTime.now().subtract(const Duration(days: 4)),
      updatedAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
    SupportTicketModel(
      id: 't3', ticketNumber: 'TK-000456', customerId: 'u1',
      category: SupportTicketCategory.REFUND_REQUEST,
      priority: SupportTicketPriority.MEDIUM,
      status: SupportTicketStatus.OPEN,
      subject: 'Yêu cầu hoàn tiền booking bị hủy',
      description: 'Booking DS24788002 đã hủy nhưng chưa thấy tiền hoàn về ví.',
      bookingId: 'b3', bookingCode: 'DS24788002',
      createdAt: DateTime.now().subtract(const Duration(hours: 12)),
      updatedAt: DateTime.now().subtract(const Duration(hours: 12)),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<SupportTicketModel> get _activeTickets =>
      _tickets.where((t) => t.status.isActive).toList();
  List<SupportTicketModel> get _closedTickets =>
      _tickets.where((t) => !t.status.isActive).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: const Text('Hỗ trợ', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
        actions: [
          TextButton.icon(
            onPressed: () => _showCreateTicket(context),
            icon: const Icon(Icons.add_rounded, color: AppColors.primaryLightBrand, size: 18),
            label: const Text('Tạo ticket', style: TextStyle(color: AppColors.primaryLightBrand, fontSize: 13, fontWeight: FontWeight.bold)),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(44),
          child: TabBar(
            controller: _tabController,
            labelColor: AppColors.primaryLightBrand,
            unselectedLabelColor: AppColors.textHint,
            indicatorColor: AppColors.primaryLightBrand,
            labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
            tabs: [
              Tab(text: 'Đang xử lý (${_activeTickets.length})'),
              Tab(text: 'Đã đóng (${_closedTickets.length})'),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildList(_activeTickets),
          _buildList(_closedTickets),
        ],
      ),
    );
  }

  Widget _buildList(List<SupportTicketModel> tickets) {
    if (tickets.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.support_agent_rounded, size: 64, color: AppColors.primaryLightBrand),
            const SizedBox(height: 12),
            const Text('Không có ticket nào', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            const Text('Nhấn "Tạo ticket" để được hỗ trợ', style: TextStyle(color: AppColors.textHint, fontSize: 13)),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: tickets.length,
      itemBuilder: (ctx, i) => _TicketCard(
        ticket: tickets[i],
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => SupportTicketDetailPage(ticket: tickets[i])),
        ),
      ),
    );
  }

  void _showCreateTicket(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const CreateTicketPage()));
  }
}

// ──────────────────────────────────────────────────────────────────────────
// TicketCard
// ──────────────────────────────────────────────────────────────────────────
class _TicketCard extends StatelessWidget {
  final SupportTicketModel ticket;
  final VoidCallback onTap;
  const _TicketCard({required this.ticket, required this.onTap});

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
          color: AppColors.white, borderRadius: BorderRadius.circular(14),
          boxShadow: [BoxShadow(color: AppColors.black.withOpacity(0.04), blurRadius: 8)],
          border: ticket.status == SupportTicketStatus.OPEN
              ? Border.all(color: AppColors.warning.withOpacity(0.3)) : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(ticket.category.icon, style: const TextStyle(fontSize: 18)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(ticket.subject, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textPrimary), maxLines: 2, overflow: TextOverflow.ellipsis),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                  decoration: BoxDecoration(color: statusBg, borderRadius: BorderRadius.circular(20)),
                  child: Text(ticket.status.label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: statusColor)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(ticket.ticketNumber, style: const TextStyle(fontSize: 11, color: AppColors.textHint, fontWeight: FontWeight.w600, letterSpacing: 0.5)),
                const SizedBox(width: 8),
                Container(width: 4, height: 4, decoration: const BoxDecoration(color: AppColors.borderLight, shape: BoxShape.circle)),
                const SizedBox(width: 8),
                Text(ticket.category.label, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(color: priorityColor.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                  child: Text(ticket.priority.label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: priorityColor)),
                ),
              ],
            ),
            if (ticket.bookingCode != null) ...[
              const SizedBox(height: 6),
              Row(children: [
                const Icon(Icons.confirmation_number_outlined, size: 12, color: AppColors.textHint),
                const SizedBox(width: 4),
                Text('Booking: ${ticket.bookingCode}', style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
              ]),
            ],
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(children: [
                  const Icon(Icons.chat_bubble_outline_rounded, size: 12, color: AppColors.textHint),
                  const SizedBox(width: 4),
                  Text('${ticket.messages.length} tin nhắn', style: const TextStyle(fontSize: 11, color: AppColors.textHint)),
                ]),
                Text(_timeAgo(ticket.updatedAt), style: const TextStyle(fontSize: 11, color: AppColors.textHint)),
              ],
            ),
            if (ticket.customerRating != null) ...[
              const SizedBox(height: 6),
              Row(children: List.generate(5, (i) => Icon(
                i < ticket.customerRating! ? Icons.star_rounded : Icons.star_border_rounded,
                size: 14, color: AppColors.warning,
              ))),
            ],
          ],
        ),
      ),
    );
  }

  (Color, Color) _statusStyle(SupportTicketStatus s) {
    switch (s) {
      case SupportTicketStatus.OPEN: return (AppColors.warning, AppColors.warning.withOpacity(0.12));
      case SupportTicketStatus.IN_PROGRESS: return (AppColors.info, AppColors.info.withOpacity(0.1));
      case SupportTicketStatus.RESOLVED: return (AppColors.success, AppColors.success.withOpacity(0.1));
      case SupportTicketStatus.CLOSED: return (AppColors.textHint, AppColors.mutedLight);
      case SupportTicketStatus.REOPENED: return (AppColors.error, AppColors.error.withOpacity(0.08));
    }
  }

  (String, Color) _priorityStyle(SupportTicketPriority p) {
    switch (p) {
      case SupportTicketPriority.LOW: return ('Thấp', AppColors.textHint);
      case SupportTicketPriority.MEDIUM: return ('Trung bình', AppColors.warning);
      case SupportTicketPriority.HIGH: return ('Cao', AppColors.error);
      case SupportTicketPriority.URGENT: return ('Khẩn cấp', const Color(0xFF9C27B0));
    }
  }

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes} phút trước';
    if (diff.inHours < 24) return '${diff.inHours} giờ trước';
    return '${diff.inDays} ngày trước';
  }
}

// ──────────────────────────────────────────────────────────────────────────
// Ticket Detail Page (chat-style)
// ──────────────────────────────────────────────────────────────────────────
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
    _showRating = widget.ticket.status == SupportTicketStatus.RESOLVED && widget.ticket.customerRating == null;
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
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary), onPressed: () => Navigator.pop(context)),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.ticket.ticketNumber, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary, letterSpacing: 0.5)),
            Text(widget.ticket.status.label, style: TextStyle(fontSize: 11, color: statusColor)),
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
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                if (widget.ticket.bookingCode != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text('Booking: ${widget.ticket.bookingCode}', style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
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
                  const Text('Ticket đã giải quyết! Hãy đánh giá trải nghiệm của bạn:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (i) => GestureDetector(
                      onTap: () => setState(() => _selectedRating = i + 1),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Icon(
                          i < _selectedRating ? Icons.star_rounded : Icons.star_border_rounded,
                          size: 32, color: AppColors.warning,
                        ),
                      ),
                    )),
                  ),
                  const SizedBox(height: 8),
                  if (_selectedRating > 0) ElevatedButton(
                    onPressed: () { setState(() => _showRating = false); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('✅ Cảm ơn đánh giá của bạn!'), backgroundColor: AppColors.primaryLightBrand)); },
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.warning, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8)),
                    child: const Text('Gửi đánh giá', style: TextStyle(color: AppColors.white, fontSize: 13, fontWeight: FontWeight.bold)),
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
              itemBuilder: (ctx, i) => _MessageBubble(message: _messages[i]),
            ),
          ),

          // ── Input bar (if active) ──
          if (widget.ticket.status.isActive)
            Container(
              color: AppColors.white,
              padding: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: MediaQuery.of(context).padding.bottom + 10),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _msgCtrl,
                      maxLines: null,
                      decoration: InputDecoration(
                        hintText: 'Nhập tin nhắn...',
                        hintStyle: const TextStyle(color: AppColors.textHint, fontSize: 14),
                        filled: true, fillColor: AppColors.mutedLight,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(22), borderSide: BorderSide.none),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: _sendMessage,
                    child: Container(
                      width: 44, height: 44,
                      decoration: const BoxDecoration(color: AppColors.primaryLightBrand, shape: BoxShape.circle),
                      child: const Icon(Icons.send_rounded, color: AppColors.white, size: 20),
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
      case SupportTicketStatus.OPEN: return (AppColors.warning, AppColors.warning.withOpacity(0.12));
      case SupportTicketStatus.IN_PROGRESS: return (AppColors.info, AppColors.info.withOpacity(0.1));
      case SupportTicketStatus.RESOLVED: return (AppColors.success, AppColors.success.withOpacity(0.1));
      case SupportTicketStatus.CLOSED: return (AppColors.textHint, AppColors.mutedLight);
      case SupportTicketStatus.REOPENED: return (AppColors.error, AppColors.error.withOpacity(0.08));
    }
  }
}

// ──────────────────────────────────────────────────────────────────────────
// Message Bubble
// ──────────────────────────────────────────────────────────────────────────
class _MessageBubble extends StatelessWidget {
  final TicketMessageModel message;
  const _MessageBubble({required this.message});

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
              child: const Icon(Icons.support_agent_rounded, size: 18, color: AppColors.primaryLightBrand),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                if (!isMe)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 3, left: 2),
                    child: Text(message.senderName, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textHint)),
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
                    boxShadow: [BoxShadow(color: AppColors.black.withOpacity(0.05), blurRadius: 4)],
                  ),
                  child: Text(
                    message.message,
                    style: TextStyle(fontSize: 13, color: isMe ? AppColors.white : AppColors.textPrimary, height: 1.4),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 3, left: 2, right: 2),
                  child: Text(DateFormat('HH:mm').format(message.createdAt), style: const TextStyle(fontSize: 10, color: AppColors.textHint)),
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

// ──────────────────────────────────────────────────────────────────────────
// Create Ticket Page
// ──────────────────────────────────────────────────────────────────────────
class CreateTicketPage extends StatefulWidget {
  const CreateTicketPage({super.key});

  @override
  State<CreateTicketPage> createState() => _CreateTicketPageState();
}

class _CreateTicketPageState extends State<CreateTicketPage> {
  SupportTicketCategory _selectedCategory = SupportTicketCategory.OTHER;
  final _subjectCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _bookingCodeCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: AppBar(
        backgroundColor: AppColors.white, elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary), onPressed: () => Navigator.pop(context)),
        title: const Text('Tạo ticket hỗ trợ', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _SectionLabel('Loại vấn đề'),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8, runSpacing: 8,
              children: SupportTicketCategory.values.map((cat) {
                final sel = _selectedCategory == cat;
                return GestureDetector(
                  onTap: () => setState(() => _selectedCategory = cat),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: sel ? AppColors.primaryLightBrand : AppColors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: sel ? AppColors.primaryLightBrand : AppColors.borderLight),
                    ),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      Text(cat.icon, style: const TextStyle(fontSize: 14)),
                      const SizedBox(width: 6),
                      Text(cat.label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: sel ? AppColors.white : AppColors.textSecondary)),
                    ]),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            const _SectionLabel('Tiêu đề *'),
            const SizedBox(height: 8),
            _InputField(controller: _subjectCtrl, hint: 'Mô tả ngắn gọn vấn đề...', maxLines: 1),
            const SizedBox(height: 16),
            const _SectionLabel('Mô tả chi tiết *'),
            const SizedBox(height: 8),
            _InputField(controller: _descCtrl, hint: 'Vui lòng mô tả chi tiết vấn đề bạn gặp phải...', maxLines: 5),
            const SizedBox(height: 16),
            const _SectionLabel('Mã booking (nếu có)'),
            const SizedBox(height: 8),
            _InputField(controller: _bookingCodeCtrl, hint: 'VD: DS24701234', maxLines: 1),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_subjectCtrl.text.isEmpty || _descCtrl.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Vui lòng điền đầy đủ thông tin'), backgroundColor: AppColors.error));
                    return;
                  }
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('✅ Ticket đã được tạo! Chúng tôi sẽ phản hồi sớm.'), backgroundColor: AppColors.primaryLightBrand));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryLightBrand, elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Gửi yêu cầu hỗ trợ', style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold, fontSize: 15)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Shared helpers ───────────────────────────────────────────────────────────
class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);
  @override
  Widget build(BuildContext context) => Text(text, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textSecondary));
}

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final int maxLines;
  const _InputField({required this.controller, required this.hint, required this.maxLines});

  @override
  Widget build(BuildContext context) => TextField(
    controller: controller,
    maxLines: maxLines,
    style: const TextStyle(fontSize: 14),
    decoration: InputDecoration(
      hintText: hint, hintStyle: const TextStyle(color: AppColors.textHint, fontSize: 13),
      filled: true, fillColor: AppColors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.borderLight)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.borderLight)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.primaryLightBrand, width: 1.5)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    ),
  );
}
