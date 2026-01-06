import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// InfoCard - Hiển thị thông tin theo dạng key-value
class InfoCard extends StatelessWidget {
  const InfoCard({
    super.key,
    required this.items,
    this.title,
    this.titleWidget,
    this.trailing,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.borderRadius,
    this.elevation,
    this.dividerColor,
    this.showDivider = true,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.onTap,
  });

  final List<InfoItem> items;
  final String? title;
  final Widget? titleWidget;
  final Widget? trailing;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Color? backgroundColor;
  final double? borderRadius;
  final double? elevation;
  final Color? dividerColor;
  final bool showDivider;
  final CrossAxisAlignment crossAxisAlignment;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: margin ?? EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      elevation: elevation ?? 1,
      color: backgroundColor ?? theme.cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius ?? 12.r),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(borderRadius ?? 12.r),
        child: Padding(
          padding: padding ?? EdgeInsets.all(16.r),
          child: Column(
            crossAxisAlignment: crossAxisAlignment,
            children: [
              // Header
              if (title != null || titleWidget != null || trailing != null)
                Padding(
                  padding: EdgeInsets.only(bottom: 12.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      titleWidget ??
                          (title != null
                              ? Text(
                                  title!,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                )
                              : const SizedBox.shrink()),
                      if (trailing != null) trailing!,
                    ],
                  ),
                ),

              // Items
              ...items.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                final isLast = index == items.length - 1;

                return Column(
                  children: [
                    _InfoRow(item: item),
                    if (!isLast && showDivider)
                      Divider(
                        height: 16.h,
                        color: dividerColor ?? theme.dividerColor.withOpacity(0.5),
                      ),
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.item});

  final InfoItem item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (item.isCustom && item.customWidget != null) {
      return item.customWidget!;
    }

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Leading icon
          if (item.icon != null)
            Padding(
              padding: EdgeInsets.only(right: 12.w),
              child: Icon(
                item.icon,
                size: 20.r,
                color: item.iconColor ?? theme.colorScheme.primary,
              ),
            ),

          // Label
          Expanded(
            flex: item.labelFlex,
            child: Text(
              item.label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),

          SizedBox(width: 8.w),

          // Value
          Expanded(
            flex: item.valueFlex,
            child: item.valueWidget ??
                Text(
                  item.value ?? '-',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: item.valueColor,
                  ),
                  textAlign: TextAlign.end,
                ),
          ),

          // Trailing
          if (item.trailing != null)
            Padding(
              padding: EdgeInsets.only(left: 8.w),
              child: item.trailing!,
            ),
        ],
      ),
    );
  }
}

/// InfoItem model
class InfoItem {
  const InfoItem({
    required this.label,
    this.value,
    this.valueWidget,
    this.icon,
    this.iconColor,
    this.valueColor,
    this.trailing,
    this.labelFlex = 2,
    this.valueFlex = 3,
    this.isCustom = false,
    this.customWidget,
  });

  final String label;
  final String? value;
  final Widget? valueWidget;
  final IconData? icon;
  final Color? iconColor;
  final Color? valueColor;
  final Widget? trailing;
  final int labelFlex;
  final int valueFlex;
  final bool isCustom;
  final Widget? customWidget;

  /// Factory for custom row
  factory InfoItem.custom(Widget widget) => InfoItem(
        label: '',
        isCustom: true,
        customWidget: widget,
      );

  /// Factory for status badge
  factory InfoItem.status({
    required String label,
    required String status,
    required Color color,
  }) =>
      InfoItem(
        label: label,
        valueWidget: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Text(
            status,
            style: TextStyle(
              color: color,
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
}

// ════════════════════════════════════════════════════════════════
// STAT CARD
// ════════════════════════════════════════════════════════════════

/// StatCard - Hiển thị thống kê với icon
class StatCard extends StatelessWidget {
  const StatCard({
    super.key,
    required this.title,
    required this.value,
    this.subtitle,
    this.icon,
    this.iconColor,
    this.backgroundColor,
    this.trend,
    this.trendValue,
    this.onTap,
  });

  final String title;
  final String value;
  final String? subtitle;
  final IconData? icon;
  final Color? iconColor;
  final Color? backgroundColor;
  final StatTrend? trend;
  final String? trendValue;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveIconColor = iconColor ?? theme.colorScheme.primary;

    return Card(
      elevation: 2,
      color: backgroundColor ?? theme.cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Padding(
          padding: EdgeInsets.all(16.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (icon != null)
                    Container(
                      padding: EdgeInsets.all(10.r),
                      decoration: BoxDecoration(
                        color: effectiveIconColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Icon(
                        icon,
                        color: effectiveIconColor,
                        size: 24.r,
                      ),
                    ),
                  if (trend != null && trendValue != null)
                    _TrendBadge(trend: trend!, value: trendValue!),
                ],
              ),

              SizedBox(height: 16.h),

              // Value
              Text(
                value,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 4.h),

              // Title
              Text(
                title,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),

              // Subtitle
              if (subtitle != null) ...[
                SizedBox(height: 4.h),
                Text(
                  subtitle!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant.withOpacity(0.7),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _TrendBadge extends StatelessWidget {
  const _TrendBadge({required this.trend, required this.value});

  final StatTrend trend;
  final String value;

  @override
  Widget build(BuildContext context) {
    final color = trend == StatTrend.up
        ? Colors.green
        : trend == StatTrend.down
            ? Colors.red
            : Colors.grey;

    final icon = trend == StatTrend.up
        ? Icons.trending_up
        : trend == StatTrend.down
            ? Icons.trending_down
            : Icons.trending_flat;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16.r, color: color),
          SizedBox(width: 4.w),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

enum StatTrend { up, down, neutral }
