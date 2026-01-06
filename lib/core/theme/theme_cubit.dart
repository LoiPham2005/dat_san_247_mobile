// ========================================
// 📁 lib/core/theme/theme_cubit.dart
// ========================================
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../storage/storage_service.dart';
import 'app_theme.dart';
import 'theme_state.dart';

@injectable
@lazySingleton
class ThemeCubit extends Cubit<ThemeState> {
  final StorageService _storageService;

  ThemeCubit(this._storageService) : super(const ThemeState());

  // ✅ Getters
  bool get isDarkMode => state.isDark;
  ThemeColorType get currentColor => state.colorType;
  AppThemeMode get currentMode => state.themeMode;

  // ✅ Init theme từ storage
  Future<void> initTheme() async {
    try {
      // Load color type
      final savedColor = _storageService.getThemeColor();
      final colorType = savedColor != null
          ? _parseThemeColor(savedColor)
          : ThemeColorType.green;

      // Load theme mode
      final savedMode = _storageService.getThemeMode();
      final themeMode = savedMode != null
          ? _parseThemeMode(savedMode)
          : AppThemeMode.light;

      emit(state.copyWith(colorType: colorType, themeMode: themeMode));
    } catch (e) {
      // Fallback to default
      emit(const ThemeState());
    }
  }

  // ✅ Đổi màu theme
  Future<void> changeColor(ThemeColorType colorType) async {
    await _storageService.saveThemeColor(colorType.name);
    emit(state.copyWith(colorType: colorType));
  }

  // ✅ Đổi theme mode (light/dark/system)
  Future<void> changeMode(AppThemeMode mode) async {
    await _storageService.saveThemeMode(mode.name);
    emit(state.copyWith(themeMode: mode));
  }

  // ✅ Toggle dark/light
  Future<void> toggleTheme() async {
    final newMode = isDarkMode ? AppThemeMode.light : AppThemeMode.dark;
    await changeMode(newMode);
  }

  // ✅ Parse theme color from string
  ThemeColorType _parseThemeColor(String value) {
    try {
      return ThemeColorType.values.firstWhere(
        (e) => e.name == value,
        orElse: () => ThemeColorType.blue,
      );
    } catch (e) {
      return ThemeColorType.blue;
    }
  }

  // ✅ Parse theme mode from string
  AppThemeMode _parseThemeMode(String value) {
    try {
      return AppThemeMode.values.firstWhere(
        (e) => e.name == value,
        orElse: () => AppThemeMode.light,
      );
    } catch (e) {
      return AppThemeMode.light;
    }
  }
}
