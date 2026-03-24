import 'package:flutter/material.dart';
import 'package:dat_san_247_mobile/core/common/constants/app_constants.dart';
import 'package:dat_san_247_mobile/core/base/di/injection.dart';
import 'package:dat_san_247_mobile/design/l10n/cubit/locale_cubit.dart';
import 'package:dat_san_247_mobile/core/services/app_auth/app_auth_cubit.dart';
import 'package:dat_san_247_mobile/design/theme/app_theme.dart';
import 'package:dat_san_247_mobile/design/theme/cubit/theme_cubit.dart';
import 'package:dat_san_247_mobile/gen/l10n/app_localizations.dart';
import 'package:dat_san_247_mobile/routes/config/app_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

/// 🏠 Root Widget của ứng dụng
///
/// File này đặt ở `lib/app.dart` vì:
/// - App là root, không phải feature
/// - Dễ tìm, dễ maintain
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, __) => _AppContent(),
    );
  }
}

/// 🎨 Nội dung chính của App (tách ra để code gọn hơn)
class _AppContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<LocaleCubit>()),
        BlocProvider(create: (_) => getIt<ThemeCubit>()),
        BlocProvider(create: (_) => getIt<AppAuthCubit>()),
      ],
      child: Builder(
        builder: (context) {
          final locale = context.select((LocaleCubit c) => c.state);
          final themeState = context.select((ThemeCubit c) => c.state);

          return MaterialApp.router(
            // App Info
            title: AppConstants.appName,
            debugShowCheckedModeBanner: false,

            // Theme
            theme: AppTheme.light(themeState),
            darkTheme: AppTheme.dark(themeState),
            themeMode: themeState.materialThemeMode,

            // Localization
            locale: locale,
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,

            // Navigation
            routerConfig: getIt<AppRouter>().router,
            builder: (context, child) {
              ErrorWidget.builder = (details) {
                final location = _extractLocation(details);
                return _AppErrorScreen(details: details, location: location);
              };
              return FlutterSmartDialog.init()(context, child);
            },
          );
        },
      ),
    );
  }

  String? _extractLocation(FlutterErrorDetails details) {
    try {
      final msg = details.toString();
      final match = RegExp(r'(?:package:[a-z0-9_]+/|lib/)([^)\s]+\.dart:\d+:\d+)').firstMatch(msg);
      if (match != null) return 'lib/${match.group(1)}';

      if (details.stack != null) {
        final stack = details.stack.toString();
        for (final line in stack.split('\n')) {
          if (line.contains('package:dat_san_247_mobile') || line.contains('lib/')) {
            final m = RegExp(r'(?:package:[a-z0-9_]+/|lib/)([^)\s]+\.dart:\d+:\d+)').firstMatch(line);
            if (m != null) return 'lib/${m.group(1)}';
          }
        }
      }
    } catch (_) {}
    return null;
  }
}

class _AppErrorScreen extends StatelessWidget {
  final FlutterErrorDetails details;
  final String? location;

  const _AppErrorScreen({required this.details, this.location});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFF9FAFB),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.red.shade200, width: 1.5),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(11)),
                      ),
                      child: const Center(
                        child: Text(
                          '❌ FLUTTER ERROR',
                          style: TextStyle(color: Color(0xFFB91C1C), fontWeight: FontWeight.w900, fontSize: 13),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Framework caught an error:',
                              style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          Text(
                            details.exception.toString(),
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1F2937)),
                          ),
                          if (location != null) ...[
                            const SizedBox(height: 16),
                            const Divider(height: 1),
                            const SizedBox(height: 12),
                            const Text('Location:',
                                style: TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Text(
                              location!,
                              style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF0369A1),
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'monospace'),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: const Text('Thử lại / Quay về'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF374151),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
