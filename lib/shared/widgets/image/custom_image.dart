import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../gen/assets.gen.dart';

class CustomImage extends StatelessWidget {
  final String imageUrl;
  final BoxFit? fit;
  final Color? color;
  final double? height;
  final double? width;
  final double radius;
  final bool isAvatar;
  final String? placeholderImage;

  const CustomImage({
    super.key,
    required this.imageUrl,
    this.color,
    this.fit,
    this.height,
    this.isAvatar = false,
    this.placeholderImage,
    this.width,
    this.radius = 0,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        fit: fit ?? BoxFit.cover,
        height: height,
        width: width,
        errorWidget: (context, error, stackTrace) {
          return SizedBox(
            height: height,
            width: width,
            child: Center(
              child: isAvatar
                  ? Icon(
                      Icons.person,
                      size: (height ?? 48) * 0.5,
                      color: Colors.grey.shade400,
                    )
                  : Assets.images.placeholder.image(
                      fit: BoxFit.contain,
                      color: color,
                      height: (height ?? 0) * 0.5 > 100 ? 70 : height,
                    ),
            ),
          );
        },
        progressIndicatorBuilder: (context, url, progress) =>
            Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Container(
                height: height,
                width: width,
                color: Colors.white,
              ),
            ),
      ),
    );
  }
}
