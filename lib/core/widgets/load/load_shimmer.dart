import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoadShimmer extends StatelessWidget {
  Widget child;
  bool isLoading;
  LoadShimmer({ required this.child, required this.isLoading}) ;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[200]!,
      highlightColor: Colors.grey[50]!,
      direction: ShimmerDirection.ltr,
      enabled: isLoading,
      child: child,
    );
  }
}
