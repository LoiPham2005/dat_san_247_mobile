// lib/extensions/widget_extensions.dart

import 'package:flutter/material.dart';

extension WidgetExtensions on Widget {
  // Padding extensions
  Widget padding(EdgeInsetsGeometry padding) {
    return Padding(padding: padding, child: this);
  }

  Widget paddingAll(double value) {
    return Padding(padding: EdgeInsets.all(value), child: this);
  }

  Widget paddingSymmetric({double horizontal = 0, double vertical = 0}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical),
      child: this,
    );
  }

  Widget paddingOnly({
    double left = 0,
    double top = 0,
    double right = 0,
    double bottom = 0,
  }) {
    return Padding(
      padding: EdgeInsets.only(
        left: left,
        top: top,
        right: right,
        bottom: bottom,
      ),
      child: this,
    );
  }

  // Margin (Container wrapper)
  Widget margin(EdgeInsetsGeometry margin) {
    return Container(margin: margin, child: this);
  }

  Widget marginAll(double value) {
    return Container(margin: EdgeInsets.all(value), child: this);
  }

  Widget marginSymmetric({double horizontal = 0, double vertical = 0}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical),
      child: this,
    );
  }

  // Center
  Widget center() {
    return Center(child: this);
  }

  // Align
  Widget align(Alignment alignment) {
    return Align(alignment: alignment, child: this);
  }

  // Expanded
  Widget expanded({int flex = 1}) {
    return Expanded(flex: flex, child: this);
  }

  // Flexible
  Widget flexible({int flex = 1, FlexFit fit = FlexFit.loose}) {
    return Flexible(flex: flex, fit: fit, child: this);
  }

  // SizedBox wrapper
  Widget withSize({double? width, double? height}) {
    return SizedBox(width: width, height: height, child: this);
  }

  Widget withWidth(double width) {
    return SizedBox(width: width, child: this);
  }

  Widget withHeight(double height) {
    return SizedBox(height: height, child: this);
  }

  // Opacity
  Widget opacity(double opacity) {
    return Opacity(opacity: opacity, child: this);
  }

  // Visibility
  Widget visible(bool isVisible, {Widget? replacement}) {
    return Visibility(
      visible: isVisible,
      replacement: replacement ?? const SizedBox.shrink(),
      child: this,
    );
  }

  // GestureDetector
  Widget onTap(VoidCallback onTap) {
    return GestureDetector(onTap: onTap, child: this);
  }

  Widget onLongPress(VoidCallback onLongPress) {
    return GestureDetector(onLongPress: onLongPress, child: this);
  }

  // InkWell với ripple effect
  Widget inkWell({
    VoidCallback? onTap,
    VoidCallback? onLongPress,
    BorderRadius? borderRadius,
  }) {
    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      borderRadius: borderRadius,
      child: this,
    );
  }

  // Card wrapper
  Widget card({
    Color? color,
    double? elevation,
    ShapeBorder? shape,
    EdgeInsetsGeometry? margin,
  }) {
    return Card(
      color: color,
      elevation: elevation,
      shape: shape,
      margin: margin,
      child: this,
    );
  }

  // Container wrapper
  Widget container({
    Color? color,
    double? width,
    double? height,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Decoration? decoration,
    AlignmentGeometry? alignment,
  }) {
    return Container(
      color: color,
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      decoration: decoration,
      alignment: alignment,
      child: this,
    );
  }

  // ClipRRect
  Widget clipRRect({double radius = 8.0}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: this,
    );
  }

  // Hero animation
  Widget hero(String tag) {
    return Hero(tag: tag, child: this);
  }

  // Rotate
  Widget rotate({required double angle}) {
    return Transform.rotate(angle: angle, child: this);
  }

  // Scale
  Widget scale({required double scale}) {
    return Transform.scale(scale: scale, child: this);
  }

  // SafeArea
  Widget safeArea({
    bool top = true,
    bool bottom = true,
    bool left = true,
    bool right = true,
  }) {
    return SafeArea(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: this,
    );
  }
}