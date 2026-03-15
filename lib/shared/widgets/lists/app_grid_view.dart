import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../states/loading_widget.dart';
import '../states/empty_widget.dart';
import '../states/error_widget.dart' as app;

/// Smart GridView với loading, empty, error states
class AppGridView<T> extends StatelessWidget {
  const AppGridView({
    super.key,
    required this.items,
    required this.itemBuilder,
    this.crossAxisCount = 2,
    this.childAspectRatio = 1.0,
    this.crossAxisSpacing,
    this.mainAxisSpacing,
    this.padding,
    this.physics,
    this.shrinkWrap = false,
    this.scrollDirection = Axis.vertical,
    this.isLoading = false,
    this.isError = false,
    this.errorMessage,
    this.emptyMessage,
    this.emptyIcon,
    this.onRetry,
    this.onRefresh,
    this.loadingWidget,
    this.emptyWidget,
    this.errorWidget,
    this.headerWidget,
    this.footerWidget,
    this.separatorWidget,
    this.controller,
    this.primary,
    this.addAutomaticKeepAlives = true,
    this.addRepaintBoundaries = true,
    this.cacheExtent,
  });

  // Data
  final List<T> items;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;

  // Grid config
  final int crossAxisCount;
  final double childAspectRatio;
  final double? crossAxisSpacing;
  final double? mainAxisSpacing;
  final EdgeInsetsGeometry? padding;
  final ScrollPhysics? physics;
  final bool shrinkWrap;
  final Axis scrollDirection;

  // States
  final bool isLoading;
  final bool isError;
  final String? errorMessage;
  final String? emptyMessage;
  final IconData? emptyIcon;
  final VoidCallback? onRetry;
  final Future<void> Function()? onRefresh;

  // Custom widgets
  final Widget? loadingWidget;
  final Widget? emptyWidget;
  final Widget? errorWidget;
  final Widget? headerWidget;
  final Widget? footerWidget;
  final Widget? separatorWidget;

  // Scroll config
  final ScrollController? controller;
  final bool? primary;
  final bool addAutomaticKeepAlives;
  final bool addRepaintBoundaries;
  final double? cacheExtent;

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

    // Grid content
    Widget gridView = GridView.builder(
      controller: controller,
      primary: primary,
      physics: physics ?? const AlwaysScrollableScrollPhysics(),
      shrinkWrap: shrinkWrap,
      scrollDirection: scrollDirection,
      padding: padding ?? EdgeInsets.all(16.r),
      cacheExtent: cacheExtent,
      addAutomaticKeepAlives: addAutomaticKeepAlives,
      addRepaintBoundaries: addRepaintBoundaries,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: childAspectRatio,
        crossAxisSpacing: crossAxisSpacing ?? 12.r,
        mainAxisSpacing: mainAxisSpacing ?? 12.r,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) =>
          itemBuilder(context, items[index], index),
    );

    // Wrap with header/footer if needed
    if (headerWidget != null || footerWidget != null) {
      gridView = CustomScrollView(
        controller: controller,
        physics: physics ?? const AlwaysScrollableScrollPhysics(),
        slivers: [
          if (headerWidget != null) SliverToBoxAdapter(child: headerWidget),
          SliverPadding(
            padding: padding ?? EdgeInsets.all(16.r),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (context, index) => itemBuilder(context, items[index], index),
                childCount: items.length,
              ),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                childAspectRatio: childAspectRatio,
                crossAxisSpacing: crossAxisSpacing ?? 12.r,
                mainAxisSpacing: mainAxisSpacing ?? 12.r,
              ),
            ),
          ),
          if (footerWidget != null) SliverToBoxAdapter(child: footerWidget),
        ],
      );
    }

    // Wrap with RefreshIndicator if onRefresh provided
    if (onRefresh != null) {
      return RefreshIndicator(onRefresh: onRefresh!, child: gridView);
    }

    return gridView;
  }
}

/// Responsive GridView - Auto adjust columns
class ResponsiveGridView<T> extends StatelessWidget {
  const ResponsiveGridView({
    super.key,
    required this.items,
    required this.itemBuilder,
    this.mobileColumns = 2,
    this.tabletColumns = 3,
    this.desktopColumns = 4,
    this.childAspectRatio = 1.0,
    this.spacing = 12,
    this.padding,
    this.isLoading = false,
    this.isError = false,
    this.errorMessage,
    this.emptyMessage,
    this.onRetry,
    this.onRefresh,
  });

  final List<T> items;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final int mobileColumns;
  final int tabletColumns;
  final int desktopColumns;
  final double childAspectRatio;
  final double spacing;
  final EdgeInsetsGeometry? padding;
  final bool isLoading;
  final bool isError;
  final String? errorMessage;
  final String? emptyMessage;
  final VoidCallback? onRetry;
  final Future<void> Function()? onRefresh;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int columns;
        if (constraints.maxWidth >= 1200) {
          columns = desktopColumns;
        } else if (constraints.maxWidth >= 600) {
          columns = tabletColumns;
        } else {
          columns = mobileColumns;
        }

        return AppGridView<T>(
          items: items,
          itemBuilder: itemBuilder,
          crossAxisCount: columns,
          childAspectRatio: childAspectRatio,
          crossAxisSpacing: spacing,
          mainAxisSpacing: spacing,
          padding: padding,
          isLoading: isLoading,
          isError: isError,
          errorMessage: errorMessage,
          emptyMessage: emptyMessage,
          onRetry: onRetry,
          onRefresh: onRefresh,
        );
      },
    );
  }
}

/// Sliver GridView for CustomScrollView
class SliverAppGridView<T> extends StatelessWidget {
  const SliverAppGridView({
    super.key,
    required this.items,
    required this.itemBuilder,
    this.crossAxisCount = 2,
    this.childAspectRatio = 1.0,
    this.crossAxisSpacing,
    this.mainAxisSpacing,
    this.padding,
  });

  final List<T> items;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final int crossAxisCount;
  final double childAspectRatio;
  final double? crossAxisSpacing;
  final double? mainAxisSpacing;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: padding ?? EdgeInsets.all(16.r),
      sliver: SliverGrid(
        delegate: SliverChildBuilderDelegate(
          (context, index) => itemBuilder(context, items[index], index),
          childCount: items.length,
        ),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          childAspectRatio: childAspectRatio,
          crossAxisSpacing: crossAxisSpacing ?? 12.r,
          mainAxisSpacing: mainAxisSpacing ?? 12.r,
        ),
      ),
    );
  }
}
