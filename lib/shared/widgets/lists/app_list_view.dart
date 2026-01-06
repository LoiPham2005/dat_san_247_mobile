import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../states/loading_widget.dart';
import '../states/empty_widget.dart';
import '../states/error_widget.dart' as app;

/// Smart ListView với loading, empty, error, load more states
class AppListView<T> extends StatelessWidget {
  const AppListView({
    super.key,
    required this.items,
    required this.itemBuilder,
    this.separatorBuilder,
    this.padding,
    this.physics,
    this.shrinkWrap = false,
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.isError = false,
    this.hasMore = false,
    this.errorMessage,
    this.emptyMessage,
    this.emptyIcon,
    this.onRetry,
    this.onRefresh,
    this.onLoadMore,
    this.loadingWidget,
    this.loadingMoreWidget,
    this.emptyWidget,
    this.errorWidget,
    this.headerWidget,
    this.footerWidget,
    this.controller,
    this.primary,
    this.addAutomaticKeepAlives = true,
    this.addRepaintBoundaries = true,
    this.cacheExtent,
    this.loadMoreThreshold = 200,
  });

  // Data
  final List<T> items;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final Widget Function(BuildContext context, int index)? separatorBuilder;

  // List config
  final EdgeInsetsGeometry? padding;
  final ScrollPhysics? physics;
  final bool shrinkWrap;
  final Axis scrollDirection;
  final bool reverse;

  // States
  final bool isLoading;
  final bool isLoadingMore;
  final bool isError;
  final bool hasMore;
  final String? errorMessage;
  final String? emptyMessage;
  final IconData? emptyIcon;
  final VoidCallback? onRetry;
  final Future<void> Function()? onRefresh;
  final VoidCallback? onLoadMore;

  // Custom widgets
  final Widget? loadingWidget;
  final Widget? loadingMoreWidget;
  final Widget? emptyWidget;
  final Widget? errorWidget;
  final Widget? headerWidget;
  final Widget? footerWidget;

  // Scroll config
  final ScrollController? controller;
  final bool? primary;
  final bool addAutomaticKeepAlives;
  final bool addRepaintBoundaries;
  final double? cacheExtent;
  final double loadMoreThreshold;

  @override
  Widget build(BuildContext context) {
    // Loading state
    if (isLoading && items.isEmpty) {
      return loadingWidget ?? const LoadingWidget();
    }

    // Error state
    if (isError && items.isEmpty) {
      return errorWidget ??
          app.AppErrorWidget(
            message: errorMessage ?? 'Đã xảy ra lỗi',
            onRetry: onRetry,
          );
    }

    // Empty state
    if (items.isEmpty) {
      return emptyWidget ??
          EmptyWidget(
            message: emptyMessage ?? 'Không có dữ liệu',
            icon: emptyIcon,
          );
    }

    // Calculate item count
    final itemCount = items.length +
        (headerWidget != null ? 1 : 0) +
        (footerWidget != null || isLoadingMore || hasMore ? 1 : 0);

    // Build list
    Widget listView = NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification is ScrollEndNotification) {
          final metrics = notification.metrics;
          if (metrics.pixels >= metrics.maxScrollExtent - loadMoreThreshold) {
            if (hasMore && !isLoadingMore && onLoadMore != null) {
              onLoadMore!();
            }
          }
        }
        return false;
      },
      child: ListView.separated(
        controller: controller,
        primary: primary,
        physics: physics ?? const AlwaysScrollableScrollPhysics(),
        shrinkWrap: shrinkWrap,
        scrollDirection: scrollDirection,
        reverse: reverse,
        padding: padding ?? EdgeInsets.all(16.r),
        cacheExtent: cacheExtent,
        addAutomaticKeepAlives: addAutomaticKeepAlives,
        addRepaintBoundaries: addRepaintBoundaries,
        itemCount: itemCount,
        separatorBuilder: (context, index) {
          // Skip separator for header/footer
          if (headerWidget != null && index == 0) return const SizedBox.shrink();
          if (index >= items.length + (headerWidget != null ? 1 : 0)) {
            return const SizedBox.shrink();
          }
          return separatorBuilder?.call(context, index) ?? SizedBox(height: 8.h);
        },
        itemBuilder: (context, index) {
          // Header
          if (headerWidget != null && index == 0) {
            return headerWidget!;
          }

          // Adjust index for header
          final adjustedIndex = index - (headerWidget != null ? 1 : 0);

          // Items
          if (adjustedIndex < items.length) {
            return itemBuilder(context, items[adjustedIndex], adjustedIndex);
          }

          // Footer / Load more
          if (isLoadingMore) {
            return loadingMoreWidget ?? _buildLoadingMore();
          }
          if (footerWidget != null) {
            return footerWidget!;
          }
          return const SizedBox.shrink();
        },
      ),
    );

    // Wrap with RefreshIndicator if onRefresh provided
    if (onRefresh != null) {
      return RefreshIndicator(
        onRefresh: onRefresh!,
        child: listView,
      );
    }

    return listView;
  }

  Widget _buildLoadingMore() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: Center(
        child: SizedBox(
          width: 24.r,
          height: 24.r,
          child: const CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
    );
  }
}

