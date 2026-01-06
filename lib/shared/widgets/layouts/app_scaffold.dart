import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Smart Scaffold với nhiều tính năng
class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.bottomNavigationBar,
    this.drawer,
    this.endDrawer,
    this.bottomSheet,
    this.backgroundColor,
    this.resizeToAvoidBottomInset,
    this.extendBody = false,
    this.extendBodyBehindAppBar = false,
    this.padding,
    this.safeArea = true,
    this.safeAreaTop = true,
    this.safeAreaBottom = true,
    this.safeAreaLeft = true,
    this.safeAreaRight = true,
    this.onWillPop,
    this.systemOverlayStyle,
  });

  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Widget? bottomNavigationBar;
  final Widget? drawer;
  final Widget? endDrawer;
  final Widget? bottomSheet;
  final Color? backgroundColor;
  final bool? resizeToAvoidBottomInset;
  final bool extendBody;
  final bool extendBodyBehindAppBar;
  final EdgeInsets? padding;
  final bool safeArea;
  final bool safeAreaTop;
  final bool safeAreaBottom;
  final bool safeAreaLeft;
  final bool safeAreaRight;
  final Future<bool> Function()? onWillPop;
  final SystemUiOverlayStyle? systemOverlayStyle;

  @override
  Widget build(BuildContext context) {
    Widget content = body;

    // Apply padding
    if (padding != null) {
      content = Padding(padding: padding!, child: content);
    }

    // Apply SafeArea
    if (safeArea) {
      content = SafeArea(
        top: safeAreaTop && appBar == null,
        bottom: safeAreaBottom && bottomNavigationBar == null,
        left: safeAreaLeft,
        right: safeAreaRight,
        child: content,
      );
    }

    Widget scaffold = Scaffold(
      appBar: appBar,
      body: content,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      bottomNavigationBar: bottomNavigationBar,
      drawer: drawer,
      endDrawer: endDrawer,
      bottomSheet: bottomSheet,
      backgroundColor: backgroundColor,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      extendBody: extendBody,
      extendBodyBehindAppBar: extendBodyBehindAppBar,
    );

    // Apply system overlay style
    if (systemOverlayStyle != null) {
      scaffold = AnnotatedRegion<SystemUiOverlayStyle>(
        value: systemOverlayStyle!,
        child: scaffold,
      );
    }

    // Apply WillPopScope
    if (onWillPop != null) {
      scaffold = PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) async {
          if (!didPop) {
            final shouldPop = await onWillPop!();
            if (shouldPop && context.mounted) {
              Navigator.of(context).pop();
            }
          }
        },
        child: scaffold,
      );
    }

    return scaffold;
  }
}

/// Scaffold với loading overlay
class LoadingScaffold extends StatelessWidget {
  const LoadingScaffold({
    super.key,
    required this.body,
    this.isLoading = false,
    this.loadingMessage,
    this.appBar,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.backgroundColor,
    this.padding,
  });

  final Widget body;
  final bool isLoading;
  final String? loadingMessage;
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final Color? backgroundColor;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AppScaffold(
          appBar: appBar,
          body: body,
          floatingActionButton: floatingActionButton,
          bottomNavigationBar: bottomNavigationBar,
          backgroundColor: backgroundColor,
          padding: padding,
        ),
        if (isLoading)
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(24.r),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CircularProgressIndicator(),
                        if (loadingMessage != null) ...[
                          SizedBox(height: 16.h),
                          Text(loadingMessage!),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// Scaffold với TabBar
class TabbedScaffold extends StatelessWidget {
  const TabbedScaffold({
    super.key,
    required this.tabs,
    required this.tabViews,
    this.title,
    this.titleWidget,
    this.actions,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.backgroundColor,
    this.tabBarBackgroundColor,
    this.initialIndex = 0,
    this.isScrollable = false,
    this.onTabChanged,
  });

  final List<Tab> tabs;
  final List<Widget> tabViews;
  final String? title;
  final Widget? titleWidget;
  final List<Widget>? actions;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final Color? backgroundColor;
  final Color? tabBarBackgroundColor;
  final int initialIndex;
  final bool isScrollable;
  final ValueChanged<int>? onTabChanged;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      initialIndex: initialIndex,
      child: Builder(
        builder: (context) {
          final tabController = DefaultTabController.of(context);

          tabController.addListener(() {
            if (!tabController.indexIsChanging) {
              onTabChanged?.call(tabController.index);
            }
          });

          return Scaffold(
            appBar: AppBar(
              title: titleWidget ?? (title != null ? Text(title!) : null),
              actions: actions,
              bottom: TabBar(
                tabs: tabs,
                isScrollable: isScrollable,
                indicatorColor: Theme.of(context).colorScheme.primary,
              ),
            ),
            body: TabBarView(children: tabViews),
            floatingActionButton: floatingActionButton,
            bottomNavigationBar: bottomNavigationBar,
            backgroundColor: backgroundColor,
          );
        },
      ),
    );
  }
}
