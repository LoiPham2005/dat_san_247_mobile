import 'package:flutter/material.dart';
import 'app_button.dart';

/// Button với loading state tự động
class LoadingButton extends StatefulWidget {
  const LoadingButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.icon,
    this.type = AppButtonType.primary,
    this.size = AppButtonSize.medium,
    this.isExpanded = false,
  });

  final Future<void> Function() onPressed;
  final String label;
  final IconData? icon;
  final AppButtonType type;
  final AppButtonSize size;
  final bool isExpanded;

  @override
  State<LoadingButton> createState() => _LoadingButtonState();
}

class _LoadingButtonState extends State<LoadingButton> {
  bool _isLoading = false;

  Future<void> _handlePressed() async {
    if (_isLoading) return;

    setState(() => _isLoading = true);
    try {
      await widget.onPressed();
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppButton(
      onPressed: _handlePressed,
      label: widget.label,
      icon: widget.icon,
      type: widget.type,
      size: widget.size,
      isLoading: _isLoading,
      isExpanded: widget.isExpanded,
    );
  }
}
