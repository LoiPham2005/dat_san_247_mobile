import 'package:flutter/material.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';

class EditRow extends StatelessWidget {
  final String label;
  final String value;
  final Widget? trailing;
  final VoidCallback? onEdit;
  final bool multiline;

  const EditRow({
    super.key,
    required this.label,
    required this.value,
    this.trailing,
    this.onEdit,
    this.multiline = false,
  });

  @override
  Widget build(BuildContext context) => ListTile(
        dense: true,
        title: Text(label,
            style: const TextStyle(fontSize: 11, color: AppColors.textHint)),
        subtitle: Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: trailing ??
            (onEdit != null
                ? IconButton(
                    icon: const Icon(Icons.edit_outlined,
                        size: 16, color: AppColors.textHint),
                    onPressed: onEdit,
                  )
                : null),
        onTap: onEdit,
      );
}
