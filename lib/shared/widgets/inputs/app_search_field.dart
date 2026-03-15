import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Search Field với debounce
class AppSearchField extends StatefulWidget {
  const AppSearchField({
    super.key,
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.onClear,
    this.hint,
    this.prefixIcon,
    this.suffixIcon,
    this.debounceTime = const Duration(milliseconds: 500),
    this.autofocus = false,
    this.enabled = true,
    this.filled = true,
    this.fillColor,
    this.borderRadius,
    this.contentPadding,
    this.textInputAction = TextInputAction.search,
    this.style = AppSearchFieldStyle.rounded,
  });

  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onClear;
  final String? hint;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Duration debounceTime;
  final bool autofocus;
  final bool enabled;
  final bool filled;
  final Color? fillColor;
  final double? borderRadius;
  final EdgeInsets? contentPadding;
  final TextInputAction textInputAction;
  final AppSearchFieldStyle style;

  @override
  State<AppSearchField> createState() => _AppSearchFieldState();
}

class _AppSearchFieldState extends State<AppSearchField> {
  late TextEditingController _controller;
  Timer? _debounceTimer;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _hasText = _controller.text.isNotEmpty;
    _controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    final hasText = _controller.text.isNotEmpty;
    if (_hasText != hasText) {
      setState(() => _hasText = hasText);
    }

    _debounceTimer?.cancel();
    _debounceTimer = Timer(widget.debounceTime, () {
      widget.onChanged?.call(_controller.text);
    });
  }

  void _clearText() {
    _controller.clear();
    widget.onClear?.call();
    widget.onChanged?.call('');
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    if (widget.controller == null) {
      _controller.dispose();
    } else {
      _controller.removeListener(_onTextChanged);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveBorderRadius = widget.borderRadius ?? _getBorderRadius();

    return TextField(
      controller: _controller,
      autofocus: widget.autofocus,
      enabled: widget.enabled,
      textInputAction: widget.textInputAction,
      onSubmitted: widget.onSubmitted,
      decoration: InputDecoration(
        hintText: widget.hint ?? 'Tìm kiếm...',
        prefixIcon:
            widget.prefixIcon ??
            Icon(Icons.search, color: theme.colorScheme.onSurfaceVariant),
        suffixIcon: _hasText
            ? IconButton(
                icon: Icon(
                  Icons.clear,
                  size: 20.r,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                onPressed: _clearText,
              )
            : widget.suffixIcon,
        filled: widget.filled,
        fillColor:
            widget.fillColor ?? theme.colorScheme.surfaceContainerHighest,
        contentPadding:
            widget.contentPadding ??
            EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(effectiveBorderRadius),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(effectiveBorderRadius),
          borderSide: widget.style == AppSearchFieldStyle.outlined
              ? BorderSide(color: theme.colorScheme.outline)
              : BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(effectiveBorderRadius),
          borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
        ),
      ),
    );
  }

  double _getBorderRadius() {
    switch (widget.style) {
      case AppSearchFieldStyle.rounded:
        return 24.r;
      case AppSearchFieldStyle.outlined:
        return 12.r;
      case AppSearchFieldStyle.flat:
        return 8.r;
    }
  }
}

enum AppSearchFieldStyle { rounded, outlined, flat }

/// Search Bar với actions
class AppSearchBar extends StatelessWidget implements PreferredSizeWidget {
  const AppSearchBar({
    super.key,
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.onClear,
    this.hint,
    this.leading,
    this.actions,
    this.debounceTime = const Duration(milliseconds: 500),
    this.autofocus = false,
    this.backgroundColor,
    this.elevation = 0,
  });

  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onClear;
  final String? hint;
  final Widget? leading;
  final List<Widget>? actions;
  final Duration debounceTime;
  final bool autofocus;
  final Color? backgroundColor;
  final double elevation;

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + 8.h);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: backgroundColor ?? theme.scaffoldBackgroundColor,
      elevation: elevation,
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Row(
            children: [
              if (leading != null) ...[leading!, SizedBox(width: 8.w)],
              Expanded(
                child: AppSearchField(
                  controller: controller,
                  onChanged: onChanged,
                  onSubmitted: onSubmitted,
                  onClear: onClear,
                  hint: hint,
                  debounceTime: debounceTime,
                  autofocus: autofocus,
                ),
              ),
              if (actions != null) ...[SizedBox(width: 8.w), ...actions!],
            ],
          ),
        ),
      ),
    );
  }
}
