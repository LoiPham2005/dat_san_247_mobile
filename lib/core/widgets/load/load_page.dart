import 'package:flutter/material.dart';

enum LoadStatus { loading, success, failure }

Widget LoadPage({
  required LoadStatus status,
  String? message,
  Function()? reLoad,
  Widget? child,
  Widget? loadChild,
  double height = 200,
}) {
  switch (status) {
    case LoadStatus.loading:
      return loadChild ??
          SizedBox(
            height: height,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
    case LoadStatus.success:
      return child ?? const SizedBox(height: 10);
    case LoadStatus.failure:
      return SizedBox(
        height: height,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(message ?? "Đã xảy ra lỗi, vui lòng thử lại."),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: reLoad,
                child: const Text("Thử lại"),
              ),
            ],
          ),
        ),
      );
  }
}
