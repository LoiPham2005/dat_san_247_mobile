import 'package:flutter/material.dart';

/// Breakpoints cho responsive design
class Breakpoints {
  Breakpoints._();

  static const double mobile = 600;
  static const double tablet = 900;
  static const double desktop = 1200;
  static const double largeDesktop = 1800;
}

/// Device type
enum DeviceType { mobile, tablet, desktop, largeDesktop }

/// Screen size info
class ScreenInfo {
  final DeviceType deviceType;
  final Size screenSize;
  final double width;
  final double height;
  final Orientation orientation;
  final bool isMobile;
  final bool isTablet;
  final bool isDesktop;

  const ScreenInfo({
    required this.deviceType,
    required this.screenSize,
    required this.width,
    required this.height,
    required this.orientation,
    required this.isMobile,
    required this.isTablet,
    required this.isDesktop,
  });

  factory ScreenInfo.fromContext(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final size = mediaQuery.size;
    final width = size.width;
    final orientation = mediaQuery.orientation;

    DeviceType deviceType;
    if (width < Breakpoints.mobile) {
      deviceType = DeviceType.mobile;
    } else if (width < Breakpoints.tablet) {
      deviceType = DeviceType.tablet;
    } else if (width < Breakpoints.desktop) {
      deviceType = DeviceType.desktop;
    } else {
      deviceType = DeviceType.largeDesktop;
    }

    return ScreenInfo(
      deviceType: deviceType,
      screenSize: size,
      width: width,
      height: size.height,
      orientation: orientation,
      isMobile: deviceType == DeviceType.mobile,
      isTablet: deviceType == DeviceType.tablet,
      isDesktop:
          deviceType == DeviceType.desktop ||
          deviceType == DeviceType.largeDesktop,
    );
  }
}

/// ResponsiveBuilder - Build different layouts based on screen size
class ResponsiveBuilder extends StatelessWidget {
  const ResponsiveBuilder({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
    this.largeDesktop,
  });

  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;
  final Widget? largeDesktop;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        if (width >= Breakpoints.largeDesktop && largeDesktop != null) {
          return largeDesktop!;
        }
        if (width >= Breakpoints.desktop && desktop != null) {
          return desktop!;
        }
        if (width >= Breakpoints.tablet && tablet != null) {
          return tablet!;
        }
        return mobile;
      },
    );
  }

  /// Helper để get current screen info
  static ScreenInfo of(BuildContext context) {
    return ScreenInfo.fromContext(context);
  }

  /// Check if mobile
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < Breakpoints.mobile;
  }

  /// Check if tablet
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= Breakpoints.mobile && width < Breakpoints.tablet;
  }

  /// Check if desktop
  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= Breakpoints.tablet;
  }
}

/// ResponsiveValue - Return different values based on screen size
class ResponsiveValue<T> {
  final T mobile;
  final T? tablet;
  final T? desktop;

  const ResponsiveValue({required this.mobile, this.tablet, this.desktop});

  T resolve(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (width >= Breakpoints.tablet && desktop != null) {
      return desktop!;
    }
    if (width >= Breakpoints.mobile && tablet != null) {
      return tablet!;
    }
    return mobile;
  }
}

/// ResponsiveGrid - Auto-adjust columns based on screen size
class ResponsiveGrid extends StatelessWidget {
  const ResponsiveGrid({
    super.key,
    required this.children,
    this.mobileColumns = 1,
    this.tabletColumns = 2,
    this.desktopColumns = 3,
    this.largeDesktopColumns = 4,
    this.spacing = 16,
    this.runSpacing = 16,
    this.padding,
    this.childAspectRatio = 1.0,
  });

  final List<Widget> children;
  final int mobileColumns;
  final int tabletColumns;
  final int desktopColumns;
  final int largeDesktopColumns;
  final double spacing;
  final double runSpacing;
  final EdgeInsetsGeometry? padding;
  final double childAspectRatio;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = _getColumns(constraints.maxWidth);

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: padding ?? const EdgeInsets.all(16),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: spacing,
            mainAxisSpacing: runSpacing,
            childAspectRatio: childAspectRatio,
          ),
          itemCount: children.length,
          itemBuilder: (context, index) => children[index],
        );
      },
    );
  }

  int _getColumns(double width) {
    if (width >= Breakpoints.largeDesktop) return largeDesktopColumns;
    if (width >= Breakpoints.desktop) return desktopColumns;
    if (width >= Breakpoints.tablet) return tabletColumns;
    return mobileColumns;
  }
}

/// ResponsivePadding - Auto-adjust padding based on screen size
class ResponsivePadding extends StatelessWidget {
  const ResponsivePadding({
    super.key,
    required this.child,
    this.mobilePadding,
    this.tabletPadding,
    this.desktopPadding,
  });

  final Widget child;
  final EdgeInsetsGeometry? mobilePadding;
  final EdgeInsetsGeometry? tabletPadding;
  final EdgeInsetsGeometry? desktopPadding;

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      mobile: Padding(
        padding: mobilePadding ?? const EdgeInsets.all(16),
        child: child,
      ),
      tablet: Padding(
        padding: tabletPadding ?? const EdgeInsets.all(24),
        child: child,
      ),
      desktop: Padding(
        padding: desktopPadding ?? const EdgeInsets.all(32),
        child: child,
      ),
    );
  }
}

/// ResponsiveConstraints - Constrain width on larger screens
class ResponsiveConstraints extends StatelessWidget {
  const ResponsiveConstraints({
    super.key,
    required this.child,
    this.maxWidth = 1200,
    this.alignment = Alignment.topCenter,
    this.padding,
  });

  final Widget child;
  final double maxWidth;
  final Alignment alignment;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: padding != null
            ? Padding(padding: padding!, child: child)
            : child,
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════
// EXTENSIONS
// ════════════════════════════════════════════════════════════════

extension ResponsiveContextX on BuildContext {
  /// Get screen info
  ScreenInfo get screenInfo => ScreenInfo.fromContext(this);

  /// Check device type
  bool get isMobile => ResponsiveBuilder.isMobile(this);
  bool get isTablet => ResponsiveBuilder.isTablet(this);
  bool get isDesktop => ResponsiveBuilder.isDesktop(this);

  /// Get responsive value
  T responsive<T>({required T mobile, T? tablet, T? desktop}) {
    return ResponsiveValue<T>(
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
    ).resolve(this);
  }
}
