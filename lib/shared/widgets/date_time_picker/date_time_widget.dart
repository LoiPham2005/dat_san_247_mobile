import 'package:flutter/material.dart';

/// Date range picker widget
class AppDateRangePicker extends StatefulWidget {
  const AppDateRangePicker({
    super.key,
    this.initialStartDate,
    this.initialEndDate,
    this.firstDate,
    this.lastDate,
    this.onChanged,
    this.startHint = 'Chọn ngày bắt đầu',
    this.endHint = 'Chọn ngày kết thúc',
    this.label,
    this.borderRadius = 12,
  });

  final DateTime? initialStartDate;
  final DateTime? initialEndDate;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final void Function(DateTime? start, DateTime? end)? onChanged;
  final String startHint;
  final String endHint;
  final String? label;
  final double borderRadius;

  @override
  State<AppDateRangePicker> createState() => _AppDateRangePickerState();
}

class _AppDateRangePickerState extends State<AppDateRangePicker> {
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _startDate = widget.initialStartDate;
    _endDate = widget.initialEndDate;
  }

  String _format(DateTime? date) {
    if (date == null) return '';
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  Future<void> _pickStart() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: widget.firstDate ?? DateTime(2000),
      lastDate: widget.lastDate ?? DateTime(2100),
    );
    if (picked == null) return;

    setState(() {
      _startDate = DateTime(picked.year, picked.month, picked.day, 0, 0, 0);
      // Reset end date if it's before the new start
      if (_endDate != null && _endDate!.isBefore(_startDate!)) {
        _endDate = null;
      }
    });
    widget.onChanged?.call(_startDate, _endDate);
  }

  Future<void> _pickEnd() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _endDate ?? _startDate ?? DateTime.now(),
      firstDate: _startDate ?? widget.firstDate ?? DateTime(2000),
      lastDate: widget.lastDate ?? DateTime(2100),
    );
    if (picked == null) return;

    setState(() {
      _endDate = DateTime(picked.year, picked.month, picked.day, 23, 59, 59);
    });
    widget.onChanged?.call(_startDate, _endDate);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
        ],
        Row(
          children: [
            Expanded(
              child: _DateButton(
                onTap: _pickStart,
                text: _startDate != null
                    ? _format(_startDate)
                    : widget.startHint,
                hasValue: _startDate != null,
                borderRadius: widget.borderRadius,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _DateButton(
                onTap: _pickEnd,
                text: _endDate != null ? _format(_endDate) : widget.endHint,
                hasValue: _endDate != null,
                borderRadius: widget.borderRadius,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _DateButton extends StatelessWidget {
  const _DateButton({
    required this.onTap,
    required this.text,
    required this.hasValue,
    required this.borderRadius,
  });

  final VoidCallback onTap;
  final String text;
  final bool hasValue;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(borderRadius),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(color: theme.colorScheme.outline),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                text,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: hasValue ? null : theme.hintColor,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(
              Icons.calendar_today_outlined,
              size: 16,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}

/// Single date picker widget
class AppDatePicker extends StatefulWidget {
  const AppDatePicker({
    super.key,
    this.initialDate,
    this.firstDate,
    this.lastDate,
    this.onChanged,
    this.hint = 'Chọn ngày',
    this.label,
    this.borderRadius = 12,
    this.prefixIcon,
  });

  final DateTime? initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final void Function(DateTime?)? onChanged;
  final String hint;
  final String? label;
  final double borderRadius;
  final IconData? prefixIcon;

  @override
  State<AppDatePicker> createState() => _AppDatePickerState();
}

class _AppDatePickerState extends State<AppDatePicker> {
  DateTime? _date;

  @override
  void initState() {
    super.initState();
    _date = widget.initialDate;
  }

  String _format(DateTime date) =>
      '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';

  Future<void> _pick() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date ?? DateTime.now(),
      firstDate: widget.firstDate ?? DateTime(2000),
      lastDate: widget.lastDate ?? DateTime(2100),
    );
    if (picked == null) return;
    setState(() => _date = picked);
    widget.onChanged?.call(_date);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
        ],
        InkWell(
          onTap: _pick,
          borderRadius: BorderRadius.circular(widget.borderRadius),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              border: Border.all(color: theme.colorScheme.outline),
            ),
            child: Row(
              children: [
                Icon(
                  widget.prefixIcon ?? Icons.calendar_month_outlined,
                  size: 20,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _date != null ? _format(_date!) : widget.hint,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: _date != null ? null : theme.hintColor,
                    ),
                  ),
                ),
                if (_date != null)
                  GestureDetector(
                    onTap: () {
                      setState(() => _date = null);
                      widget.onChanged?.call(null);
                    },
                    child: Icon(
                      Icons.clear,
                      size: 18,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
