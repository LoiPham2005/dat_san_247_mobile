import 'package:flutter/material.dart';

class PaymentMethodSelector extends StatelessWidget {
  final String? selectedMethod;
  final Function(String) onMethodSelected;

  const PaymentMethodSelector({
    super.key, 
    this.selectedMethod,
    required this.onMethodSelected,
  });

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
                  color: Colors.indigo[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.payment,
                  color: Colors.indigo[600],
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                "Phương thức thanh toán",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3748),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          _buildPaymentOption(
            context,
            'cash',
            'Tiền mặt',
            'Thanh toán tại sân',
            Icons.money,
            selectedMethod == 'cash',
            onMethodSelected,
          ),
          const SizedBox(height: 12),
          
          _buildPaymentOption(
            context,
            'banking',
            'Chuyển khoản',
            'Chuyển khoản ngân hàng',
            Icons.account_balance,
            selectedMethod == 'banking', 
            onMethodSelected,
          ),
          const SizedBox(height: 12),
          
          _buildPaymentOption(
            context,
            'wallet',
            'Ví điện tử',
            'Momo, ZaloPay, VNPay...',
            Icons.account_balance_wallet,
            selectedMethod == 'wallet',
            onMethodSelected,
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentOption(
    BuildContext context,
    String value,
    String title,
    String subtitle,
    IconData icon,
    bool isSelected,
    Function(String) onSelected,
  ) {
    return InkWell(
      onTap: () => onSelected(value),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(context).primaryColor.withOpacity(0.1) : Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Theme.of(context).primaryColor : Colors.grey[200]!,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSelected ? Theme.of(context).primaryColor : Colors.grey[100],
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: isSelected ? Colors.white : Colors.grey[600],
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Theme.of(context).primaryColor : Colors.grey[800],
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: Theme.of(context).primaryColor,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }
}