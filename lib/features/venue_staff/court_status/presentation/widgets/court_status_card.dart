import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/features/venue_staff/dashboard/data/models/staff_dashboard_models.dart';

class CourtStatusCard extends StatelessWidget {
  final CourtStatusModel court;
  final bool isManager;
  final Color brand;
  final void Function(CourtStatusModel) onToggleMaintenance;

  const CourtStatusCard({
    super.key,
    required this.court,
    required this.isManager,
    required this.brand,
    required this.onToggleMaintenance,
  });

  @override
  Widget build(BuildContext context) {
    final status = court.statusNow;
    final (dotColor, bgColor, icon) = switch (status) {
      CourtStatusNow.available => (AppColors.success, AppColors.success.withOpacity(0.06), Icons.sports_soccer_rounded),
      CourtStatusNow.occupied => (brand, brand.withOpacity(0.06), Icons.people_rounded),
      CourtStatusNow.reserved => (AppColors.warning, AppColors.warning.withOpacity(0.06), Icons.event_rounded),
      CourtStatusNow.maintenance => (AppColors.error, AppColors.error.withOpacity(0.06), Icons.build_rounded),
      CourtStatusNow.inactive => (AppColors.textHint, AppColors.textHint.withOpacity(0.06), Icons.block_rounded),
    };

    return Container(
      margin: const EdgeInsets.fromLTRB(14, 10, 14, 0),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: dotColor.withOpacity(0.25)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // ── Court header ──
        Row(children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration:
                BoxDecoration(color: bgColor.withOpacity(0.2), borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, size: 20, color: dotColor),
          ),
          const SizedBox(width: 10),
          Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(court.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            Row(children: [
              Container(
                  width: 7,
                  height: 7,
                  margin: const EdgeInsets.only(right: 5),
                  decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle)),
              Text(status.label,
                  style:
                      TextStyle(fontSize: 11, color: dotColor, fontWeight: FontWeight.bold)),
            ]),
          ])),
          // Stats
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            _StatChip('${court.todayBookingCount} booking', Colors.grey),
            const SizedBox(height: 3),
            _StatChip('${court.todayCheckedInCount} check-in', AppColors.success),
          ]),
        ]),

        const Divider(height: 14, color: AppColors.borderLight),

        // ── Current / context info ──
        if (status == CourtStatusNow.occupied)
          _OccupiedInfo(court: court, brand: brand)
        else if (status == CourtStatusNow.maintenance)
          _MaintenanceInfo(m: court.activeMaintenance!)
        else if (status == CourtStatusNow.reserved)
          _ReservedInfo(court: court)
        else if (status == CourtStatusNow.available)
          _AvailableInfo(court: court),

        // ── Next booking ──
        if (status == CourtStatusNow.occupied && court.nextStartTime != null) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: AppColors.warning.withOpacity(0.08), borderRadius: BorderRadius.circular(8)),
            child: Row(children: [
              const Icon(Icons.schedule_rounded, size: 13, color: AppColors.warning),
              const SizedBox(width: 6),
              Text('Booking tiếp: ${court.nextStartTime} – ${court.nextCustomerName ?? ''}',
                  style: const TextStyle(
                      fontSize: 11, color: AppColors.warning, fontWeight: FontWeight.w600)),
            ]),
          ),
        ],

        // ── Actions (Manager only) ──
        if (isManager && status != CourtStatusNow.inactive) ...[
          const SizedBox(height: 10),
          Row(children: [
            if (status != CourtStatusNow.maintenance)
              Expanded(
                  child: OutlinedButton.icon(
                onPressed: () => onToggleMaintenance(court),
                icon: const Icon(Icons.build_rounded, size: 14),
                label: const Text('Bảo trì', style: TextStyle(fontSize: 12)),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.warning,
                  side: BorderSide(color: AppColors.warning.withOpacity(0.4)),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              )),
            if (status == CourtStatusNow.maintenance) ...[
              const Spacer(),
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.check_circle_rounded, size: 14),
                label: const Text('Kết thúc bảo trì', style: TextStyle(fontSize: 12)),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.success,
                  side: BorderSide(color: AppColors.success.withOpacity(0.4)),
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
          ]),
        ],
      ]),
    );
  }
}

