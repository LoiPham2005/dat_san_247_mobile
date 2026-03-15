import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Custom AppBar với nhiều style
class AppAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AppAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.subtitle,
    this.leading,
    this.actions,
    this.bottom,
    this.centerTitle,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation,
    this.scrolledUnderElevation,
    this.shadowColor,
    this.surfaceTintColor,
    this.automaticallyImplyLeading = true,
    this.style = AppAppBarStyle.standard,
    this.systemOverlayStyle,
    this.toolbarHeight,
    this.leadingWidth,
    this.titleSpacing,
    this.flexibleSpace,
  });

  final String? title;
  final Widget? titleWidget;
  final String? subtitle;
  final Widget? leading;
  final List<Widget>? actions;
  final PreferredSizeWidget? bottom;
  final bool? centerTitle;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? elevation;
  final double? scrolledUnderElevation;
  final Color? shadowColor;
  final Color? surfaceTintColor;
  final bool automaticallyImplyLeading;
  final AppAppBarStyle style;
  final SystemUiOverlayStyle? systemOverlayStyle;
  final double? toolbarHeight;
  final double? leadingWidth;
  final double? titleSpacing;
  final Widget? flexibleSpace;

  @override
  Size get preferredSize => Size.fromHeight(
    (toolbarHeight ?? kToolbarHeight) + (bottom?.preferredSize.height ?? 0),
  );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppBar(
      title: _buildTitle(theme),
      leading: leading,
      actions: actions,
      bottom: bottom,
      centerTitle: centerTitle ?? _getCenterTitle(),
      backgroundColor: backgroundColor ?? _getBackgroundColor(theme),
      foregroundColor: foregroundColor ?? _getForegroundColor(theme),
      elevation: elevation ?? 0,
      scrolledUnderElevation: scrolledUnderElevation,
      shadowColor: shadowColor,
      surfaceTintColor: surfaceTintColor,
      automaticallyImplyLeading: automaticallyImplyLeading,
      systemOverlayStyle: systemOverlayStyle,
      toolbarHeight: toolbarHeight,
      leadingWidth: leadingWidth,
      titleSpacing: titleSpacing,
      flexibleSpace: flexibleSpace,
    );
  }

  Widget? _buildTitle(ThemeData theme) {
    if (titleWidget != null) return titleWidget;
    if (title == null) return null;

    if (subtitle != null) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: centerTitle == true
            ? CrossAxisAlignment.center
            : CrossAxisAlignment.start,
        children: [
          Text(
            title!,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            subtitle!,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      );
    }

    return Text(title!);
  }

  bool _getCenterTitle() {
    switch (style) {
      case AppAppBarStyle.standard:
      case AppAppBarStyle.large:
        return false;
      case AppAppBarStyle.centered:
        return true;
      case AppAppBarStyle.transparent:
        return true;
    }
  }

  Color? _getBackgroundColor(ThemeData theme) {
    switch (style) {
      case AppAppBarStyle.standard:
      case AppAppBarStyle.centered:
      case AppAppBarStyle.large:
        return theme.colorScheme.surface;
      case AppAppBarStyle.transparent:
        return Colors.transparent;
    }
  }

  Color? _getForegroundColor(ThemeData theme) {
    switch (style) {
      case AppAppBarStyle.standard:
      case AppAppBarStyle.centered:
      case AppAppBarStyle.large:
        return theme.colorScheme.onSurface;
      case AppAppBarStyle.transparent:
        return Colors.white;
    }
  }
}

enum AppAppBarStyle { standard, centered, large, transparent }

// ════════════════════════════════════════════════════════════════
// SLIVER APP BAR
// ════════════════════════════════════════════════════════════════

