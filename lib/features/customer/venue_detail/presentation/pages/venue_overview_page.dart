import 'package:dat_san_247_mobile/core/base/state/bloc/base_state.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/features/customer/booking/data/models/time_slot_model.dart' as booking;
import 'package:dat_san_247_mobile/features/customer/venue_detail/data/models/venue_overview_model.dart';
import 'package:dat_san_247_mobile/features/customer/venue_detail/presentation/cubit/venue_overview_cubit.dart';
import 'package:dat_san_247_mobile/routes/constants/route_names.dart';
import 'package:dat_san_247_mobile/features/shared/widgets/app_date_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class VenueOverviewPage extends StatelessWidget {
  final String slugOrId;

  const VenueOverviewPage({super.key, required this.slugOrId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.I<VenueOverviewCubit>()..init(slugOrId),
      child: VenueOverviewView(slugOrId: slugOrId),
    );
  }
}

class VenueOverviewView extends StatelessWidget {
  final String slugOrId;
  const VenueOverviewView({super.key, required this.slugOrId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Lịch Trống Bao Quát', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          Builder(builder: (context) {
            return IconButton(
              icon: const Icon(Icons.calendar_month),
              onPressed: () async {
                final cubit = context.read<VenueOverviewCubit>();
                final selected = await AppDatePicker.show(
                  context: context,
                  initialDate: cubit.selectedDate,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 30)),
                  title: 'Chọn ngày xem lịch',
                );
                if (selected != null) {
                  cubit.fetchSchedule(slugOrId, selected);
                }
              },
            );
          }),
        ],
      ),
      body: Column(
        children: [
          _buildDateSelector(context),
          _buildLegend(),
          Expanded(
            child: _buildGrid(context),
          ),
          _buildBottomBar(context),
        ],
      ),
    );
  }

  Widget _buildDateSelector(BuildContext context) {
    return BlocBuilder<VenueOverviewCubit, BaseState<VenueOverviewModel>>(
      builder: (context, state) {
        final cubit = context.read<VenueOverviewCubit>();
        final today = DateTime.now();
        final dates = List.generate(14, (i) => today.add(Duration(days: i)));

        return Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            children: [
              SizedBox(
                height: 80,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemBuilder: (context, index) {
                    final date = dates[index];
                    final isSelected = DateFormat('yyyyMMdd').format(date) ==
                        DateFormat('yyyyMMdd').format(cubit.selectedDate);

                    return GestureDetector(
                      onTap: () => cubit.fetchSchedule(slugOrId, date),
                      child: Container(
                        width: 80,
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primaryLightBrand : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: isSelected ? AppColors.primaryLightBrand : AppColors.borderLight),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              DateFormat('E').format(date),
                              style: TextStyle(
                                fontSize: 12,
                                color: isSelected ? Colors.white : Colors.grey,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              DateFormat('dd/MM').format(date),
                              style: TextStyle(
                                fontSize: 16,
                                color: isSelected ? Colors.white : Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => const SizedBox(width: 8),
                  itemCount: dates.length,
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 14, color: AppColors.primaryLightBrand),
                    const SizedBox(width: 8),
                    Text(
                      DateFormat('EEEE, dd/MM/yyyy', 'vi_VN').format(cubit.selectedDate),
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textPrimary),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLegend() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _legendItem('Trống', Colors.white, borderColor: AppColors.borderLight),
          const SizedBox(width: 16),
          _legendItem('Đã đặt', const Color(0xFFFECDD3), borderColor: const Color(0xFFFDA4AF)),
          const SizedBox(width: 16),
          _legendItem('Đang chọn', AppColors.primaryLightBrand),
        ],
      ),
    );
  }

  Widget _legendItem(String label, Color color, {Color? borderColor}) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
            border: borderColor != null ? Border.all(color: borderColor) : null,
          ),
        ),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
      ],
    );
  }

  Widget _buildGrid(BuildContext context) {
    return BlocBuilder<VenueOverviewCubit, BaseState<VenueOverviewModel>>(
      builder: (context, state) {
        return state.whenReady(
          loading: (data) => const Center(child: CircularProgressIndicator()),
          failure: (error, data) => Center(child: Text(error)),
          success: (model, message) {
            if (model.courts.isEmpty) {
              return const Center(child: Text('Không có sân nào.'));
            }

            final allSlots = model.courts
                .expand((c) => c.slots.map((s) => s.startTime))
                .toSet()
                .toList()
              ..sort();

            return RefreshIndicator(
              onRefresh: () => context.read<VenueOverviewCubit>().fetchSchedule(slugOrId, context.read<VenueOverviewCubit>().selectedDate),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- LEFT FIXED COLUMN (COURT NAMES) ---
                  Column(
                    children: [
                      // Fixed Top-Left Corner
                      Container(
                        width: 100,
                        height: 40,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColors.primaryLightBrand.withOpacity(0.08),
                          border: Border(
                            right: BorderSide(color: AppColors.borderLight.withOpacity(0.5), width: 0.5),
                            bottom: BorderSide(color: AppColors.borderLight, width: 0.5),
                          ),
                        ),
                        child: const Text('SÂN \\ GIỜ', 
                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: AppColors.textPrimary)),
                      ),
                      // Court Names List
                      ...model.courts.map((court) => Container(
                        width: 100,
                        height: 50,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                          color: AppColors.mutedLight,
                          border: Border(
                            bottom: BorderSide(color: AppColors.borderLight.withOpacity(0.2), width: 0.5),
                            right: BorderSide(color: AppColors.borderLight.withOpacity(0.5), width: 0.5),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(court.name, 
                              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 11, color: AppColors.textPrimary),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const Text('Bóng đá', style: TextStyle(fontSize: 8, color: AppColors.textSecondary, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      )),
                    ],
                  ),
                  
                  // --- RIGHT SCROLLABLE GRID (TIME SLOTS) ---
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Time Markers Header
                          Container(
                            color: AppColors.primaryLightBrand.withOpacity(0.08),
                            height: 40,
                            child: Row(
                              children: [
                                ...allSlots.map((time) => SizedBox(
                                      width: 50,
                                      child: Stack(
                                        clipBehavior: Clip.none,
                                        children: [
                                          Positioned(
                                            left: -0.5,
                                            top: 25,
                                            child: Container(width: 1, height: 15, color: AppColors.primaryLightBrand.withOpacity(0.5)),
                                          ),
                                          Positioned(
                                            left: -25,
                                            top: 5,
                                            child: SizedBox(
                                              width: 50,
                                              child: Text(
                                                time,
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                  color: AppColors.textSecondary,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )),
                              ],
                            ),
                          ),
                          // Slots Grid
                          ...model.courts.map((court) => Row(
                            children: allSlots.map((time) {
                              final slot = court.slots.firstWhere((s) => s.startTime == time, 
                                orElse: () => TimeSlotModel(startTime: time, endTime: '', isAvailable: false));
                              return GestureDetector(
                                onTap: slot.isAvailable ? () => context.read<VenueOverviewCubit>().toggleSlot(court.id, time) : null,
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: !slot.isAvailable ? const Color(0xFFFFF1F2) : (slot.isSelected ? AppColors.primaryLightBrand : Colors.white),
                                    border: Border(
                                      bottom: BorderSide(color: AppColors.borderLight, width: 0.8),
                                      right: BorderSide(color: AppColors.borderLight, width: 0.8),
                                    ),
                                  ),
                                  child: slot.isSelected 
                                      ? const Icon(Icons.check_circle, color: Colors.white, size: 16) 
                                      : !slot.isAvailable 
                                          ? Container(
                                              margin: const EdgeInsets.all(4),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFFFECDD3).withOpacity(0.4),
                                                borderRadius: BorderRadius.circular(4),
                                                border: Border.all(color: const Color(0xFFFDA4AF).withOpacity(0.6)),
                                              ),
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(4),
                                                child: CustomPaint(
                                                  painter: StripedPainter(),
                                                ),
                                              ),
                                            )
                                          : null,
                                ),
                              );
                            }).toList(),
                          )),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
          },
        );
      },
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return BlocBuilder<VenueOverviewCubit, BaseState<VenueOverviewModel>>(
      builder: (context, state) {
        final listSelected = state.data?.courts.expand((c) => c.slots.where((s) => s.isSelected)).toList() ?? [];
        if (listSelected.isEmpty) return const SizedBox.shrink();

        final totalDuration = listSelected.length * 30; // 30 min per slot
        final totalPrice = listSelected.fold(0.0, (sum, slot) => sum + slot.price);

        return Container(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).padding.bottom + 20,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 24,
                offset: const Offset(0, -8),
              ),
            ],
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 4,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.access_time_filled_rounded, size: 14, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          '${listSelected.length} Ca ($totalDuration phút)',
                          style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${NumberFormat('#,###', 'vi_VN').format(totalPrice)} đ',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: AppColors.primaryLightBrand,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 5,
                child: ElevatedButton(
                  onPressed: () {
                    final model = state.data!;
                    final selectedSlotsMap = <String, List<booking.TimeSlotModel>>{};

                    for (var court in model.courts) {
                      final selectedInCourt = court.slots.where((s) => s.isSelected).toList();
                      if (selectedInCourt.isNotEmpty) {
                        selectedSlotsMap[court.id] = selectedInCourt
                            .map((s) => booking.TimeSlotModel(
                                  startTime: s.startTime,
                                  endTime: s.endTime,
                                  price: s.price,
                                  status: booking.TimeSlotStatus.AVAILABLE,
                                ))
                            .toList();
                      }
                    }

                    if (selectedSlotsMap.isEmpty) return;

                    final firstCourtId = selectedSlotsMap.keys.first;
                    final firstCourtName = model.courts.firstWhere((c) => c.id == firstCourtId).name;

                    context.push(RouteNames.bookingConfirm, extra: {
                      'courtId': firstCourtId,
                      'courtName': firstCourtName,
                      'venueId': model.venueId,
                      'venueName': model.venueName,
                      'venueAddress': model.venueAddress,
                      'bookingDate': DateFormat('yyyy-MM-dd').format(context.read<VenueOverviewCubit>().selectedDate),
                      'selectedSlots': selectedSlotsMap[firstCourtId],
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryLightBrand,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    elevation: 8,
                    shadowColor: AppColors.primaryLightBrand.withOpacity(0.4),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Tiếp tục', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward_ios_rounded, size: 14),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class StripedPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFE11D48).withOpacity(0.15)
      ..strokeWidth = 2;
    
    const double spacing = 6;
    for (double i = -size.height; i < size.width; i += spacing) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i + size.height, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
