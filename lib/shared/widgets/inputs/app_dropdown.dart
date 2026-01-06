import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Custom Dropdown với nhiều style
class AppDropdown<T> extends StatelessWidget {
  const AppDropdown({
    super.key,
    required this.items,
    required this.onChanged,
    this.value,
    this.hint,
    this.label,
    this.labelWidget,
    this.prefixIcon,
    this.suffixIcon,
    this.itemBuilder,
    this.selectedItemBuilder,
    this.validator,
    this.errorText,
    this.helperText,
    this.enabled = true,
    this.isExpanded = true,
    this.isDense = false,
    this.filled,
    this.fillColor,
    this.borderRadius,
    this.contentPadding,
    this.menuMaxHeight,
    this.focusNode,
    this.autofocus = false,
  });

  final List<T> items;
  final T? value;
  final ValueChanged<T?>? onChanged;
  final String? hint;
  final String? label;
  final Widget? labelWidget;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Widget Function(T item)? itemBuilder;
  final Widget Function(T item)? selectedItemBuilder;
  final String? Function(T?)? validator;
  final String? errorText;
  final String? helperText;
  final bool enabled;
  final bool isExpanded;
  final bool isDense;
  final bool? filled;
  final Color? fillColor;
  final double? borderRadius;
  final EdgeInsets? contentPadding;
  final double? menuMaxHeight;
  final FocusNode? focusNode;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Label
        if (label != null || labelWidget != null)
          Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: labelWidget ??
                Text(
                  label!,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
          ),

        // Dropdown
        DropdownButtonFormField<T>(
          value: value,
          items: items.map((item) {
            return DropdownMenuItem<T>(
              value: item,
              child: itemBuilder?.call(item) ?? Text(item.toString()),
            );
          }).toList(),
          onChanged: enabled ? onChanged : null,
          hint: hint != null ? Text(hint!) : null,
          icon: suffixIcon ?? Icon(Icons.keyboard_arrow_down, size: 24.r),
          isExpanded: isExpanded,
          isDense: isDense,
          validator: validator,
          focusNode: focusNode,
          autofocus: autofocus,
          menuMaxHeight: menuMaxHeight,
          selectedItemBuilder: selectedItemBuilder != null
              ? (context) => items.map((item) => selectedItemBuilder!(item)).toList()
              : null,
          decoration: InputDecoration(
            prefixIcon: prefixIcon,
            filled: filled,
            fillColor: fillColor,
            errorText: errorText,
            helperText: helperText,
            contentPadding: contentPadding ??
                EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius ?? 12.r),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius ?? 12.r),
              borderSide: BorderSide(color: theme.colorScheme.outline),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius ?? 12.r),
              borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius ?? 12.r),
              borderSide: BorderSide(color: theme.colorScheme.error),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius ?? 12.r),
              borderSide: BorderSide(color: theme.disabledColor.withOpacity(0.5)),
            ),
          ),
        ),
      ],
    );
  }
}

/// Searchable Dropdown
class AppSearchableDropdown<T> extends StatefulWidget {
  const AppSearchableDropdown({
    super.key,
    required this.items,
    required this.onChanged,
    this.value,
    this.hint,
    this.label,
    this.searchHint,
    this.itemBuilder,
    this.searchMatcher,
    this.enabled = true,
    this.showSearchBox = true,
    this.emptyBuilder,
  });

  final List<T> items;
  final T? value;
  final ValueChanged<T?> onChanged;
  final String? hint;
  final String? label;
  final String? searchHint;
  final Widget Function(T item, bool isSelected)? itemBuilder;
  final bool Function(T item, String query)? searchMatcher;
  final bool enabled;
  final bool showSearchBox;
  final Widget Function()? emptyBuilder;

  @override
  State<AppSearchableDropdown<T>> createState() => _AppSearchableDropdownState<T>();
}

class _AppSearchableDropdownState<T> extends State<AppSearchableDropdown<T>> {
  final _searchController = TextEditingController();
  List<T> _filteredItems = [];

  @override
  void initState() {
    super.initState();
    _filteredItems = widget.items;
  }

  void _filterItems(String query) {
    if (query.isEmpty) {
      setState(() => _filteredItems = widget.items);
      return;
    }

    setState(() {
      _filteredItems = widget.items.where((item) {
        if (widget.searchMatcher != null) {
          return widget.searchMatcher!(item, query);
        }
        return item.toString().toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  void _showBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return StatefulBuilder(
              builder: (context, setModalState) {
                return Column(
                  children: [
                    // Handle
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 12.h),
                      width: 40.w,
                      height: 4.h,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2.r),
                      ),
                    ),

                    // Search box
                    if (widget.showSearchBox)
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: widget.searchHint ?? 'Tìm kiếm...',
                            prefixIcon: const Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          onChanged: (value) {
                            _filterItems(value);
                            setModalState(() {});
                          },
                        ),
                      ),

                    SizedBox(height: 8.h),

                    // Items
                    Expanded(
                      child: _filteredItems.isEmpty
                          ? (widget.emptyBuilder?.call() ??
                              Center(
                                child: Text(
                                  'Không tìm thấy kết quả',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ))
                          : ListView.builder(
                              controller: scrollController,
                              itemCount: _filteredItems.length,
                              itemBuilder: (context, index) {
                                final item = _filteredItems[index];
                                final isSelected = item == widget.value;

                                return ListTile(
                                  title: widget.itemBuilder?.call(item, isSelected) ??
                                      Text(item.toString()),
                                  trailing: isSelected
                                      ? Icon(
                                          Icons.check,
                                          color: Theme.of(context).colorScheme.primary,
                                        )
                                      : null,
                                  selected: isSelected,
                                  onTap: () {
                                    widget.onChanged(item);
                                    Navigator.pop(context);
                                    _searchController.clear();
                                    _filteredItems = widget.items;
                                  },
                                );
                              },
                            ),
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null)
          Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: Text(
              widget.label!,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        InkWell(
          onTap: widget.enabled ? _showBottomSheet : null,
          borderRadius: BorderRadius.circular(12.r),
          child: InputDecorator(
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              suffixIcon: Icon(Icons.keyboard_arrow_down, size: 24.r),
            ),
            child: Text(
              widget.value?.toString() ?? widget.hint ?? 'Chọn...',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: widget.value == null ? theme.hintColor : null,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