/// Custom SliverAppBar với nhiều options
class AppSliverAppBar extends StatelessWidget {
  const AppSliverAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.leading,
    this.actions,
    this.bottom,
    this.expandedHeight,
    this.collapsedHeight,
    this.backgroundColor,
    this.foregroundColor,
    this.pinned = true,
    this.floating = false,
    this.snap = false,
    this.stretch = false,
    this.flexibleSpace,
    this.backgroundImage,
    this.gradient,
    this.onStretchTrigger,
  });

  final String? title;
  final Widget? titleWidget;
  final Widget? leading;
  final List<Widget>? actions;
  final PreferredSizeWidget? bottom;
  final double? expandedHeight;
  final double? collapsedHeight;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final bool pinned;
  final bool floating;
  final bool snap;
  final bool stretch;
  final Widget? flexibleSpace;
  final String? backgroundImage;
  final Gradient? gradient;
  final Future<void> Function()? onStretchTrigger;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SliverAppBar(
      title: titleWidget ?? (title != null ? Text(title!) : null),
      leading: leading,
      actions: actions,
      bottom: bottom,
      expandedHeight: expandedHeight ?? 200.h,
      collapsedHeight: collapsedHeight,
      backgroundColor: backgroundColor ?? theme.colorScheme.surface,
      foregroundColor: foregroundColor ?? theme.colorScheme.onSurface,
      pinned: pinned,
      floating: floating,
      snap: snap,
      stretch: stretch,
      onStretchTrigger: onStretchTrigger,
      flexibleSpace: flexibleSpace ?? _buildFlexibleSpace(theme),
    );
  }

  Widget _buildFlexibleSpace(ThemeData theme) {
    return FlexibleSpaceBar(
      background: Stack(
        fit: StackFit.expand,
        children: [
          if (backgroundImage != null)
            Image.asset(backgroundImage!, fit: BoxFit.cover),
          if (gradient != null)
            Container(decoration: BoxDecoration(gradient: gradient)),
          if (backgroundImage != null)
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                ),
              ),
            ),
        ],
      ),
      collapseMode: CollapseMode.parallax,
    );
  }
}

// ════════════════════════════════════════════════════════════════
// SEARCH APP BAR
// ════════════════════════════════════════════════════════════════

/// AppBar với search mode
class SearchAppBar extends StatefulWidget implements PreferredSizeWidget {
  const SearchAppBar({
    super.key,
    this.title,
    this.hintText,
    this.onSearch,
    this.onSearchChanged,
    this.onSearchClosed,
    this.actions,
    this.leading,
    this.backgroundColor,
    this.foregroundColor,
    this.searchController,
    this.autofocus = false,
    this.debounceMs = 300,
  });

  final String? title;
  final String? hintText;
  final void Function(String)? onSearch;
  final void Function(String)? onSearchChanged;
  final VoidCallback? onSearchClosed;
  final List<Widget>? actions;
  final Widget? leading;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final TextEditingController? searchController;
  final bool autofocus;
  final int debounceMs;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  State<SearchAppBar> createState() => _SearchAppBarState();
}

class _SearchAppBarState extends State<SearchAppBar> {
  bool _isSearching = false;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.searchController ?? TextEditingController();
  }

  @override
  void dispose() {
    if (widget.searchController == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _startSearch() {
    setState(() => _isSearching = true);
  }

  void _stopSearch() {
    setState(() {
      _isSearching = false;
      _controller.clear();
    });
    widget.onSearchClosed?.call();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppBar(
      backgroundColor: widget.backgroundColor ?? theme.colorScheme.surface,
      foregroundColor: widget.foregroundColor ?? theme.colorScheme.onSurface,
      leading: _isSearching
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: _stopSearch,
            )
          : widget.leading,
      title: _isSearching ? _buildSearchField(theme) : Text(widget.title ?? ''),
      actions: _isSearching
          ? [
              if (_controller.text.isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _controller.clear();
                    widget.onSearchChanged?.call('');
                  },
                ),
            ]
          : [
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: _startSearch,
              ),
              ...?widget.actions,
            ],
    );
  }

  Widget _buildSearchField(ThemeData theme) {
    return TextField(
      controller: _controller,
      autofocus: widget.autofocus,
      decoration: InputDecoration(
        hintText: widget.hintText ?? 'Tìm kiếm...',
        border: InputBorder.none,
        hintStyle: TextStyle(color: theme.colorScheme.onSurfaceVariant),
      ),
      style: TextStyle(color: theme.colorScheme.onSurface, fontSize: 16.sp),
      textInputAction: TextInputAction.search,
      onChanged: widget.onSearchChanged,
      onSubmitted: widget.onSearch,
    );
  }
}

// ════════════════════════════════════════════════════════════════
// EXTENSIONS
// ════════════════════════════════════════════════════════════════

extension AppAppBarX on AppAppBar {
  /// Thêm search action
  AppAppBar withSearch({required VoidCallback onSearchTap}) {
    return AppAppBar(
      title: title,
      titleWidget: titleWidget,
      subtitle: subtitle,
      leading: leading,
      actions: [
        IconButton(icon: const Icon(Icons.search), onPressed: onSearchTap),
        ...?actions,
      ],
      bottom: bottom,
      centerTitle: centerTitle,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      elevation: elevation,
      style: style,
    );
  }
}
