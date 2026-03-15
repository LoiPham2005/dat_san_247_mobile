import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Custom Checkbox với label
class AppCheckbox extends StatelessWidget {
  const AppCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.label,
    this.labelWidget,
    this.subtitle,
    this.activeColor,
    this.checkColor,
    this.tristate = false,
    this.shape,
    this.side,
    this.isError = false,
    this.errorText,
    this.enabled = true,
    this.dense = false,
    this.contentPadding,
    this.controlAffinity = ListTileControlAffinity.leading,
  });

  final bool? value;
  final ValueChanged<bool?>? onChanged;
  final String? label;
  final Widget? labelWidget;
  final String? subtitle;
  final Color? activeColor;
  final Color? checkColor;
  final bool tristate;
  final OutlinedBorder? shape;
  final BorderSide? side;
  final bool isError;
  final String? errorText;
  final bool enabled;
  final bool dense;
  final EdgeInsets? contentPadding;
  final ListTileControlAffinity controlAffinity;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final checkbox = Checkbox(
      value: value,
      onChanged: enabled ? onChanged : null,
      activeColor: activeColor ?? theme.colorScheme.primary,
      checkColor: checkColor ?? theme.colorScheme.onPrimary,
      tristate: tristate,
      shape:
          shape ??
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.r)),
      side: isError
          ? BorderSide(color: theme.colorScheme.error, width: 2)
          : side,
    );

    if (label == null && labelWidget == null) {
      return checkbox;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CheckboxListTile(
          value: value,
          onChanged: enabled ? onChanged : null,
          title:
              labelWidget ??
              Text(
                label!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: enabled ? null : theme.disabledColor,
                ),
              ),
          subtitle: subtitle != null
              ? Text(
                  subtitle!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                )
              : null,
          activeColor: activeColor ?? theme.colorScheme.primary,
          checkColor: checkColor ?? theme.colorScheme.onPrimary,
          tristate: tristate,
          dense: dense,
          contentPadding: contentPadding ?? EdgeInsets.zero,
          controlAffinity: controlAffinity,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
        ),
        if (isError && errorText != null)
          Padding(
            padding: EdgeInsets.only(left: 16.w, top: 4.h),
            child: Text(
              errorText!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          ),
      ],
    );
  }
}

/// Checkbox Group - Nhóm nhiều checkbox
class AppCheckboxGroup<T> extends StatelessWidget {
  const AppCheckboxGroup({
    super.key,
    required this.items,
    required this.values,
    required this.onChanged,
    this.labelBuilder,
    this.subtitleBuilder,
    this.direction = Axis.vertical,
    this.spacing = 0,
    this.runSpacing = 0,
    this.activeColor,
    this.enabled = true,
    this.minSelected,
    this.maxSelected,
  });

  final List<T> items;
  final List<T> values;
  final ValueChanged<List<T>> onChanged;
  final String Function(T item)? labelBuilder;
  final String Function(T item)? subtitleBuilder;
  final Axis direction;
  final double spacing;
  final double runSpacing;
  final Color? activeColor;
  final bool enabled;
  final int? minSelected;
  final int? maxSelected;

  @override
  Widget build(BuildContext context) {
    final children = items.map((item) {
      final isSelected = values.contains(item);
      final canSelect =
          maxSelected == null || values.length < maxSelected! || isSelected;
      final canDeselect = minSelected == null || values.length > minSelected!;

      return AppCheckbox(
        value: isSelected,
        onChanged: enabled && (isSelected ? canDeselect : canSelect)
            ? (checked) {
                final newValues = List<T>.from(values);
                if (checked == true) {
                  newValues.add(item);
                } else {
                  newValues.remove(item);
                }
                onChanged(newValues);
              }
            : null,
        label: labelBuilder?.call(item) ?? item.toString(),
        subtitle: subtitleBuilder?.call(item),
        activeColor: activeColor,
        enabled: enabled && (isSelected ? canDeselect : canSelect),
      );
    }).toList();

    if (direction == Axis.horizontal) {
      return Wrap(spacing: spacing, runSpacing: runSpacing, children: children);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }
}

/// Switch với label
class AppSwitch extends StatelessWidget {
  const AppSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.label,
    this.labelWidget,
    this.subtitle,
    this.activeColor,
    this.activeTrackColor,
    this.inactiveThumbColor,
    this.inactiveTrackColor,
    this.enabled = true,
    this.dense = false,
    this.contentPadding,
  });

  final bool value;
  final ValueChanged<bool>? onChanged;
  final String? label;
  final Widget? labelWidget;
  final String? subtitle;
  final Color? activeColor;
  final Color? activeTrackColor;
  final Color? inactiveThumbColor;
  final Color? inactiveTrackColor;
  final bool enabled;
  final bool dense;
  final EdgeInsets? contentPadding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (label == null && labelWidget == null) {
      return Switch(
        value: value,
        onChanged: enabled ? onChanged : null,
        activeColor: activeColor,
        activeTrackColor: activeTrackColor,
        inactiveThumbColor: inactiveThumbColor,
        inactiveTrackColor: inactiveTrackColor,
      );
    }

    return SwitchListTile(
      value: value,
      onChanged: enabled ? onChanged : null,
      title:
          labelWidget ??
          Text(
            label!,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: enabled ? null : theme.disabledColor,
            ),
          ),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            )
          : null,
      activeColor: activeColor,
      activeTrackColor: activeTrackColor,
      inactiveThumbColor: inactiveThumbColor,
      inactiveTrackColor: inactiveTrackColor,
      dense: dense,
      contentPadding: contentPadding ?? EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
    );
  }
}
