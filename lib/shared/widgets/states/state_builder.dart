import 'package:flutter/material.dart';
import 'package:dat_san_247_mobile/core/base/state/bloc/base_state.dart';
import 'loading_widget.dart';
import 'error_widget.dart' as app;
import 'empty_widget.dart';

/// Widget builder theo state
class StateBuilder<T> extends StatelessWidget {
  const StateBuilder({
    super.key,
    required this.state,
    required this.onLoaded,
    this.onLoading,
    this.onError,
    this.onEmpty,
    this.onInitial,
  });

  final BaseState<T> state;
  final Widget Function(T data) onLoaded;
  final Widget Function()? onLoading;
  final Widget Function(String error, VoidCallback? retry)? onError;
  final Widget Function()? onEmpty;
  final Widget Function()? onInitial;

  @override
  Widget build(BuildContext context) {
    // Loading
    if (state.isLoading) {
      return onLoading?.call() ?? const LoadingWidget();
    }

    // Error
    if (state.isFailure) {
      return onError?.call(state.error ?? 'Đã xảy ra lỗi', null) ??
          app.AppErrorWidget(message: state.error ?? 'Đã xảy ra lỗi');
    }

    // Empty
    if (state.isEmpty) {
      return onEmpty?.call() ?? const EmptyWidget();
    }

    // Loaded với data
    if (state.isLoaded && state.data != null) {
      return onLoaded(state.data as T);
    }

    // Initial hoặc các trường hợp khác
    return onInitial?.call() ?? const SizedBox.shrink();
  }
}

/// Widget builder cho list với pagination
class PaginatedStateBuilder<T> extends StatelessWidget {
  const PaginatedStateBuilder({
    super.key,
    required this.state,
    required this.itemBuilder,
    this.onLoading,
    this.onError,
    this.onEmpty,
    this.onLoadMore,
    this.separatorBuilder,
    this.padding,
    this.physics,
  });

  final BaseState<List<T>> state;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final Widget Function()? onLoading;
  final Widget Function(String error, VoidCallback? retry)? onError;
  final Widget Function()? onEmpty;
  final VoidCallback? onLoadMore;
  final Widget Function(BuildContext context, int index)? separatorBuilder;
  final EdgeInsets? padding;
  final ScrollPhysics? physics;

  @override
  Widget build(BuildContext context) {
    // Initial loading
    if (state.isLoading &&
        (state.data == null || (state.data as List).isEmpty)) {
      return onLoading?.call() ?? const LoadingWidget();
    }

    // Error (không có data cũ)
    if (state.isFailure &&
        (state.data == null || (state.data as List).isEmpty)) {
      return onError?.call(state.error ?? 'Đã xảy ra lỗi', null) ??
          app.AppErrorWidget(message: state.error ?? 'Đã xảy ra lỗi');
    }

    final items = state.data ?? [];

    // Empty
    if (items.isEmpty) {
      return onEmpty?.call() ?? const EmptyWidget();
    }

    // List với data
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification is ScrollEndNotification &&
            notification.metrics.extentAfter < 200 &&
            onLoadMore != null &&
            !state.isLoading) {
          onLoadMore!();
        }
        return false;
      },
      child: ListView.separated(
        padding: padding,
        physics: physics,
        itemCount: items.length + (state.isRefreshing ? 1 : 0),
        separatorBuilder:
            separatorBuilder ?? (context, index) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          if (index == items.length) {
            return const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            );
          }
          return itemBuilder(context, items[index], index);
        },
      ),
    );
  }
}
