import 'package:flutter/material.dart';

/// Mixin để quản lý loading state
mixin LoadingMixin<T extends StatefulWidget> on State<T> {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    if (mounted) {
      setState(() => _isLoading = value);
    }
  }

  Future<void> withLoading(Future<void> Function() action) async {
    setLoading(true);
    try {
      await action();
    } finally {
      setLoading(false);
    }
  }
}
