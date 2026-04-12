import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/core/base/state/bloc/base_state.dart';
import 'package:dat_san_247_mobile/features/customer/support/data/models/support_ticket_model.dart';
import 'package:dat_san_247_mobile/features/customer/support/presentation/cubit/support_cubit.dart';

class SupportTicketListPage extends StatelessWidget {
  const SupportTicketListPage({super.key});

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
        title: const Text('Hỗ trợ & Ticket',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
      ),
      body: BlocBuilder<SupportCubit, BaseState<List<SupportTicketModel>>>(
        builder: (context, state) {
          if (state.isLoading && state.data == null) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.isFailure) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: AppColors.error),
                  const SizedBox(height: 16),
                  Text(state.error ?? 'Đã có lỗi xảy ra'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.read<SupportCubit>().fetchMyTickets(),
                    child: const Text('Thử lại'),
                  ),
                ],
              ),
            );
          }

          final tickets = state.data ?? [];

          if (tickets.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.confirmation_number_outlined, size: 64, color: AppColors.textHint.withOpacity(0.3)),
                  const SizedBox(height: 16),
                  const Text('Bạn chưa có yêu cầu hỗ trợ nào', style: TextStyle(color: AppColors.textHint)),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => context.read<SupportCubit>().fetchMyTickets(),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: tickets.length,
              itemBuilder: (context, index) => _TicketCard(ticket: tickets[index]),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateTicketDialog(context),
        backgroundColor: AppColors.primaryLightBrand,
        icon: const Icon(Icons.add, color: AppColors.white),
        label: const Text('Tạo ticket', style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  void _showCreateTicketDialog(BuildContext context) {
    final subjectController = TextEditingController();
    final descriptionController = TextEditingController();
    SupportTicketCategory selectedCategory = SupportTicketCategory.OTHER;
    SupportTicketPriority selectedPriority = SupportTicketPriority.MEDIUM;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => BlocProvider.value(
        value: context.read<SupportCubit>(),
        child: StatefulBuilder(
          builder: (context, setState) => Container(
            decoration: const BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              left: 20,
              right: 20,
              top: 20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Tạo yêu cầu mới', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                TextField(
                  controller: subjectController,
                  decoration: InputDecoration(
                    labelText: 'Tiêu đề',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<SupportTicketCategory>(
                  value: selectedCategory,
                  decoration: InputDecoration(
                    labelText: 'Danh mục',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  items: SupportTicketCategory.values
                      .map((e) => DropdownMenuItem(value: e, child: Text(e.label)))
                      .toList(),
                  onChanged: (v) => setState(() => selectedCategory = v!),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: descriptionController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    labelText: 'Nội dung chi tiết',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryLightBrand,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () async {
                      if (subjectController.text.isEmpty || descriptionController.text.isEmpty) {
                        return;
                      }
                      final success = await context.read<SupportCubit>().createTicket({
                        'subject': subjectController.text,
                        'description': descriptionController.text,
                        'category': selectedCategory.name,
                        'priority': selectedPriority.name,
                      });
                      if (success) {
                        Navigator.pop(context);
                      }
                    },
                    child: const Text('Gửi yêu cầu', style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TicketCard extends StatelessWidget {
  final SupportTicketModel ticket;
  const _TicketCard({required this.ticket});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: AppColors.black.withOpacity(0.04), blurRadius: 8)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getStatusColor(ticket.status).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  ticket.status.label,
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: _getStatusColor(ticket.status)),
                ),
              ),
              Text(
                DateFormat('dd/MM/yyyy HH:mm').format(ticket.createdAt),
                style: const TextStyle(fontSize: 11, color: AppColors.textHint),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(ticket.subject, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text(ticket.description, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary), maxLines: 2, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.label_outline, size: 14, color: AppColors.textHint),
              const SizedBox(width: 4),
              Text(ticket.category.label, style: const TextStyle(fontSize: 12, color: AppColors.textHint)),
              const Spacer(),
              if (ticket.status == SupportTicketStatus.RESOLVED)
                const Icon(Icons.check_circle_outline, size: 16, color: AppColors.success),
            ],
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(SupportTicketStatus status) {
    return switch (status) {
      SupportTicketStatus.OPEN => Colors.blue,
      SupportTicketStatus.IN_PROGRESS => Colors.orange,
      SupportTicketStatus.RESOLVED => AppColors.success,
      SupportTicketStatus.CLOSED => AppColors.textHint,
    };
  }
}
