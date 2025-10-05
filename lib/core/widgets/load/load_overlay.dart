import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class LoadOverlay extends StatelessWidget {
  final RxBool isLoading; // overlay khi đang call api
  final RxBool? isEmpty; // dữ liệu rỗng
  final Widget child;
  final String emptyMessage;
  final double? shimmerWidth; // optional width
  final double? shimmerHeight; // optional height
  final EdgeInsetsGeometry? shimmerPadding; // padding xung quanh Shimmer
  final BorderRadius? shimmerBorder; // border radius cho Shimmer

  const LoadOverlay({
    super.key,
    required this.isLoading,
    this.isEmpty,
    required this.child,
    this.emptyMessage = "Không có dữ liệu",
    this.shimmerWidth,
    this.shimmerHeight,
    this.shimmerPadding,
    this.shimmerBorder,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      Widget content;

      if (isLoading.value) {
        content = child;
      } else if (isEmpty?.value == true) {
        content = Center(
          child: Text(
            emptyMessage,
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
        );
      } else {
        content = child;
      }

      return Stack(
        children: [
          content,
          if (isLoading.value)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: Center(
                child: Padding(
                  padding: shimmerPadding ?? const EdgeInsets.all(0),
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    child: Container(
                      width: shimmerWidth ?? 100,
                      height: shimmerHeight ?? 100,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: shimmerBorder ?? BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade400), // optional border
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      );
    });
  }
}
