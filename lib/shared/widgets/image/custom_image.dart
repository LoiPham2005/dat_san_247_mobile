// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:dat_san_247_mobile/core/styles/color_app.dart';
// import 'package:dat_san_247_mobile/core/styles/image_path.dart';

// class CustomImage extends StatelessWidget {
//   final String imageUrl;
//   final BoxFit? fit;
//   final Color? color;
//   final double? height;
//   final double? width;
//   final double radius;
//   final bool isAvatar;
//   final String? placeholderImage;
//   const CustomImage({
//     super.key,
//     required this.imageUrl,
//     this.color,
//     this.fit,
//     this.height,
//     this.isAvatar = false,
//     this.placeholderImage,
//     this.width,
//     this.radius = 0,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return ClipRRect(
//       borderRadius: BorderRadius.circular(radius),
//       child: CachedNetworkImage(
//         imageUrl: imageUrl,
//         fit: fit ?? BoxFit.cover,
//         height: height,
//         width: width,
//         errorWidget: (context, error, stackTrace) {
//           return SizedBox(
//             height: height,
//             width: width,
//             child: Center(
//               child: isAvatar
//                   ? Image.asset(
//                       ImagePath.logoIcon,
//                       color: color,
//                       height: (height ?? 0),
//                     )
//                   : Image.asset(
//                       placeholderImage ?? ImagePath.placehoderImage,
//                       fit: BoxFit.contain,
//                       color: placeholderImage == null ? null : color,
//                       height: (height ?? 0) * 0.5 > 100 ? 70 : height,
//                     ),
//             ),
//           );
//         },
//         progressIndicatorBuilder: (context, url, progress) => SizedBox(
//           height: height,
//           width: width,
//           child: Stack(
//             alignment: Alignment.center,
//             children: [
//               SizedBox(
//                 height: (height ?? 0) > 50 ? 50 : height,
//                 width: (height ?? 0) > 50 ? 50 : height,
//                 child: CircularProgressIndicator(
//                   color: ColorApp.primaryColor,
//                   strokeWidth: 1.5,
//                   value: progress.progress,
//                 ),
//               ),
//               Positioned(
//                 left: 5,
//                 right: 5,
//                 bottom: 5,
//                 top: 5,
//                 child: Center(
//                   child: Image.asset(
//                     ImagePath.logoIcon,
//                     fit: BoxFit.contain,
//                     // height: 50,
//                     height: (height ?? 0) > 50 ? 50 : height,
//                     width: (height ?? 0) > 50 ? 50 : height,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_base_template/core/constants/assets_constants.dart';
import 'package:shimmer/shimmer.dart';

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
                  ? Image.asset(
                      Assets.icons.home,
                      color: color,
                      height: (height ?? 0),
                    )
                  : Image.asset(
                      placeholderImage ?? Assets.images.placeholder,
                      fit: BoxFit.contain,
                      color: placeholderImage == null ? null : color,
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
