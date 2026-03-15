import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc_manager.dart';

/// 🚀 AutoBloc v3 — Widget tự Register/Dispose BLoC từ GetIt
///
/// Thay thế BlocProvider thủ công. Hỗ trợ:
/// - `AutoBlocBuilder`    — Chỉ build UI theo state
/// - `AutoBlocListener`   — Chỉ lắng nghe side-effects (toast, navigate)
/// - `AutoBlocConsumer`   — Kết hợp builder + listener
/// - `AutoBlocSelector`   — Tối ưu rebuild bằng cách chọn part của state
/// - `AutoBlocProvider`   — Chỉ cung cấp vào tree (cho con cháu dùng)
/// - `MultiAutoBlocProvider` — Nhiều AutoBlocProvider cùng lúc
///
/// Ví dụ:
/// ```dart
/// // Builder — đơn giản nhất
/// AutoBlocBuilder<MyCubit, MyState>(
///   builder: (context, bloc, state) => Text('${state.data}'),
/// )
///
/// // Consumer — builder + listener
/// AutoBlocConsumer<MyCubit, MyState>(
///   listener: (context, bloc, state) {
///     if (state.isFailure) showToast(state.error!);
///   },
///   builder: (context, bloc, state) => Text('${state.data}'),
/// )
///
/// // Scoped — nhiều instance cùng Type
/// AutoBlocBuilder<MyCubit, MyState>(
///   scopeKey: 'tab1',
///   builder: (context, bloc, state) => ...,
/// )
///
/// // Factory — truyền params khi khởi tạo
/// AutoBlocBuilder<DetailCubit, MyState>(
///   factory: () => DetailCubit(id: productId),
///   scopeKey: 'product_$productId',
///   onInit: (bloc) => bloc.load(),
///   onDispose: (bloc) => bloc.cancel(),
///   builder: (context, bloc, state) => ...,
/// )
///
/// // Selector — chỉ rebuild khi 'data' thay đổi
/// AutoBlocSelector<MyCubit, MyState, List<Item>>(
///   selector: (state) => state.data,
///   builder: (context, data) => ListView(...),
/// )
/// ```

// ──────────────────────────────────────────────────────────────
// 🔧 Mixin chứa logic chung cho tất cả AutoBloc Widgets
// ──────────────────────────────────────────────────────────────
mixin _AutoBlocMixin<T extends BlocBase<S>, S> {
  String? get scopeKey;
  T Function()? get factory;
  void Function(T bloc)? get onInit;
  void Function(T bloc)? get onDispose;

  T _createBloc() {
    final f = factory;
    return f != null
        ? BlocManager.getWith(f, key: scopeKey)
        : BlocManager.get<T>(key: scopeKey);
  }

  void _releaseBloc(T bloc) {
    onDispose?.call(bloc);
    BlocManager.release<T>(key: scopeKey);
  }
}

// ──────────────────────────────────────────────────────────────
// 🎯 AutoBlocSelector
// ──────────────────────────────────────────────────────────────
class AutoBlocSelector<T extends BlocBase<S>, S, V> extends StatefulWidget {
  final BlocWidgetSelector<S, V> selector;
  final Widget Function(BuildContext context, V value) builder;
  final String? scopeKey;
  final T Function()? factory;
  final void Function(T bloc)? onInit;
  final void Function(T bloc)? onDispose;

  const AutoBlocSelector({
    super.key,
    required this.selector,
    required this.builder,
    this.scopeKey,
    this.factory,
    this.onInit,
    this.onDispose,
  });

  @override
  State<AutoBlocSelector<T, S, V>> createState() =>
      _AutoBlocSelectorState<T, S, V>();
}

