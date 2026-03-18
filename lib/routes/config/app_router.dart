// ════════════════════════════════════════════════════════════════
// 📁 3. App Router (Main Router Config)
// ════════════════════════════════════════════════════════════════

import 'package:dat_san_247_mobile/core/services/app_auth/app_auth_cubit.dart';
import 'package:dat_san_247_mobile/core/services/manager/navigation_service.dart';
import 'package:dat_san_247_mobile/features/customer/booking/data/models/my_booking_models.dart';
import 'package:dat_san_247_mobile/features/customer/booking/presentation/pages/booking_confirm_page.dart';
import 'package:dat_san_247_mobile/features/customer/booking/presentation/pages/booking_detail_page.dart';
import 'package:dat_san_247_mobile/features/customer/booking/presentation/pages/booking_success_page.dart';
import 'package:dat_san_247_mobile/features/customer/booking/presentation/pages/cancel_booking_page.dart';
import 'package:dat_san_247_mobile/features/customer/booking/presentation/pages/payment_page.dart';
import 'package:dat_san_247_mobile/features/customer/booking/presentation/pages/time_slot_picker_page.dart';
import 'package:dat_san_247_mobile/features/customer/booking/presentation/pages/write_review_page.dart';
import 'package:dat_san_247_mobile/features/customer/favorite/presentation/pages/favorite_venues_page.dart';
import 'package:dat_san_247_mobile/features/customer/invoice/presentation/pages/invoice_list_page.dart';
import 'package:dat_san_247_mobile/features/customer/main/presentation/pages/main_shell_page.dart';
import 'package:dat_san_247_mobile/features/customer/notification/presentation/pages/notifications_page.dart';
import 'package:dat_san_247_mobile/features/customer/promotions/presentation/pages/promotions_page.dart';
import 'package:dat_san_247_mobile/features/customer/recurring_booking/presentation/pages/recurring_booking_page.dart';
import 'package:dat_san_247_mobile/features/customer/support/presentation/pages/support_ticket_list_page.dart';
import 'package:dat_san_247_mobile/features/customer/profile/presentation/pages/profile_settings_page.dart';
import 'package:dat_san_247_mobile/features/owner/dashboard/presentation/pages/owner_shell_page.dart';
import 'package:dat_san_247_mobile/features/venue_staff/presentation/pages/venue_staff_shell_page.dart';
import 'package:dat_san_247_mobile/features/customer/venue_detail/presentation/pages/venue_detail_page.dart';
import 'package:dat_san_247_mobile/features/customer/waitlist/presentation/pages/my_waitlist_page.dart';
import 'package:dat_san_247_mobile/features/customer/wallet/presentation/pages/wallet_page.dart';
import 'package:dat_san_247_mobile/routes/base/app_routes_observer.dart';
import 'package:dat_san_247_mobile/routes/base/go_router_refresh_stream.dart';
import 'package:dat_san_247_mobile/routes/config/app_routes.dart';
import 'package:dat_san_247_mobile/routes/constants/route_names.dart';
import 'package:dat_san_247_mobile/routes/guards/route_guards.dart';
import 'package:dat_san_247_mobile/routes/pages/not_found_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class AppRouter {
  final AppAuthCubit appAuthCubit;
  final RouteGuards routeGuards;
  final NavigationService navigationService;
  final AppRoutesObserver appRoutesObserver;

  AppRouter(
    this.appAuthCubit,
    this.routeGuards,
    this.navigationService,
    this.appRoutesObserver,
  );

  late final GoRouter router = GoRouter(
    initialLocation: RouteNames.splash,
    navigatorKey: navigationService.navigatorKey,
    debugLogDiagnostics: kDebugMode,
    restorationScopeId: 'app_router',

    // Auto-refresh when auth state changes
    refreshListenable: GoRouterRefreshStream(appAuthCubit.stream),

    // Global redirect (auth guard)
    redirect: routeGuards.authGuard,

    observers: [appRoutesObserver, FlutterSmartDialog.observer],

    routes: [
      // ── Generated routes (splash, login, register, home standalone, venue-search, venues) ──
      ...$appRoutes,

      // ── /main: Bottom nav shell ──────────────────────────────────────────
      GoRoute(
        path: RouteNames.main,
        builder: (context, state) => const MainShellPage(),
      ),

      // ── /venue-detail/:id (dynamic segment) ─────────────────────────────
      GoRoute(
        path: '/venue-detail/:slugOrId',
        builder: (context, state) {
          final id = state.pathParameters['slugOrId'] ?? '';
          return VenueDetailPage(slugOrId: id);
        },
      ),

      // ── /time-slot-picker (query params) ────────────────────────────────
      GoRoute(
        path: '/time-slot-picker',
        builder: (context, state) {
          final courtId = state.uri.queryParameters['courtId'] ?? '';
          final venueName = Uri.decodeComponent(
            state.uri.queryParameters['venueName'] ?? '',
          );
          return TimeSlotPickerPage(courtId: courtId, venueName: venueName);
        },
      ),

      // ── C-06: Xác nhận đặt sân (extra: Map) ─────────────────────────────
      GoRoute(
        path: RouteNames.bookingConfirm,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          return BookingConfirmPage(
            courtId: extra['courtId'] ?? '',
            courtName: extra['courtName'] ?? '',
            venueId: extra['venueId'] ?? '',
            venueName: extra['venueName'] ?? '',
            venueAddress: extra['venueAddress'] ?? '',
            bookingDate: extra['bookingDate'] ?? '',
            selectedSlots: extra['selectedSlots'] ?? [],
          );
        },
      ),

      // ── C-07: Thanh toán (extra: Map) ────────────────────────────────────
      GoRoute(
        path: RouteNames.payment,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          return PaymentPage(
            venueName: extra['venueName'] ?? '',
            courtName: extra['courtName'] ?? '',
            bookingDate: extra['bookingDate'] ?? '',
            startTime: extra['startTime'] ?? '',
            endTime: extra['endTime'] ?? '',
            totalAmount: (extra['totalAmount'] as num?)?.toDouble() ?? 0,
            paymentMethod: extra['paymentMethod'] ?? 'MOMO',
          );
        },
      ),

      // ── C-08: Đặt sân thành công (extra: Map) ────────────────────────────
      GoRoute(
        path: RouteNames.bookingSuccess,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          return BookingSuccessPage(
            bookingCode: extra['bookingCode'] ?? '',
            checkInCode: extra['checkInCode'] ?? '',
            venueName: extra['venueName'] ?? '',
            courtName: extra['courtName'] ?? '',
            bookingDate: extra['bookingDate'] ?? '',
            startTime: extra['startTime'] ?? '',
            endTime: extra['endTime'] ?? '',
            totalAmount: (extra['totalAmount'] as num?)?.toDouble() ?? 0,
          );
        },
      ),
      // ── C-09 Danh sách booking ──
      GoRoute(
        path: '/booking-detail',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          final booking = BookingListItemModel(
            id: extra['id'] ?? '',
            bookingCode: extra['bookingCode'] ?? '',
            checkInCode: extra['checkInCode'],
            venueName: extra['venueName'] ?? '',
            courtName: extra['courtName'] ?? '',
            venueAddress: extra['venueAddress'] ?? '',
            venueThumbnailUrl: extra['venueThumbnailUrl'],
            bookingDate: extra['bookingDate'] != null
                ? DateTime.parse(extra['bookingDate'])
                : DateTime.now(),
            startTime: extra['startTime'] ?? '',
            endTime: extra['endTime'] ?? '',
            status: BookingStatus.values.firstWhere(
              (e) => e.name == extra['status'],
              orElse: () => BookingStatus.PENDING,
            ),
            paymentStatus: PaymentStatus.values.firstWhere(
              (e) => e.name == extra['paymentStatus'],
              orElse: () => PaymentStatus.PENDING,
            ),
            totalAmount: (extra['totalAmount'] as num?)?.toDouble() ?? 0,
            cancellationDeadline: extra['cancellationDeadline'] != null
                ? DateTime.parse(extra['cancellationDeadline'])
                : null,
            createdAt:
                extra['createdAt'] != null ? DateTime.parse(extra['createdAt']) : DateTime.now(),
          );
          return BookingDetailPage(booking: booking);
        },
      ),

      // ── C-11 Hủy booking ──
      GoRoute(
        path: '/cancel-booking',
        builder: (context, state) {
          final detail = state.extra as BookingDetailModel;
          return CancelBookingPage(booking: detail);
        },
      ),

      // ── C-12 Viết đánh giá ──
      GoRoute(
        path: '/write-review',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          return WriteReviewPage(
            bookingId: extra['bookingId'] ?? '',
            venueName: extra['venueName'] ?? '',
          );
        },
      ),

      // ── C-13 Lịch định kỳ ──
      GoRoute(
        path: '/recurring-bookings',
        builder: (context, state) => const RecurringBookingPage(),
      ),

      // ── C-14 Waitlist ──
      GoRoute(
        path: '/my-waitlist',
        builder: (context, state) => const MyWaitlistPage(),
      ),

      // ── C-15 Ví điện tử ──
      GoRoute(
        path: '/wallet',
        builder: (context, state) => const WalletPage(),
      ),

      // ── C-16 Hóa đơn ──
      GoRoute(
        path: '/invoices',
        builder: (context, state) => const InvoiceListPage(),
      ),

      // ── C-17 Khuyến mãi & Voucher ──
      GoRoute(
        path: '/promotions',
        builder: (context, state) => const PromotionsPage(),
      ),

      // ── C-18 Sân yêu thích ──
      GoRoute(
        path: '/favorite-venues',
        builder: (context, state) => const FavoriteVenuesPage(),
      ),

      // ── C-19 Thông báo ──
      GoRoute(
        path: '/notifications',
        builder: (context, state) => const NotificationsPage(),
      ),

      // ── C-20 Hỗ trợ ──
      GoRoute(
        path: '/support-tickets',
        builder: (context, state) => const SupportTicketListPage(),
      ),

      // ── C-22 Hồ sơ & Cài đặt ──
      GoRoute(
        path: '/profile-settings',
        builder: (context, state) => const ProfileSettingsPage(),
      ),

      // ── Owner Shell ──
      GoRoute(
        path: '/owner',
        builder: (context, state) => const OwnerShellPage(),
      ),

      // ── Venue Staff Shell ──
      GoRoute(
        path: '/venue-staff',
        builder: (context, state) => const VenueStaffShellPage(),
      ),
    ],

    // 404
    errorBuilder: (context, state) => NotFoundPage(error: state.error),
  );
}
