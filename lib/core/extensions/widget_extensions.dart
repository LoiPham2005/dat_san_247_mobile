// ════════════════════════════════════════════════════════════════
// 📁 lib/core/extensions/widget_extensions.dart
// ════════════════════════════════════════════════════════════════
import 'package:flutter/material.dart';

// ❌ XÓA PHẦN NÀY (đã có trong number_extensions.dart)
// extension NumExtensions on num { ... }

// ✅ CHỈ GIỮ PHẦN NÀY
extension WidgetExtensions on Widget {
  // ═══════════════════════════════════════════════════════════════
  // PADDING
  // ═══════════════════════════════════════════════════════════════

  /// Custom padding
  Widget padding(EdgeInsetsGeometry padding) {
    return Padding(padding: padding, child: this);
  }

  /// Padding all sides
  Widget paddingAll(double value) {
    return Padding(padding: EdgeInsets.all(value), child: this);
  }

  /// Padding symmetric
  Widget paddingSymmetric({double horizontal = 0, double vertical = 0}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical),
      child: this,
    );
  }

  /// Padding only specific sides
  Widget paddingOnly({
    double left = 0,
    double top = 0,
    double right = 0,
    double bottom = 0,
  }) {
    return Padding(
      padding: EdgeInsets.only(left: left, top: top, right: right, bottom: bottom),
      child: this,
    );
  }

  /// Horizontal padding
  Widget paddingHorizontal(double value) {
    return Padding(padding: EdgeInsets.symmetric(horizontal: value), child: this);
  }

  /// Vertical padding
  Widget paddingVertical(double value) {
    return Padding(padding: EdgeInsets.symmetric(vertical: value), child: this);
  }

  // ═══════════════════════════════════════════════════════════════
  // MARGIN (Container wrapper)
  // ═══════════════════════════════════════════════════════════════

  /// Custom margin
  Widget margin(EdgeInsetsGeometry margin) {
    return Container(margin: margin, child: this);
  }

  /// Margin all sides
  Widget marginAll(double value) {
    return Container(margin: EdgeInsets.all(value), child: this);
  }

  /// Margin symmetric
  Widget marginSymmetric({double horizontal = 0, double vertical = 0}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical),
      child: this,
    );
  }

  /// Margin only specific sides
  Widget marginOnly({
    double left = 0,
    double top = 0,
    double right = 0,
    double bottom = 0,
  }) {
    return Container(
      margin: EdgeInsets.only(left: left, top: top, right: right, bottom: bottom),
      child: this,
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // ALIGNMENT
  // ═══════════════════════════════════════════════════════════════

  /// Center widget
  Widget center() => Center(child: this);

  /// Align widget
  Widget align(Alignment alignment) => Align(alignment: alignment, child: this);

  Widget alignTopLeft() => Align(alignment: Alignment.topLeft, child: this);
  Widget alignTopCenter() => Align(alignment: Alignment.topCenter, child: this);
  Widget alignTopRight() => Align(alignment: Alignment.topRight, child: this);
  Widget alignCenterLeft() => Align(alignment: Alignment.centerLeft, child: this);
  Widget alignCenterRight() => Align(alignment: Alignment.centerRight, child: this);
  Widget alignBottomLeft() => Align(alignment: Alignment.bottomLeft, child: this);
  Widget alignBottomCenter() => Align(alignment: Alignment.bottomCenter, child: this);
  Widget alignBottomRight() => Align(alignment: Alignment.bottomRight, child: this);

  // ═══════════════════════════════════════════════════════════════
  // FLEX
  // ═══════════════════════════════════════════════════════════════

  /// Expanded widget
  Widget expanded({int flex = 1}) => Expanded(flex: flex, child: this);

  /// Flexible widget
  Widget flexible({int flex = 1, FlexFit fit = FlexFit.loose}) {
    return Flexible(flex: flex, fit: fit, child: this);
  }

  // ═══════════════════════════════════════════════════════════════
  // SIZED BOX
  // ═══════════════════════════════════════════════════════════════

  /// Custom size
  Widget withSize({double? width, double? height}) {
    return SizedBox(width: width, height: height, child: this);
  }

  /// Fixed width
  Widget withWidth(double width) => SizedBox(width: width, child: this);

  /// Fixed height
  Widget withHeight(double height) => SizedBox(height: height, child: this);

  /// Square size
  Widget square(double size) => SizedBox(width: size, height: size, child: this);

  // ═══════════════════════════════════════════════════════════════
  // VISIBILITY & OPACITY
  // ═══════════════════════════════════════════════════════════════

  /// Opacity
  Widget opacity(double opacity) => Opacity(opacity: opacity, child: this);

  /// Visibility
  Widget visible(bool isVisible, {Widget? replacement}) {
    return Visibility(
      visible: isVisible,
      replacement: replacement ?? const SizedBox.shrink(),
      child: this,
    );
  }

  /// Hide widget
  Widget hide() => Visibility(visible: false, child: this);

  /// Show widget conditionally
  Widget showIf(bool condition) => Visibility(visible: condition, child: this);

  // ═══════════════════════════════════════════════════════════════
  // GESTURES
  // ═══════════════════════════════════════════════════════════════

  /// Tap gesture
  Widget onTap(VoidCallback? onTap) {
    return GestureDetector(onTap: onTap, child: this);
  }

  /// Long press gesture
  Widget onLongPress(VoidCallback? onLongPress) {
    return GestureDetector(onLongPress: onLongPress, child: this);
  }

  /// Double tap gesture
  Widget onDoubleTap(VoidCallback? onDoubleTap) {
    return GestureDetector(onDoubleTap: onDoubleTap, child: this);
  }

  /// InkWell with ripple effect
  Widget inkWell({
    VoidCallback? onTap,
    VoidCallback? onLongPress,
    BorderRadius? borderRadius,
    Color? splashColor,
    Color? highlightColor,
  }) {
    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      borderRadius: borderRadius,
      splashColor: splashColor,
      highlightColor: highlightColor,
      child: this,
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // DECORATION
  // ═══════════════════════════════════════════════════════════════

  /// Card wrapper
  Widget card({
    Color? color,
    double? elevation,
    ShapeBorder? shape,
    EdgeInsetsGeometry? margin,
    Clip? clipBehavior,
  }) {
    return Card(
      color: color,
      elevation: elevation,
      shape: shape,
      margin: margin,
      clipBehavior: clipBehavior,
      child: this,
    );
  }

  /// Container wrapper
  Widget container({
    Color? color,
    double? width,
    double? height,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Decoration? decoration,
    AlignmentGeometry? alignment,
    BoxConstraints? constraints,
  }) {
    return Container(
      color: color,
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      decoration: decoration,
      alignment: alignment,
      constraints: constraints,
      child: this,
    );
  }

  /// Decorated box
  Widget decorated({
    required Decoration decoration,
    DecorationPosition position = DecorationPosition.background,
  }) {
    return DecoratedBox(decoration: decoration, position: position, child: this);
  }

  /// Background color
  Widget backgroundColor(Color color) {
    return DecoratedBox(decoration: BoxDecoration(color: color), child: this);
  }

  /// Rounded corners
  Widget rounded({double radius = 8.0}) {
    return ClipRRect(borderRadius: BorderRadius.circular(radius), child: this);
  }

  /// ClipRRect
  Widget clipRRect({double radius = 8.0, BorderRadius? borderRadius}) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(radius),
      child: this,
    );
  }

  /// Clip oval
  Widget clipOval() => ClipOval(child: this);

  // ═══════════════════════════════════════════════════════════════
  // BORDER
  // ═══════════════════════════════════════════════════════════════

  /// Add border
  Widget border({
    Color color = const Color(0xFF000000),
    double width = 1.0,
    BorderRadius? borderRadius,
  }) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: color, width: width),
        borderRadius: borderRadius,
      ),
      child: this,
    );
  }

  /// Add circular border
  Widget circularBorder({
    Color color = const Color(0xFF000000),
    double width = 1.0,
    double radius = 8.0,
  }) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: color, width: width),
        borderRadius: BorderRadius.circular(radius),
      ),
      child: this,
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // TRANSFORM
  // ═══════════════════════════════════════════════════════════════

  /// Rotate widget
  Widget rotate({required double angle}) {
    return Transform.rotate(angle: angle, child: this);
  }

  /// Scale widget
  Widget scale({
    double? scale,
    double? scaleX,
    double? scaleY,
    Alignment alignment = Alignment.center,
  }) {
    return Transform.scale(
      scale: scale,
      scaleX: scaleX,
      scaleY: scaleY,
      alignment: alignment,
      child: this,
    );
  }

  /// Translate widget
  Widget translate({required Offset offset}) {
    return Transform.translate(offset: offset, child: this);
  }

  // ═══════════════════════════════════════════════════════════════
  // ANIMATION
  // ═══════════════════════════════════════════════════════════════

  /// Hero animation
  Widget hero(String tag) => Hero(tag: tag, child: this);

  // ═══════════════════════════════════════════════════════════════
  // SAFE AREA
  // ═══════════════════════════════════════════════════════════════

  /// Safe area
  Widget safeArea({
    bool top = true,
    bool bottom = true,
    bool left = true,
    bool right = true,
    EdgeInsets minimum = EdgeInsets.zero,
  }) {
    return SafeArea(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      minimum: minimum,
      child: this,
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // SCROLL
  // ═══════════════════════════════════════════════════════════════

  /// Scrollable
  Widget scrollable({
    Axis scrollDirection = Axis.vertical,
    ScrollPhysics? physics,
    EdgeInsetsGeometry? padding,
  }) {
    return SingleChildScrollView(
      scrollDirection: scrollDirection,
      physics: physics,
      padding: padding,
      child: this,
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // CONSTRAINED
  // ═══════════════════════════════════════════════════════════════

  /// Constrained box
  Widget constrained({
    double? minWidth,
    double? maxWidth,
    double? minHeight,
    double? maxHeight,
  }) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: minWidth ?? 0.0,
        maxWidth: maxWidth ?? double.infinity,
        minHeight: minHeight ?? 0.0,
        maxHeight: maxHeight ?? double.infinity,
      ),
      child: this,
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // FITTED
  // ═══════════════════════════════════════════════════════════════

  /// FittedBox
  Widget fitted({BoxFit fit = BoxFit.contain}) {
    return FittedBox(fit: fit, child: this);
  }

  // ═══════════════════════════════════════════════════════════════
  // ASPECT RATIO
  // ═══════════════════════════════════════════════════════════════

  /// AspectRatio
  Widget aspectRatio(double aspectRatio) {
    return AspectRatio(aspectRatio: aspectRatio, child: this);
  }

  // ═══════════════════════════════════════════════════════════════
  // TOOLTIP
  // ═══════════════════════════════════════════════════════════════

  /// Tooltip
  Widget tooltip(String message) {
    return Tooltip(message: message, child: this);
  }

  // ═══════════════════════════════════════════════════════════════
  // IGNORING POINTER
  // ═══════════════════════════════════════════════════════════════

  /// Ignore pointer
  Widget ignorePointer({bool ignoring = true}) {
    return IgnorePointer(ignoring: ignoring, child: this);
  }

  /// Absorb pointer
  Widget absorbPointer({bool absorbing = true}) {
    return AbsorbPointer(absorbing: absorbing, child: this);
  }
}