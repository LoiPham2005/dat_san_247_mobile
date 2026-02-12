import 'package:flutter/material.dart';

class CustomerInfoForm extends StatefulWidget {
  final Function({String? name, String? phone, String? email, String? customerNotes}) onInfoChanged;

  const CustomerInfoForm({
    super.key,
    required this.onInfoChanged,
  });

  @override
  State<CustomerInfoForm> createState() => _CustomerInfoFormState();
}

class _CustomerInfoFormState extends State<CustomerInfoForm> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _setupListeners();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _setupListeners() {
    _nameController.addListener(() {
      widget.onInfoChanged(name: _nameController.text);
    });
    _phoneController.addListener(() {
      widget.onInfoChanged(phone: _phoneController.text);
    });
    _emailController.addListener(() {
      widget.onInfoChanged(email: _emailController.text);
    });
    _notesController.addListener(() {
      widget.onInfoChanged(customerNotes: _notesController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.blue[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.person,
                  color: Colors.blue[600],
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                "Thông tin liên hệ",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3748),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Name field (required)
          _buildTextField(
            controller: _nameController,
            label: "Họ và tên",
            hint: "Nhập họ và tên của bạn",
            icon: Icons.person_outline,
            required: true,
          ),
          
          const SizedBox(height: 16),
          
          // Phone field (required)
          _buildTextField(
            controller: _phoneController,
            label: "Số điện thoại",
            hint: "Nhập số điện thoại",
            icon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
            required: true,
          ),
          
          const SizedBox(height: 16),
          
          // Email field (optional)
          _buildTextField(
            controller: _emailController,
            label: "Email",
            hint: "Nhập email (không bắt buộc)",
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
          ),
          
          const SizedBox(height: 16),
          
          // Notes field (optional)
          _buildTextField(
            controller: _notesController,
            label: "Ghi chú",
            hint: "Thông tin thêm về đặt sân (không bắt buộc)",
            icon: Icons.note_outlined,
            maxLines: 3,
          ),
          
          const SizedBox(height: 16),
          
          // Info note
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue[200]!),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: Colors.blue[600],
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Chúng tôi sẽ liên hệ để xác nhận đặt sân trong 30 phút.',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.blue[700],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
    bool required = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            if (required) ...[
              const SizedBox(width: 4),
              Text(
                '*',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.red[600],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: Colors.grey[400],
              fontSize: 14,
            ),
            prefixIcon: Icon(
              icon,
              color: Colors.grey[500],
              size: 20,
            ),
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[200]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[200]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: maxLines > 1 ? 16 : 12,
            ),
          ),
        ),
      ],
    );
  }
}