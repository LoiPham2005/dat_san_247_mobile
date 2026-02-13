import 'package:flutter/material.dart';
import 'package:dat_san_247_mobile/core/state_management/bloc/base_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Các helpers để listen state changes phổ biến
class BlocListeners {
  /// Hiển thị SnackBar khi state thất bại hoặc thành công (có message)
  static BlocListener<B, BaseState<T>> common<B extends StateStreamable<BaseState<T>>, T>({
    void Function(BuildContext, BaseState<T>)? listener,
    Widget? child,
  }) {
    return BlocListener<B, BaseState<T>>(
      listener: (context, state) {
        listener?.call(context, state);

        if (state.isFailure && state.error != null) {
          _showSnackBar(context, state.error!, Colors.red);
        } else if (state.isSuccess && state.message != null) {
          _showSnackBar(context, state.message!, Colors.green);
        }
      },
      child: child ?? const SizedBox.shrink(),
    );
  }

  static void _showSnackBar(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: color, behavior: SnackBarBehavior.floating),
    );
  }
}
