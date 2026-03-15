import 'package:dat_san_247_mobile/core/common/utils/logger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../di/injection.dart';

/// 🎯 BlocManager v2 — Quản lý lifecycle BLoC/Cubit
///
/// Hỗ trợ:
/// - Auto-inject từ GetIt
/// - Auto-dispose khi refCount = 0
/// - Đa instance (scoped) thông qua [key]
/// - Factory mode (truyền params để tạo Cubit)
/// - Debug: xem toàn bộ BLoC đang sống
///
/// Ví dụ:
/// ```dart
/// // Singleton (mặc định)
/// final cubit = BlocManager.get<MyCubit>();
///
/// // Scoped — 2 instance khác nhau cho cùng Type
/// final cubit1 = BlocManager.get<MyCubit>(key: 'tab1');
/// final cubit2 = BlocManager.get<MyCubit>(key: 'tab2');
///
/// // Factory — truyền params
/// final cubit = BlocManager.getWith<MyCubit>(() => MyCubit(id: 123));
/// ```
class BlocManager {
  // key = "$Type" hoặc "$Type:$scopeKey"
  static final Map<String, BlocBase> _instances = {};
  static final Map<String, int> _refCounts = {};

  /// Tạo cache key
  static String _cacheKey<T>(String? key) => key == null ? '$T' : '$T:$key';

  /// Lấy hoặc tạo BLoC/Cubit từ GetIt
  ///
  /// [key] — Nếu truyền vào, sẽ tạo instance riêng biệt (scoped)
  /// Nếu không truyền, dùng chung 1 instance cho cùng Type (singleton-like)
  static T get<T extends BlocBase>({String? key}) {
    final cacheKey = _cacheKey<T>(key);

    if (!_instances.containsKey(cacheKey) ||
        (_instances[cacheKey] as dynamic).isClosed) {
      _instances[cacheKey] = getIt<T>();
      _refCounts[cacheKey] = 0;
      Logger.debug(
        'BlocManager: Created $cacheKey (total: ${_instances.length})',
      );
    }

    _refCounts[cacheKey] = _refCounts[cacheKey]! + 1;
    return _instances[cacheKey] as T;
  }

  /// Lấy hoặc tạo BLoC/Cubit bằng factory function (cho trường hợp cần truyền params)
  ///
  /// ```dart
  /// final cubit = BlocManager.getWith(() => DetailCubit(id: '123'), key: 'detail_123');
  /// ```
  static T getWith<T extends BlocBase>(T Function() factory, {String? key}) {
    final cacheKey = _cacheKey<T>(key);

    if (!_instances.containsKey(cacheKey) ||
        (_instances[cacheKey] as dynamic).isClosed) {
      _instances[cacheKey] = factory();
      _refCounts[cacheKey] = 0;
      Logger.debug(
        'BlocManager: Created (factory) $cacheKey (total: ${_instances.length})',
      );
    }

    _refCounts[cacheKey] = _refCounts[cacheKey]! + 1;
    return _instances[cacheKey] as T;
  }

  /// Giảm refCount. Nếu refCount = 0 thì tự động close() và xóa khỏi cache.
  static void release<T extends BlocBase>({String? key}) {
    final cacheKey = _cacheKey<T>(key);

    if (!_refCounts.containsKey(cacheKey)) return;

    _refCounts[cacheKey] = _refCounts[cacheKey]! - 1;

    if (_refCounts[cacheKey]! <= 0) {
      final bloc = _instances[cacheKey];
      if (bloc != null && !(bloc as dynamic).isClosed) {
        bloc.close();
      }
      _instances.remove(cacheKey);
      _refCounts.remove(cacheKey);
      Logger.debug(
        'BlocManager: Disposed $cacheKey (remaining: ${_instances.length})',
      );
    }
  }

  /// Đọc instance hiện tại mà KHÔNG tăng refCount
  /// Trả về null nếu chưa được khởi tạo
  static T? peek<T extends BlocBase>({String? key}) {
    final cacheKey = _cacheKey<T>(key);
    final bloc = _instances[cacheKey];
    if (bloc != null && (bloc as dynamic).isClosed) {
      _instances.remove(cacheKey);
      _refCounts.remove(cacheKey);
      return null;
    }
    return bloc as T?;
  }

  /// Buộc hủy và tạo lại instance (dùng cho pull-to-refresh, logout, v.v.)
  static T recreate<T extends BlocBase>({String? key}) {
    final cacheKey = _cacheKey<T>(key);
    final currentRefCount = _refCounts[cacheKey] ?? 1;

    // Close instance cũ
    final oldBloc = _instances[cacheKey];
    if (oldBloc != null && !(oldBloc as dynamic).isClosed) {
      oldBloc.close();
    }

    // Tạo instance mới, giữ nguyên refCount
    _instances[cacheKey] = getIt<T>();
    _refCounts[cacheKey] = currentRefCount;
    Logger.debug('BlocManager: Recreated $cacheKey');
    return _instances[cacheKey] as T;
  }

  /// Hủy tất cả (dùng khi logout hoặc dispose toàn app)
  static void disposeAll() {
    for (final bloc in _instances.values) {
      if (!(bloc as dynamic).isClosed) {
        bloc.close();
      }
    }
    _instances.clear();
    _refCounts.clear();
    Logger.debug('BlocManager: Disposed ALL');
  }

  /// 🐛 Debug: In ra danh sách BLoC đang sống
  static void debugPrint() {
    Logger.debug('╔══════════════════════════════════════');
    Logger.debug('║ BlocManager — Active Instances: ${_instances.length}');
    Logger.debug('╠══════════════════════════════════════');
    for (final entry in _instances.entries) {
      final refCount = _refCounts[entry.key] ?? 0;
      final isClosed = (entry.value as dynamic).isClosed;
      Logger.debug('║ ${entry.key} — refs: $refCount — closed: $isClosed');
    }
    Logger.debug('╚══════════════════════════════════════');
  }
}
