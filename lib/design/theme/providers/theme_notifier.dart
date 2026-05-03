import 'package:dat_san_247_mobile/core/data/storage/local/local_storage_provider.dart';
import 'package:dat_san_247_mobile/design/theme/app_theme.dart';
import 'package:dat_san_247_mobile/gen/theme/color_palettes.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'theme_state.dart';

part 'theme_notifier.g.dart';

@riverpod
class ThemeNotifier extends _$ThemeNotifier {
  @override
  ThemeState build() {
    final storage = ref.watch(localStorageServiceProvider);
    return ThemeState(
      colorType: _parseEnum(AppColorTheme.values, storage.getThemeColor(), fallback: AppColorTheme.light),
      themeMode: _parseEnum(AppThemeMode.values, storage.getThemeMode(), fallback: AppThemeMode.light),
    );
  }

  Future<void> changeColor(AppColorTheme colorType) async {
    await ref.read(localStorageServiceProvider).saveThemeColor(colorType.name);
    state = state.copyWith(colorType: colorType);
  }

  Future<void> changeMode(AppThemeMode mode) async {
    await ref.read(localStorageServiceProvider).saveThemeMode(mode.name);
    state = state.copyWith(themeMode: mode);
  }

  Future<void> toggleTheme() =>
      changeMode(state.isDark ? AppThemeMode.light : AppThemeMode.dark);

  T _parseEnum<T extends Enum>(List<T> values, String? value, {required T fallback}) =>
      values.firstWhere((e) => e.name == value, orElse: () => fallback);
}
