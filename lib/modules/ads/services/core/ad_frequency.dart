import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/data/storage/local/local_storage_keys.dart';
import '../../domain/ad_placements.dart';

class AdFrequency {
  AdFrequency() {
    _ready = _load();
  }

  final _last = <String, DateTime>{};
  final _count = <String, int>{};
  final _session = <String, int>{};
  final _daily = <String, int>{};

  DateTime? _sessionStart;
  DateTime? _dayReset;
  bool _loaded = false;
  late Future<void> _ready;
  SharedPreferences? _prefs;

  Future<bool> canShow(
    AdPlacement p, {
    Duration? minInterval,
    int? maxPerSession,
    int? maxPerDay,
    int? maxPerHour,
  }) async {
    await _ready;
    final k = p.name;
    final now = DateTime.now();
    final last = _last[k];

    if (minInterval != null && last != null && now.difference(last) < minInterval) {
      return false;
    }
    if (maxPerSession != null && (_session[k] ?? 0) >= maxPerSession) {
      return false;
    }
    if (maxPerDay != null && (_daily[k] ?? 0) >= maxPerDay) return false;
    if (maxPerHour != null && last != null && now.difference(last).inHours < 1) {
      final hk = '${k}_h${now.year}${now.month}${now.day}${now.hour}';
      if ((_count[hk] ?? 0) >= maxPerHour) return false;
    }
    return true;
  }

  Future<void> markShown(AdPlacement p) async {
    await _ready;
    final k = p.name;
    final now = DateTime.now();
    _last[k] = now;
    _count[k] = (_count[k] ?? 0) + 1;
    _session[k] = (_session[k] ?? 0) + 1;
    _daily[k] = (_daily[k] ?? 0) + 1;
    final hk = '${k}_h${now.year}${now.month}${now.day}${now.hour}';
    _count[hk] = (_count[hk] ?? 0) + 1;
    await _save();
  }

  Future<void> reset() async {
    _last.clear();
    _count.clear();
    _session.clear();
    _daily.clear();
    _sessionStart = _dayReset = DateTime.now();
    await _save();
    await _saveSession();
  }

  Future<SharedPreferences> get _p async => _prefs ??= await SharedPreferences.getInstance();

  Future<void> _load() async {
    if (_loaded) return;
    try {
      final prefs = await _p;
      final raw = prefs.getString(LocalStorageKeys.adFrequencyData);
      final sessRaw = prefs.getString(LocalStorageKeys.adSessionStart);

      if (raw != null) {
        final d = jsonDecode(raw) as Map<String, dynamic>;
        (d['last'] as Map<String, dynamic>?)?.forEach(
          (k, v) => _last[k] = DateTime.parse(v as String),
        );
        _count.addAll(Map<String, int>.from(d['count'] as Map? ?? {}));
        _daily.addAll(Map<String, int>.from(d['daily'] as Map? ?? {}));
        if (d['dayReset'] != null) {
          _dayReset = DateTime.parse(d['dayReset'] as String);
        }
      }

      if (sessRaw != null) {
        _sessionStart = DateTime.parse(sessRaw);
        if (DateTime.now().difference(_sessionStart!).inMinutes > 30) {
          _session.clear();
          _sessionStart = DateTime.now();
          await _saveSession();
        }
      } else {
        _sessionStart = DateTime.now();
        await _saveSession();
      }

      final now = DateTime.now();
      if (_dayReset == null ||
          now.year != _dayReset!.year ||
          now.month != _dayReset!.month ||
          now.day != _dayReset!.day) {
        _daily.clear();
        _dayReset = now;
        await _save();
      }
    } catch (_) {}
    _loaded = true;
  }

  Future<void> _save() async {
    try {
      final prefs = await _p;
      await prefs.setString(
        LocalStorageKeys.adFrequencyData,
        jsonEncode({
          'last': _last.map((k, v) => MapEntry(k, v.toIso8601String())),
          'count': _count,
          'daily': _daily,
          'dayReset': _dayReset?.toIso8601String(),
        }),
      );
    } catch (_) {}
  }

  Future<void> _saveSession() async {
    try {
      final prefs = await _p;
      await prefs.setString(LocalStorageKeys.adSessionStart, _sessionStart!.toIso8601String());
    } catch (_) {}
  }
}
