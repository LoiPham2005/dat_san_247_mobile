import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Widget hiển thị khi danh sách rỗng
class EmptyListWidget extends StatelessWidget {
  const EmptyListWidget({
    super.key,
    this.icon,
    this.iconWidget,
    this.title,
    this.message,
    this.actionLabel,
    this.onAction,
    this.iconSize,
    this.iconColor,
    this.padding,
    this.style = EmptyListStyle.standard,
  });

  final IconData? icon;
  final Widget? iconWidget;
  final String? title;
  final String? message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final double? iconSize;
  final Color? iconColor;
  final EdgeInsetsGeometry? padding;
  final EmptyListStyle style;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: padding ?? EdgeInsets.all(32.r),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildIcon(theme),
            if (title != null) ...[
              SizedBox(height: 16.h),
              _buildTitle(theme),
            ],
            if (message != null) ...[
              SizedBox(height: 8.h),
              _buildMessage(theme),
            ],
            if (actionLabel != null && onAction != null) ...[
              SizedBox(height: 24.h),
              _buildAction(theme),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildIcon(ThemeData theme) {
    if (iconWidget != null) return iconWidget!;

    final effectiveIcon = icon ?? _getDefaultIcon();
    final effectiveSize = iconSize ?? _getIconSize();
    final effectiveColor = iconColor ?? _getIconColor(theme);

    switch (style) {
      case EmptyListStyle.standard:
        return Icon(
          effectiveIcon,
          size: effectiveSize,
          color: effectiveColor,
        );

      case EmptyListStyle.circled:
        return Container(
          width: effectiveSize * 1.5,
          height: effectiveSize * 1.5,
          decoration: BoxDecoration(
            color: effectiveColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            effectiveIcon,
            size: effectiveSize * 0.7,
            color: effectiveColor,
          ),
        );

      case EmptyListStyle.outlined:
        return Container(
          width: effectiveSize * 1.5,
          height: effectiveSize * 1.5,
          decoration: BoxDecoration(
            border: Border.all(
              color: effectiveColor.withOpacity(0.3),
              width: 2,
            ),
            shape: BoxShape.circle,
          ),
          child: Icon(
            effectiveIcon,
            size: effectiveSize * 0.7,
            color: effectiveColor,
          ),
        );

      case EmptyListStyle.minimal:
        return Icon(
          effectiveIcon,
          size: effectiveSize * 0.8,
          color: effectiveColor.withOpacity(0.5),
        );
    }
  }

  Widget _buildTitle(ThemeData theme) {
    return Text(
      title!,
      style: theme.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w600,
        color: theme.colorScheme.onSurface,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildMessage(ThemeData theme) {
    return Text(
      message!,
      style: theme.textTheme.bodyMedium?.copyWith(
        color: theme.colorScheme.onSurfaceVariant,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildAction(ThemeData theme) {
    switch (style) {
      case EmptyListStyle.standard:
      case EmptyListStyle.circled:
        return FilledButton(
          onPressed: onAction,
          child: Text(actionLabel!),
        );

      case EmptyListStyle.outlined:
        return OutlinedButton(
          onPressed: onAction,
          child: Text(actionLabel!),
        );

      case EmptyListStyle.minimal:
        return TextButton(
          onPressed: onAction,
          child: Text(actionLabel!),
        );
    }
  }

  IconData _getDefaultIcon() {
    switch (style) {
      case EmptyListStyle.standard:
        return Icons.inbox_outlined;
      case EmptyListStyle.circled:
        return Icons.search_off;
      case EmptyListStyle.outlined:
        return Icons.folder_open_outlined;
      case EmptyListStyle.minimal:
        return Icons.hourglass_empty;
    }
  }

  double _getIconSize() {
    switch (style) {
      case EmptyListStyle.standard:
        return 80.r;
      case EmptyListStyle.circled:
        return 100.r;
      case EmptyListStyle.outlined:
        return 100.r;
      case EmptyListStyle.minimal:
        return 60.r;
    }
  }

  Color _getIconColor(ThemeData theme) {
    return theme.colorScheme.onSurfaceVariant.withOpacity(0.5);
  }
}

enum EmptyListStyle {
  standard,
  circled,
  outlined,
  minimal,
}

// ════════════════════════════════════════════════════════════════
// PRESET EMPTY WIDGETS
// ════════════════════════════════════════════════════════════════

/// Empty search results
class EmptySearchWidget extends StatelessWidget {
  const EmptySearchWidget({
    super.key,
    this.searchQuery,
    this.onClearSearch,
  });

  final String? searchQuery;
  final VoidCallback? onClearSearch;

  @override
  Widget build(BuildContext context) {
    return EmptyListWidget(
      icon: Icons.search_off,
      title: 'Không tìm thấy kết quả',
      message: searchQuery != null
          ? 'Không có kết quả phù hợp với "$searchQuery"'
          : 'Thử tìm kiếm với từ khóa khác',
      actionLabel: onClearSearch != null ? 'Xóa tìm kiếm' : null,
      onAction: onClearSearch,
      style: EmptyListStyle.circled,
    );
  }
}

/// Empty favorites
class EmptyFavoritesWidget extends StatelessWidget {
  const EmptyFavoritesWidget({
    super.key,
    this.onExplore,
  });

  final VoidCallback? onExplore;

  @override
  Widget build(BuildContext context) {
    return EmptyListWidget(
      icon: Icons.favorite_border,
      title: 'Chưa có mục yêu thích',
      message: 'Thêm các mục vào danh sách yêu thích để xem lại sau',
      actionLabel: onExplore != null ? 'Khám phá ngay' : null,
      onAction: onExplore,
      style: EmptyListStyle.circled,
    );
  }
}

/// Empty cart
class EmptyCartWidget extends StatelessWidget {
  const EmptyCartWidget({
    super.key,
    this.onShopNow,
  });

  final VoidCallback? onShopNow;

  @override
  Widget build(BuildContext context) {
    return EmptyListWidget(
      icon: Icons.shopping_cart_outlined,
      title: 'Giỏ hàng trống',
      message: 'Bạn chưa thêm sản phẩm nào vào giỏ hàng',
      actionLabel: onShopNow != null ? 'Mua sắm ngay' : null,
      onAction: onShopNow,
      style: EmptyListStyle.circled,
    );
  }
}

/// Empty notifications
class EmptyNotificationsWidget extends StatelessWidget {
  const EmptyNotificationsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const EmptyListWidget(
      icon: Icons.notifications_off_outlined,
      title: 'Không có thông báo',
      message: 'Bạn sẽ nhận thông báo khi có cập nhật mới',
      style: EmptyListStyle.minimal,
    );
  }
}

/// Empty messages
class EmptyMessagesWidget extends StatelessWidget {
  const EmptyMessagesWidget({
    super.key,
    this.onStartChat,
  });

  final VoidCallback? onStartChat;

  @override
  Widget build(BuildContext context) {
    return EmptyListWidget(
      icon: Icons.chat_bubble_outline,
      title: 'Không có tin nhắn',
      message: 'Bắt đầu cuộc trò chuyện mới',
      actionLabel: onStartChat != null ? 'Bắt đầu chat' : null,
      onAction: onStartChat,
      style: EmptyListStyle.outlined,
    );
  }
}
