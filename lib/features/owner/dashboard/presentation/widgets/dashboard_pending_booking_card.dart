import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';

class DashboardPendingBookingCard extends StatelessWidget {
  final Map<String, dynamic> booking;
  final VoidCallback onAccept;
  final VoidCallback onReject;
  const DashboardPendingBookingCard(
      {super.key, required this.booking, required this.onAccept, required this.onReject});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.warning.withOpacity(0.3)),
        boxShadow: [BoxShadow(color: AppColors.black.withOpacity(0.04), blurRadius: 8)],
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: AppColors.warning.withOpacity(0.15),
                child: Text(booking['customer'][0],
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: AppColors.warning, fontSize: 14)),
              ),
              const SizedBox(width: 10),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(booking['customer'],
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                  Text(booking['phone'] ?? '',
                      style: const TextStyle(fontSize: 11, color: AppColors.textHint)),
                ],
              )),
              Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Text(booking['code'],
                    style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textHint,
                        letterSpacing: 0.5)),
                Text(booking['ago'],
                    style: const TextStyle(fontSize: 10, color: AppColors.textHint)),
              ]),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: const Color(0xFFF4F6FA), borderRadius: BorderRadius.circular(10)),
            child: Row(
              children: [
                Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    const Icon(Icons.sports_soccer_rounded, size: 14, color: Color(0xFF1565C0)),
                    const SizedBox(width: 4),
                    Text(booking['court'],
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1565C0))),
                  ]),
                  const SizedBox(height: 4),
                  Row(children: [
                    const Icon(Icons.event_rounded, size: 12, color: AppColors.textHint),
                    const SizedBox(width: 4),
                    Text('${booking['date']} · ${booking['time']}',
                        style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                  ]),
                ])),
                Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  Text(_fmtAmount(booking['amount']),
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: AppColors.primaryLightBrand)),
                  _PayMethodChip(method: booking['method']),
                ]),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Row(children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  HapticFeedback.mediumImpact();
                  onReject();
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.error),
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('Từ chối',
                    style: TextStyle(
                        color: AppColors.error, fontWeight: FontWeight.bold, fontSize: 13)),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: () {
                  HapticFeedback.mediumImpact();
                  onAccept();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.success,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('Xác nhận',
                    style: TextStyle(
                        color: AppColors.white, fontWeight: FontWeight.bold, fontSize: 13)),
              ),
            ),
          ]),
        ],
      ),
    );
  }

  String _fmtAmount(double v) {
    final n = v.toInt();
    final String s = n.toString();
    final result = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) result.write('.');
      result.write(s[i]);
    }
    return '${result.toString()}đ';
  }
}

class _PayMethodChip extends StatelessWidget {
  final String method;
  const _PayMethodChip({required this.method});

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (method) {
      'WALLET' => ('Ví', AppColors.info),
      'MOMO' => ('MoMo', const Color(0xFFAD1457)),
      'VNPAY' => ('VNPay', AppColors.error),
      'ZALOPAY' => ('ZaloPay', AppColors.info),
      'CASH' => ('Tiền mặt', AppColors.success),
      _ => ('Bank', AppColors.textHint),
    };
    return Container(
      margin: const EdgeInsets.only(top: 4),
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration:
          BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
      child: Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: color)),
    );
  }
}