class _AutoBlocSelectorState<T extends BlocBase<S>, S, V>
    extends State<AutoBlocSelector<T, S, V>>
    with _AutoBlocMixin<T, S> {
  late T _bloc;

  @override
  String? get scopeKey => widget.scopeKey;
  @override
  T Function()? get factory => widget.factory;
  @override
  void Function(T bloc)? get onInit => widget.onInit;
  @override
  void Function(T bloc)? get onDispose => widget.onDispose;

  @override
  void initState() {
    super.initState();
    _bloc = _createBloc();
    widget.onInit?.call(_bloc);
  }

  @override
  void dispose() {
    _releaseBloc(_bloc);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<T>.value(
      value: _bloc,
      child: BlocSelector<T, S, V>(
        bloc: _bloc,
        selector: widget.selector,
        builder: (context, value) => widget.builder(context, value),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────
// 🏗️ AutoBlocBuilder
// ──────────────────────────────────────────────────────────────
class AutoBlocBuilder<T extends BlocBase<S>, S> extends StatefulWidget {
  final Widget Function(BuildContext context, T bloc, S state) builder;
  final BlocBuilderCondition<S>? buildWhen;
  final String? scopeKey;
  final T Function()? factory;
  final void Function(T bloc)? onInit;
  final void Function(T bloc)? onDispose;

  const AutoBlocBuilder({
    super.key,
    required this.builder,
    this.buildWhen,
    this.scopeKey,
    this.factory,
    this.onInit,
    this.onDispose,
  });

  @override
  State<AutoBlocBuilder<T, S>> createState() => _AutoBlocBuilderState<T, S>();
}

class _AutoBlocBuilderState<T extends BlocBase<S>, S>
    extends State<AutoBlocBuilder<T, S>>
    with _AutoBlocMixin<T, S> {
  late T _bloc;

  @override
  String? get scopeKey => widget.scopeKey;
  @override
  T Function()? get factory => widget.factory;
  @override
  void Function(T bloc)? get onInit => widget.onInit;
  @override
  void Function(T bloc)? get onDispose => widget.onDispose;

  @override
  void initState() {
    super.initState();
    _bloc = _createBloc();
    widget.onInit?.call(_bloc);
  }

  @override
  void dispose() {
    _releaseBloc(_bloc);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<T>.value(
      value: _bloc,
      child: BlocBuilder<T, S>(
        bloc: _bloc,
        buildWhen: widget.buildWhen,
        builder: (context, state) => widget.builder(context, _bloc, state),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────
// 👂 AutoBlocListener
// ──────────────────────────────────────────────────────────────
class AutoBlocListener<T extends BlocBase<S>, S> extends StatefulWidget {
  final void Function(BuildContext context, T bloc, S state) listener;
  final BlocListenerCondition<S>? listenWhen;
  final Widget child;
  final String? scopeKey;
  final T Function()? factory;
  final void Function(T bloc)? onInit;
  final void Function(T bloc)? onDispose;

  const AutoBlocListener({
    super.key,
    required this.listener,
    required this.child,
    this.listenWhen,
    this.scopeKey,
    this.factory,
    this.onInit,
    this.onDispose,
  });

  @override
  State<AutoBlocListener<T, S>> createState() => _AutoBlocListenerState<T, S>();
}

class _AutoBlocListenerState<T extends BlocBase<S>, S>
    extends State<AutoBlocListener<T, S>>
    with _AutoBlocMixin<T, S> {
  late T _bloc;

  @override
  String? get scopeKey => widget.scopeKey;
  @override
  T Function()? get factory => widget.factory;
  @override
  void Function(T bloc)? get onInit => widget.onInit;
  @override
  void Function(T bloc)? get onDispose => widget.onDispose;

  @override
  void initState() {
    super.initState();
    _bloc = _createBloc();
    widget.onInit?.call(_bloc);
  }

  @override
  void dispose() {
    _releaseBloc(_bloc);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<T>.value(
      value: _bloc,
      child: BlocListener<T, S>(
        bloc: _bloc,
        listenWhen: widget.listenWhen,
        listener: (context, state) => widget.listener(context, _bloc, state),
        child: widget.child,
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────
// 🔗 AutoBlocConsumer (builder + listener)
// ──────────────────────────────────────────────────────────────
class AutoBlocConsumer<T extends BlocBase<S>, S> extends StatefulWidget {
  final Widget Function(BuildContext context, T bloc, S state) builder;
  final void Function(BuildContext context, T bloc, S state) listener;
  final BlocBuilderCondition<S>? buildWhen;
  final BlocListenerCondition<S>? listenWhen;
  final String? scopeKey;
  final T Function()? factory;
  final void Function(T bloc)? onInit;
  final void Function(T bloc)? onDispose;

  const AutoBlocConsumer({
    super.key,
    required this.builder,
    required this.listener,
    this.buildWhen,
    this.listenWhen,
    this.scopeKey,
    this.factory,
    this.onInit,
    this.onDispose,
  });

  @override
  State<AutoBlocConsumer<T, S>> createState() => _AutoBlocConsumerState<T, S>();
}

class _AutoBlocConsumerState<T extends BlocBase<S>, S>
    extends State<AutoBlocConsumer<T, S>>
    with _AutoBlocMixin<T, S> {
  late T _bloc;

  @override
  String? get scopeKey => widget.scopeKey;
  @override
  T Function()? get factory => widget.factory;
  @override
  void Function(T bloc)? get onInit => widget.onInit;
  @override
  void Function(T bloc)? get onDispose => widget.onDispose;

  @override
  void initState() {
    super.initState();
    _bloc = _createBloc();
    widget.onInit?.call(_bloc);
  }

  @override
  void dispose() {
    _releaseBloc(_bloc);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<T>.value(
      value: _bloc,
      child: BlocConsumer<T, S>(
        bloc: _bloc,
        buildWhen: widget.buildWhen,
        listenWhen: widget.listenWhen,
        builder: (context, state) => widget.builder(context, _bloc, state),
        listener: (context, state) => widget.listener(context, _bloc, state),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────
// 📦 AutoBlocProvider — Chỉ cung cấp vào tree, không build
// ──────────────────────────────────────────────────────────────
class AutoBlocProvider<T extends BlocBase<Object?>> extends StatefulWidget {
  final Widget child;
  final String? scopeKey;
  final T Function()? factory;
  final void Function(T bloc)? onInit;
  final void Function(T bloc)? onDispose;

  const AutoBlocProvider({
    super.key,
    required this.child,
    this.scopeKey,
    this.factory,
    this.onInit,
    this.onDispose,
  });

  @override
  State<AutoBlocProvider<T>> createState() => _AutoBlocProviderState<T>();
}

class _AutoBlocProviderState<T extends BlocBase<Object?>>
    extends State<AutoBlocProvider<T>>
    with _AutoBlocMixin<T, Object?> {
  late T _bloc;

  @override
  String? get scopeKey => widget.scopeKey;
  @override
  T Function()? get factory => widget.factory;
  @override
  void Function(T bloc)? get onInit => widget.onInit;
  @override
  void Function(T bloc)? get onDispose => widget.onDispose;

  @override
  void initState() {
    super.initState();
    _bloc = _createBloc();
    widget.onInit?.call(_bloc);
  }

  @override
  void dispose() {
    _releaseBloc(_bloc);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<T>.value(value: _bloc, child: widget.child);
  }
}

// ──────────────────────────────────────────────────────────────
// 📦 MultiAutoBlocProvider — Nhiều AutoBlocProvider cùng lúc
//
// Dùng builder functions thay vì List<AutoBlocProvider> để giữ type-safety
// ──────────────────────────────────────────────────────────────
class MultiAutoBlocProvider extends StatelessWidget {
  /// Danh sách các builder functions, mỗi cái wrap [child] với 1 AutoBlocProvider
  ///
  /// ```dart
  /// MultiAutoBlocProvider(
  ///   providers: [
  ///     (child) => AutoBlocProvider<AuthCubit>(child: child),
  ///     (child) => AutoBlocProvider<HomeCubit>(child: child),
  ///   ],
  ///   child: MyPage(),
  /// )
  /// ```
  final List<Widget Function(Widget child)> providers;
  final Widget child;

  const MultiAutoBlocProvider({
    super.key,
    required this.providers,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    Widget result = child;
    for (final builder in providers.reversed) {
      result = builder(result);
    }
    return result;
  }
}
