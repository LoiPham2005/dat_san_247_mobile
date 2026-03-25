import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/features/customer/support/data/models/support_models.dart';
import '../widgets/ticket_card.dart';
import 'support_ticket_detail_page.dart';
import 'create_ticket_page.dart';

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
        title: const Text('Hỗ trợ',
            style: TextStyle(
                fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
        actions: [
          TextButton.icon(
            onPressed: () => _showCreateTicket(context),
            icon: const Icon(Icons.add_rounded, color: AppColors.primaryLightBrand, size: 18),
            label: const Text('Tạo ticket',
                style: TextStyle(
                    color: AppColors.primaryLightBrand, fontSize: 13, fontWeight: FontWeight.bold)),
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
        children: [_buildList(_activeTickets), _buildList(_closedTickets)],
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
            const Text('Không có ticket nào',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            const Text('Nhấn "Tạo ticket" để được hỗ trợ',
                style: TextStyle(color: AppColors.textHint, fontSize: 13)),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: tickets.length,
      itemBuilder: (ctx, i) => TicketCard(
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
