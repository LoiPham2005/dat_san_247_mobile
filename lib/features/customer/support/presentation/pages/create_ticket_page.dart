import 'package:flutter/material.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/features/customer/support/data/models/support_models.dart';

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
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded,
                color: AppColors.textPrimary),
            onPressed: () => Navigator.pop(context)),
        title: const Text('Tạo ticket hỗ trợ',
            style: TextStyle(
                fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _SectionLabel('Loại vấn đề'),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: SupportTicketCategory.values.map((cat) {
                final sel = _selectedCategory == cat;
                return GestureDetector(
                  onTap: () => setState(() => _selectedCategory = cat),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: sel ? AppColors.primaryLightBrand : AppColors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: sel
                              ? AppColors.primaryLightBrand
                              : AppColors.borderLight),
                    ),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      Text(cat.icon, style: const TextStyle(fontSize: 14)),
                      const SizedBox(width: 6),
                      Text(cat.label,
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: sel ? AppColors.white : AppColors.textSecondary)),
                    ]),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            const _SectionLabel('Tiêu đề *'),
            const SizedBox(height: 8),
            _InputField(
                controller: _subjectCtrl,
                hint: 'Mô tả ngắn gọn vấn đề...',
                maxLines: 1),
            const SizedBox(height: 16),
            const _SectionLabel('Mô tả chi tiết *'),
            const SizedBox(height: 8),
            _InputField(
                controller: _descCtrl,
                hint: 'Vui lòng mô tả chi tiết vấn đề bạn gặp phải...',
                maxLines: 5),
            const SizedBox(height: 16),
            const _SectionLabel('Mã booking (nếu có)'),
            const SizedBox(height: 8),
            _InputField(
                controller: _bookingCodeCtrl, hint: 'VD: DS24701234', maxLines: 1),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_subjectCtrl.text.isEmpty || _descCtrl.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Vui lòng điền đầy đủ thông tin'),
                        backgroundColor: AppColors.error));
                    return;
                  }
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('✅ Ticket đã được tạo! Chúng tôi sẽ phản hồi sớm.'),
                      backgroundColor: AppColors.primaryLightBrand));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryLightBrand,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Gửi yêu cầu hỗ trợ',
                    style: TextStyle(
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);
  @override
  Widget build(BuildContext context) => Text(text,
      style: const TextStyle(
          fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textSecondary));
}

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final int maxLines;
  const _InputField(
      {required this.controller, required this.hint, required this.maxLines});

  @override
  Widget build(BuildContext context) => TextField(
        controller: controller,
        maxLines: maxLines,
        style: const TextStyle(fontSize: 14),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: AppColors.textHint, fontSize: 13),
          filled: true,
          fillColor: AppColors.white,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.borderLight)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.borderLight)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                  color: AppColors.primaryLightBrand, width: 1.5)),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        ),
      );
}