class _OccupiedInfo extends StatelessWidget {
  final CourtStatusModel court;
  final Color brand;
  const _OccupiedInfo({required this.court, required this.brand});

  @override
  Widget build(BuildContext context) =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: brand.withOpacity(0.12),
            child: Text(court.currentCustomerName?[0] ?? '?',
                style: TextStyle(color: brand, fontWeight: FontWeight.bold, fontSize: 14)),
          ),
          const SizedBox(width: 10),
          Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(court.currentCustomerName ?? '',
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
            if (court.currentCustomerPhone != null)
              Text(court.currentCustomerPhone!,
                  style: const TextStyle(fontSize: 11, color: AppColors.textHint)),
          ])),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text('${court.currentStartTime} – ${court.currentEndTime}',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: brand)),
            if (court.currentBookingCode != null)
              Text(court.currentBookingCode!,
                  style: const TextStyle(
                      fontSize: 9, color: AppColors.textHint, fontFamily: 'monospace')),
          ]),
        ]),
      ]);
}

class _MaintenanceInfo extends StatelessWidget {
  final CourtMaintenanceModel m;
  const _MaintenanceInfo({required this.m});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: m.isEmergency ? AppColors.error.withOpacity(0.08) : AppColors.warning.withOpacity(0.08),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Icon(m.isEmergency ? Icons.warning_rounded : Icons.build_rounded,
                size: 14, color: m.isEmergency ? AppColors.error : AppColors.warning),
            const SizedBox(width: 6),
            Text(m.reason,
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: m.isEmergency ? AppColors.error : AppColors.textPrimary)),
            if (m.isEmergency) ...[
              const SizedBox(width: 6),
              Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                      color: AppColors.error.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10)),
                  child: const Text('KHẨN CẤP',
                      style:
                          TextStyle(fontSize: 9, color: AppColors.error, fontWeight: FontWeight.bold))),
            ],
          ]),
          const SizedBox(height: 4),
          Text('${DateFormat('HH:mm').format(m.startAt)} – ${DateFormat('HH:mm').format(m.endAt)}',
              style: const TextStyle(fontSize: 11, color: AppColors.textHint)),
        ]),
      );
}

class _ReservedInfo extends StatelessWidget {
  final CourtStatusModel court;
  const _ReservedInfo({required this.court});

  @override
  Widget build(BuildContext context) => Row(children: [
        const Icon(Icons.event_rounded, size: 14, color: AppColors.warning),
        const SizedBox(width: 8),
        Text('Đặt từ ${court.nextStartTime}',
            style: const TextStyle(
                fontSize: 12, color: AppColors.warning, fontWeight: FontWeight.bold)),
        if (court.nextCustomerName != null) ...[
          const Text(' – ', style: TextStyle(fontSize: 12, color: AppColors.textHint)),
          Text(court.nextCustomerName!,
              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
        ],
      ]);
}

class _AvailableInfo extends StatelessWidget {
  final CourtStatusModel court;
  const _AvailableInfo({required this.court});

  @override
  Widget build(BuildContext context) => Row(children: [
        const Icon(Icons.check_circle_rounded, size: 14, color: AppColors.success),
        const SizedBox(width: 8),
        const Text('Sân đang trống — sẵn sàng đón khách',
            style: TextStyle(fontSize: 12, color: AppColors.success, fontWeight: FontWeight.w600)),
      ]);
}

class _StatChip extends StatelessWidget {
  final String label;
  final Color color;
  const _StatChip(this.label, this.color);

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration:
            BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
        child: Text(label, style: TextStyle(fontSize: 9, color: color, fontWeight: FontWeight.bold)),
      );
}
