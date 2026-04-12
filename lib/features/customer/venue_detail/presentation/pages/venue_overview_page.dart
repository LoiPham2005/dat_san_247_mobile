import 'package:dat_san_247_mobile/core/base/state/bloc/base_state.dart';
import 'package:dat_san_247_mobile/core/common/utils/logger.dart';

import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/features/customer/booking/data/models/time_slot_model.dart'
    as booking;
import 'package:dat_san_247_mobile/features/customer/recurring_booking/data/repositories/recurring_booking_repository.dart';
import 'package:dat_san_247_mobile/features/customer/venue_detail/data/models/venue_overview_model.dart';
import 'package:dat_san_247_mobile/features/customer/venue_detail/presentation/cubit/venue_overview_cubit.dart';
import 'package:dat_san_247_mobile/routes/constants/route_names.dart';
import 'package:dat_san_247_mobile/features/shared/widgets/app_date_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:dat_san_247_mobile/core/services/manager/toast_service.dart';


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
        title: const Text('Lịch Trống Bao Quát',
            style: TextStyle(fontWeight: FontWeight.bold)),
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
                  await cubit.fetchSchedule(slugOrId, selected);
                }
              },
            );
          }),
        ],
      ),
      body: BlocBuilder<VenueOverviewCubit, BaseState<VenueOverviewModel>>(
        builder: (context, state) {
          final model = state.data;
          final isRecurringMode =
              model?.bookingMode == VenueBookingMode.recurring;

          return Column(
            children: [
              _buildDateSelector(context),
              _buildLegend(),
              _buildActionHeader(context),
              if (isRecurringMode) _buildRecurringInfo(context, model!),
              Expanded(
                child: _buildGrid(context),
              ),
              _buildBottomBar(context),
            ],
          );
        },
      ),
    );
  }

  Widget _buildRecurringInfo(BuildContext context, VenueOverviewModel model) {
    final config = model.recurringConfig!;
    final daysStr = config.repeatType == 'DAILY'
        ? 'hằng ngày'
        : 'thứ ${config.days.map((d) => _getDayLabel(d)).join(', ')}';

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.repeat_on_rounded,
                  size: 16, color: Colors.orange),
              const SizedBox(width: 8),
              const Text('CHẾ ĐỘ ĐẶT CỐ ĐỊNH ĐANG BẬT',
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      color: Colors.orange)),
              const Spacer(),
              GestureDetector(
                onTap: () => context
                    .read<VenueOverviewCubit>()
                    .setBookingMode(VenueBookingMode.regular),
                child: const Text('Hủy',
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.red)),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Lặp lại $daysStr${config.endDate != null ? ' đến hết ngày ${DateFormat('dd/MM/yyyy').format(config.endDate!)}' : ''}. Hãy chọn các ca trên lịch.',
            style: TextStyle(
                fontSize: 11,
                color: Colors.orange.shade900,
                fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  String _getDayLabel(int day) {
    switch (day) {
      case 0:
        return 'CN';
      case 1:
        return 'T2';
      case 2:
        return 'T3';
      case 3:
        return 'T4';
      case 4:
        return 'T5';
      case 5:
        return 'T6';
      case 6:
        return 'T7';
      default:
        return '';
    }
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
                          color: isSelected
                              ? AppColors.primaryLightBrand
                              : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                              color: isSelected
                                  ? AppColors.primaryLightBrand
                                  : AppColors.borderLight),
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
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 8),
                  itemCount: dates.length,
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today,
                        size: 14, color: AppColors.primaryLightBrand),
                    const SizedBox(width: 8),
                    Text(
                      DateFormat('EEEE, dd/MM/yyyy', 'vi_VN')
                          .format(cubit.selectedDate),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: AppColors.textPrimary),
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
          _legendItem('Trống', Colors.white,
              borderColor: AppColors.borderLight),
          const SizedBox(width: 16),
          _legendItem('Đã đặt', const Color(0xFFFECDD3),
              borderColor: const Color(0xFFFDA4AF)),
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
        Text(label,
            style: const TextStyle(
                fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
      ],
    );
  }

  Widget _buildActionHeader(BuildContext context) {
    return BlocBuilder<VenueOverviewCubit, BaseState<VenueOverviewModel>>(
      builder: (context, state) {
        final mode = state.data?.bookingMode ?? VenueBookingMode.regular;

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              _modeButton(
                context,
                label: 'ĐẶT LẺ',
                icon: Icons.calendar_today_rounded,
                isActive: mode == VenueBookingMode.regular,
                onTap: () => context
                    .read<VenueOverviewCubit>()
                    .setBookingMode(VenueBookingMode.regular),
              ),
              const SizedBox(width: 12),
              _modeButton(
                context,
                label: 'ĐẶT CỐ ĐỊNH',
                icon: Icons.repeat_rounded,
                isActive: mode == VenueBookingMode.recurring,
                onTap: () async {
                  if (mode == VenueBookingMode.recurring) return;
                  final config =
                      await _showRecurringSheet(context, state.data!.venueId);
                  if (config != null) {
                    if (context.mounted) {
                      context.read<VenueOverviewCubit>().setBookingMode(
                          VenueBookingMode.recurring,
                          config: config);
                    }
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _modeButton(BuildContext context,
      {required String label,
      required IconData icon,
      required bool isActive,
      required VoidCallback onTap}) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isActive ? AppColors.primaryLightBrand : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color: isActive
                    ? AppColors.primaryLightBrand
                    : AppColors.borderLight),
            boxShadow: isActive
                ? [
                    BoxShadow(
                        color:
                            AppColors.primaryLightBrand.withValues(alpha: 0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 4))
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon,
                  size: 16,
                  color: isActive ? Colors.white : AppColors.textSecondary),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    color: isActive ? Colors.white : AppColors.textSecondary),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<RecurringBookingConfig?> _showRecurringSheet(
      BuildContext context, String venueId) {
    return showModalBottomSheet<RecurringBookingConfig>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => _RecurringBookingSheet(
        venueId: venueId,
        initialDate: context.read<VenueOverviewCubit>().selectedDate,
      ),
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
              onRefresh: () => context.read<VenueOverviewCubit>().fetchSchedule(
                  slugOrId, context.read<VenueOverviewCubit>().selectedDate),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- LEFT FIXED COLUMN (COURT NAMES) ---
                    Column(
                      children: [
                        Container(
                          width: 100,
                          height: 40,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: AppColors.primaryLightBrand
                                .withValues(alpha: 0.08),
                            border: Border(
                              right: BorderSide(
                                  color: AppColors.borderLight
                                      .withValues(alpha: 0.5),
                                  width: 0.5),
                              bottom: const BorderSide(
                                  color: AppColors.borderLight, width: 0.5),
                            ),
                          ),
                          child: const Text('SÂN \\ GIỜ',
                              style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary)),
                        ),
                        ...model.courts.map((court) => Container(
                              width: 100,
                              height: 50,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              alignment: Alignment.centerLeft,
                              decoration: BoxDecoration(
                                color: AppColors.mutedLight,
                                border: Border(
                                  bottom: BorderSide(
                                      color: AppColors.borderLight
                                          .withValues(alpha: 0.2),
                                      width: 0.5),
                                  right: BorderSide(
                                      color: AppColors.borderLight
                                          .withValues(alpha: 0.5),
                                      width: 0.5),
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(court.name,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 11,
                                          color: AppColors.textPrimary),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis),
                                  const Text('Bóng đá',
                                      style: TextStyle(
                                          fontSize: 8,
                                          color: AppColors.textSecondary)),
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
                            Container(
                              height: 40,
                              color: AppColors.primaryLightBrand
                                  .withValues(alpha: 0.08),
                              child: Row(
                                children: allSlots
                                    .map((time) => SizedBox(
                                          width: 50,
                                          child: Stack(
                                            clipBehavior: Clip.none,
                                            children: [
                                              Positioned(
                                                left: -0.5,
                                                top: 25,
                                                child: Container(
                                                    width: 1,
                                                    height: 15,
                                                    color: AppColors
                                                        .primaryLightBrand
                                                        .withValues(
                                                            alpha: 0.5)),
                                              ),
                                              Positioned(
                                                left: -25,
                                                top: 5,
                                                child: SizedBox(
                                                  width: 50,
                                                  child: Text(time,
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: const TextStyle(
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: AppColors
                                                              .textSecondary)),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ))
                                    .toList(),
                              ),
                            ),
                            ...model.courts.map((court) => Row(
                                  children: allSlots.map((time) {
                                    final slot = court.slots.firstWhere(
                                        (s) => s.startTime == time,
                                        orElse: () => TimeSlotModel(
                                            startTime: time,
                                            endTime: '',
                                            isAvailable: false));
                                    return GestureDetector(
                                      onTap: slot.isAvailable
                                          ? () => context
                                              .read<VenueOverviewCubit>()
                                              .toggleSlot(court.id, time)
                                          : null,
                                      child: Container(
                                        width: 50,
                                        height: 50,
                                        decoration: const BoxDecoration(
                                          border: Border(
                                            bottom: BorderSide(
                                                color: AppColors.borderLight,
                                                width: 0.5),
                                            right: BorderSide(
                                                color: AppColors.borderLight,
                                                width: 0.5),
                                          ),
                                        ),
                                        child: Container(
                                          margin: const EdgeInsets.all(1),
                                          color: !slot.isAvailable
                                              ? const Color(0xFFFFF1F2)
                                              : (slot.isSelected
                                                  ? AppColors.primaryLightBrand
                                                  : Colors.white),
                                          child: slot.isSelected
                                              ? const Icon(Icons.check_rounded,
                                                  color: Colors.white, size: 14)
                                              : !slot.isAvailable
                                                  ? CustomPaint(
                                                      painter: StripedPainter())
                                                  : null,
                                        ),
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
        final listSelected = state.data?.courts
                .expand((c) => c.slots.where((s) => s.isSelected))
                .toList() ??
            [];
        if (listSelected.isEmpty) return const SizedBox.shrink();

        final totalDuration = listSelected.length * 30; // 30 min per slot
        final totalPrice =
            listSelected.fold(0.0, (sum, slot) => sum + slot.price);
        final isRecurringMode =
            state.data?.bookingMode == VenueBookingMode.recurring;

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
                color: Colors.black.withValues(alpha: 0.08),
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
                    Text(
                      '${listSelected.length} Ca ($totalDuration phút)',
                      style: const TextStyle(
                          fontSize: 11,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${NumberFormat('#,###', 'vi_VN').format(totalPrice)} đ',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: AppColors.primaryLightBrand,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 6,
                child: ElevatedButton(
                  onPressed: () async {
                    final model = state.data!;
                    if (isRecurringMode) {
                      Logger.info('Continue button clicked (RECURRING mode)');
                      await _handleRecurringSubmit(context, model);
                      return;
                    }

                    // Original Regular Booking Logic
                    final selectedSlotsMap =
                        <String, List<booking.TimeSlotModel>>{};
                    for (var court in model.courts) {
                      final selectedInCourt =
                          court.slots.where((s) => s.isSelected).toList();
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
                    final firstCourtName = model.courts
                        .firstWhere((c) => c.id == firstCourtId)
                        .name;

                    await context.push(RouteNames.bookingConfirm, extra: {
                      'courtId': firstCourtId,
                      'courtName': firstCourtName,
                      'venueId': model.venueId,
                      'venueName': model.venueName,
                      'venueAddress': model.venueAddress,
                      'bookingDate': DateFormat('yyyy-MM-dd').format(
                          context.read<VenueOverviewCubit>().selectedDate),
                      'selectedSlots': selectedSlotsMap[firstCourtId],
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryLightBrand,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    elevation: 8,
                    shadowColor:
                        AppColors.primaryLightBrand.withValues(alpha: 0.4),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(isRecurringMode ? 'Đặt sân cố định' : 'Tiếp tục',
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w900)),
                      const SizedBox(width: 4),
                      const Icon(Icons.arrow_forward_ios_rounded, size: 12),
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

  Future<void> _handleRecurringSubmit(
      BuildContext context, VenueOverviewModel model) async {
    final listSelected =
        model.courts.expand((c) => c.slots.where((s) => s.isSelected)).toList();
    
    Logger.info('Handle Recurring Submit: ${listSelected.length} total slots selected');
    
    if (listSelected.isEmpty) {
      Logger.warning('Handle Recurring Submit: No slots selected, returning.');
      return;
    }

    Logger.info('Showing confirmation dialog...');
    // Show confirmation
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Xác nhận đặt cố định'),
        content: Text(
            'Bạn đang thực hiện đăng ký cố định cho ${listSelected.length} ca đã chọn. Tiếp tục?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Hủy')),
          TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Đồng ý')),
        ],
      ),
    );

    if (confirmed != true) {
      Logger.info('Recurring booking confirmation cancelled/dismissed ($confirmed)');
      return;
    }

    // Show loading using ToastService (Non-blocking)
    toast.loading('Đang xử lý yêu cầu...');

    final repo = GetIt.I<RecurringBookingRepository>();
    final config = model.recurringConfig!;
    final startDateStr = DateFormat('yyyy-MM-dd')
        .format(context.read<VenueOverviewCubit>().selectedDate);

    int successCount = 0;
    int failCount = 0;

    Logger.info('Confirmed recurring booking for ${listSelected.length} slots. Starting requests...');

    try {
      for (var court in model.courts) {
        final selectedInCourt = court.slots.where((s) => s.isSelected).toList()
          ..sort((a, b) => a.startTime.compareTo(b.startTime));

        if (selectedInCourt.isEmpty) continue;

        // Merge contiguous slots for better user experience and fewer API calls
        final mergedSlots = _mergeTimeSlots(selectedInCourt);
        Logger.info('Court ${court.name}: ${selectedInCourt.length} slots merged into ${mergedSlots.length} requests');

        for (var slot in mergedSlots) {
          Logger.info('Sending recurring request: ${court.name} | ${slot.startTime} - ${slot.endTime}');
          final result = await repo.createRecurringBooking(
            venueId: model.venueId,
            courtId: court.id,
            startTime: slot.startTime,
            endTime: slot.endTime,
            repeatType: config.repeatType,
            days: config.days,
            startDate: startDateStr,
            endDate: config.endDate != null
                ? DateFormat('yyyy-MM-dd').format(config.endDate!)
                : null,
          );

          result.fold(
            onSuccess: (data) => successCount++,
            onFailure: (f) => failCount++,
          );
        }
      }
    } catch (e) {
      toast.error('Có lỗi xảy ra trong quá trình xử lý: $e');
    } finally {
      toast.stopLoading();
    }

    if (!context.mounted) return;

    if (successCount > 0) {
      context
          .read<VenueOverviewCubit>()
          .setBookingMode(VenueBookingMode.regular);
      
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Đăng ký thành công'),
          content: Text(
              'Đã gửi yêu cầu cho $successCount dải giờ. Chủ sân sẽ duyệt sớm cho bạn.${failCount > 0 ? '\n(Có $failCount yêu cầu bị lỗi)' : ''}'),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(ctx), child: const Text('Đóng')),
          ],
        ),
      );
    } else if (failCount > 0) {
      toast.error('Đăng ký không thành công. Vui lòng kiểm tra lại.');
    }
  }

  /// Helper to merge contiguous time slots
  List<TimeSlotModel> _mergeTimeSlots(List<TimeSlotModel> slots) {
    if (slots.isEmpty) return [];
    
    final List<TimeSlotModel> merged = [];
    TimeSlotModel? current;

    for (var slot in slots) {
      if (current == null) {
        current = slot;
      } else {
        // Check if contiguous (end of current == start of next)
        if (current.endTime == slot.startTime) {
          current = current.copyWith(endTime: slot.endTime);
        } else {
          merged.add(current);
          current = slot;
        }
      }
    }
    if (current != null) merged.add(current);
    
    return merged;
  }
}

class _RecurringBookingSheet extends StatefulWidget {
  final String venueId;
  final DateTime initialDate;

  const _RecurringBookingSheet({
    required this.venueId,
    required this.initialDate,
  });

  @override
  State<_RecurringBookingSheet> createState() => _RecurringBookingSheetState();
}

class _RecurringBookingSheetState extends State<_RecurringBookingSheet> {
  String _repeatType = 'WEEKLY';
  final List<int> _selectedDays = [];
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _selectedDays.add(widget.initialDate.weekday % 7);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 32,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Cấu hình Đặt cố định',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text(
            'Sau khi cấu hình, hãy quay lại và chọn các ca bạn muốn đặt cố định trên lịch.',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
          ),
          const SizedBox(height: 24),

          // Repeat Type
          const Text('Tần suất lặp',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Row(
            children: [
              _ChoiceChip(
                label: 'Hằng tuần',
                selected: _repeatType == 'WEEKLY',
                onTap: () => setState(() => _repeatType = 'WEEKLY'),
              ),
              const SizedBox(width: 12),
              _ChoiceChip(
                label: 'Hằng ngày',
                selected: _repeatType == 'DAILY',
                onTap: () => setState(() => _repeatType = 'DAILY'),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Days Selector
          if (_repeatType == 'WEEKLY') ...[
            const Text('Lặp lại vào các ngày',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: List.generate(7, (i) {
                final dayNum = (i + 1) % 7;
                final label = _getDayLabel(dayNum);
                final isSelected = _selectedDays.contains(dayNum);
                return _DayChip(
                  label: label,
                  selected: isSelected,
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        if (_selectedDays.length > 1) {
                          _selectedDays.remove(dayNum);
                        }
                      } else {
                        _selectedDays.add(dayNum);
                      }
                    });
                  },
                );
              }),
            ),
            const SizedBox(height: 24),
          ],

          // End Date
          const Text('Ngày kết thúc (Tùy chọn)',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () async {
              final selected = await showDatePicker(
                context: context,
                initialDate: widget.initialDate.add(const Duration(days: 30)),
                firstDate: widget.initialDate.add(const Duration(days: 7)),
                lastDate: widget.initialDate.add(const Duration(days: 365)),
              );
              if (selected != null) setState(() => _endDate = selected);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: AppColors.mutedLight,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.borderLight),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_month,
                      color: AppColors.primaryLightBrand, size: 20),
                  const SizedBox(width: 12),
                  Text(
                    _endDate == null
                        ? 'Chọn ngày kết thúc lịch định kỳ'
                        : DateFormat('dd/MM/yyyy').format(_endDate!),
                    style: TextStyle(
                      color: _endDate == null
                          ? AppColors.textHint
                          : AppColors.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                final config = RecurringBookingConfig(
                  repeatType: _repeatType,
                  days: _repeatType == 'WEEKLY' ? _selectedDays : [],
                  endDate: _endDate,
                );
                Navigator.pop(context, config);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryLightBrand,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
              ),
              child: const Text('Bật chế độ đặt cố định',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  String _getDayLabel(int day) {
    switch (day) {
      case 0:
        return 'CN';
      case 1:
        return 'T2';
      case 2:
        return 'T3';
      case 3:
        return 'T4';
      case 4:
        return 'T5';
      case 5:
        return 'T6';
      case 6:
        return 'T7';
      default:
        return '';
    }
  }
}

class _ChoiceChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _ChoiceChip(
      {required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryLightBrand : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: selected
                  ? AppColors.primaryLightBrand
                  : AppColors.borderLight),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : AppColors.textSecondary,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

class _DayChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _DayChip(
      {required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryLightBrand : Colors.white,
          shape: BoxShape.circle,
          border: Border.all(
              color: selected
                  ? AppColors.primaryLightBrand
                  : AppColors.borderLight),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : AppColors.textSecondary,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}

class StripedPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFE11D48).withValues(alpha: 0.15)
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
