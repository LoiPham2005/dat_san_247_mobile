// // ─────────────────────────────────────────────────────────────
// // 📁 lib/design/theme/cubit/theme_cubit.dart
// // ─────────────────────────────────────────────────────────────
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:injectable/injectable.dart';

// import '../../../core/data/storage/local/local_storage_service.dart';
// import '../../../gen/theme/color_palettes.dart';
// import '../app_theme.dart';
// import 'theme_state.dart';

// @lazySingleton
// class ThemeCubit extends Cubit<ThemeState> {
//   final LocalStorageService _storage;

//   ThemeCubit(this._storage) : super(ThemeState.initial());

//   /// Get current theme properties
//   bool get isDarkMode => state.isDark;
//   AppColorTheme get currentColor => state.colorType;
//   AppThemeMode get currentMode => state.themeMode;

//   /// Khởi tạo theme từ Local Storage hoặc dùng mặc định.
//   Future<void> initTheme() async {
//     try {
//       final colorType = _parseEnum(
//         AppColorTheme.values,
//         _storage.getThemeColor(),
//         fallback: AppColorTheme.light,
//       );
//       final themeMode = _parseEnum(
//         AppThemeMode.values,
//         _storage.getThemeMode(),
//         fallback: AppThemeMode.light,
//       );
//       emit(state.copyWith(colorType: colorType, themeMode: themeMode));
//     } catch (_) {
//       emit(ThemeState.initial());
//     }
//   }

//   /// Thay đổi bộ màu chủ đạo (Palettes).
//   Future<void> changeColor(AppColorTheme colorType) async {
//     await _storage.saveThemeColor(colorType.name);
//     emit(state.copyWith(colorType: colorType));
//   }

//   /// Thay đổi chế độ sáng/tối/hệ thống.
//   Future<void> changeMode(AppThemeMode mode) async {
//     await _storage.saveThemeMode(mode.name);
//     emit(state.copyWith(themeMode: mode));
//   }

//   /// Toggle nhanh giữa Light và Dark mode.
//   Future<void> toggleTheme() => changeMode(isDarkMode ? AppThemeMode.light : AppThemeMode.dark);

//   /// Helper parse string từ storage thành Enum tương ứng.
//   T _parseEnum<T extends Enum>(List<T> values, String? value, {required T fallback}) =>
//       values.firstWhere((e) => e.name == value, orElse: () => fallback);
// }
