import 'package:flutter/material.dart';
import 'package:flutter_base_template/core/storage/storage_keys.dart';
import 'package:flutter_base_template/core/storage/storage_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class LocaleCubit extends Cubit<Locale> {
  LocaleCubit(this._storageService) : super(const Locale('vi'));

  final StorageService _storageService;

  static const supportedLanguages = {
    'vi': 'Tiếng Việt',
    'en': 'English',
    'ja': '日本語',
  };

  Future<void> initLocale() async {
    final savedLocale = _storageService.get<String>(StorageKeys.languageCode);
    if (savedLocale != null && supportedLanguages.containsKey(savedLocale)) {
      await changeLocale(savedLocale);
    }
  }

  Future<void> changeLocale(String languageCode) async {
    if (!supportedLanguages.containsKey(languageCode)) return;

    final newLocale = Locale(languageCode);
    if (newLocale == state) return;

    await _storageService.set(StorageKeys.languageCode, languageCode);
    emit(newLocale);
  }

  String getCurrentLanguageName() {
    return supportedLanguages[state.languageCode] ?? 'Unknown';
  }
}