/// Grouped ListView
class GroupedListView<T, G> extends StatelessWidget {
  const GroupedListView({
    super.key,
    required this.items,
    required this.groupBy,
    required this.groupHeaderBuilder,
    required this.itemBuilder,
    this.groupComparator,
    this.itemComparator,
    this.separatorBuilder,
    this.padding,
    this.physics,
    this.shrinkWrap = false,
    this.isLoading = false,
    this.emptyMessage,
    this.onRefresh,
  });

  final List<T> items;
  final G Function(T item) groupBy;
  final Widget Function(G group) groupHeaderBuilder;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final int Function(G a, G b)? groupComparator;
  final int Function(T a, T b)? itemComparator;
  final Widget Function(BuildContext context, int index)? separatorBuilder;
  final EdgeInsetsGeometry? padding;
  final ScrollPhysics? physics;
  final bool shrinkWrap;
  final bool isLoading;
  final String? emptyMessage;
  final Future<void> Function()? onRefresh;

  @override
  Widget build(BuildContext context) {
    if (isLoading && items.isEmpty) {
      return const LoadingWidget();
    }

    if (items.isEmpty) {
      return EmptyWidget(message: emptyMessage ?? 'Không có dữ liệu');
    }

    // Group items
    final groupedItems = <G, List<T>>{};
    for (final item in items) {
      final group = groupBy(item);
      groupedItems.putIfAbsent(group, () => []).add(item);
    }

    // Sort groups
    final sortedGroups = groupedItems.keys.toList();
    if (groupComparator != null) {
      sortedGroups.sort(groupComparator);
    }

    // Build flat list with headers
    final flatList = <dynamic>[];
    for (final group in sortedGroups) {
      flatList.add(group);
      final groupItems = groupedItems[group]!;
      if (itemComparator != null) {
        groupItems.sort(itemComparator);
      }
      flatList.addAll(groupItems);
    }

    Widget listView = ListView.separated(
      physics: physics ?? const AlwaysScrollableScrollPhysics(),
      shrinkWrap: shrinkWrap,
      padding: padding ?? EdgeInsets.all(16.r),
      itemCount: flatList.length,
      separatorBuilder: (context, index) {
        if (flatList[index] is G) return const SizedBox.shrink();
        return separatorBuilder?.call(context, index) ?? SizedBox(height: 8.h);
      },
      itemBuilder: (context, index) {
        final item = flatList[index];
        if (item is G) {
          return groupHeaderBuilder(item);
        }
        final itemIndex = items.indexOf(item as T);
        return itemBuilder(context, item, itemIndex);
      },
    );

    if (onRefresh != null) {
      return RefreshIndicator(
        onRefresh: onRefresh!,
        child: listView,
      );
    }

    return listView;
  }
}

/// Sliver ListView for CustomScrollView
class SliverAppListView<T> extends StatelessWidget {
  const SliverAppListView({
    super.key,
    required this.items,
    required this.itemBuilder,
    this.separatorBuilder,
  });

  final List<T> items;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final Widget Function(BuildContext context, int index)? separatorBuilder;

  @override
  Widget build(BuildContext context) {
    if (separatorBuilder != null) {
      return SliverList.separated(
        itemCount: items.length,
        separatorBuilder: separatorBuilder!,
        itemBuilder: (context, index) => itemBuilder(context, items[index], index),
      );
    }

    return SliverList.builder(
      itemCount: items.length,
      itemBuilder: (context, index) => itemBuilder(context, items[index], index),
    );
  }
}
