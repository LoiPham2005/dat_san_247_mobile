import 'package:flutter/material.dart';

/// Mixin để quản lý scroll với pagination
mixin ScrollMixin<T extends StatefulWidget> on State<T> {
  late final ScrollController scrollController;
  bool _isLoadingMore = false;
  bool get isLoadingMore => _isLoadingMore;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController()..addListener(_onScroll);
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isNearBottom && !_isLoadingMore) {
      onLoadMore();
    }
  }

  bool get _isNearBottom {
    if (!scrollController.hasClients) return false;
    final maxScroll = scrollController.position.maxScrollExtent;
    final currentScroll = scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  /// Override this to handle load more
  Future<void> onLoadMore() async {}

  void setLoadingMore(bool value) {
    if (mounted) {
      setState(() => _isLoadingMore = value);
    }
  }
}
