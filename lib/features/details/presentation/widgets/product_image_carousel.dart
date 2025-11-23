// import 'package:flutter/material.dart';
// import 'package:carousel_slider/carousel_slider.dart';

// class ProductImageCarousel extends StatefulWidget {
//   final List<String> productImages;
//   final CarouselSliderController carouselController;
//   final Function(int) onPageChanged;
//   final int currentImageIndex;
//   final ProductModel product;

//   const ProductImageCarousel({
//     Key? key,
//     required this.productImages,
//     required this.carouselController,
//     required this.onPageChanged,
//     required this.currentImageIndex,
//     required this.product,
//   }) : super(key: key);

//   @override
//   State<ProductImageCarousel> createState() => _ProductImageCarouselState();
// }

// class _ProductImageCarouselState extends State<ProductImageCarousel> {
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         CarouselSlider(
//           carouselController: widget.carouselController,
//           options: CarouselOptions(
//             height: 300,
//             viewportFraction: 1.0,
//             enlargeCenterPage: false,
//             onPageChanged: (index, reason) {
//               widget.onPageChanged(index);
//             },
//           ),
//           items: widget.productImages.map((item) {
//             return Builder(
//               builder: (BuildContext context) {
//                 return _buildImageWidget(item);
//               },
//             );
//           }).toList(),
//         ),
//         Positioned(
//           bottom: 16,
//           right: 16,
//           child: Container(
//             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//             decoration: BoxDecoration(
//               color: Colors.black.withOpacity(0.4),
//               borderRadius: BorderRadius.circular(36),
//             ),
//             child: Text(
//               '${widget.currentImageIndex + 1}/${widget.productImages.length}',
//               style: const TextStyle(
//                 color: Colors.white,
//                 fontWeight: FontWeight.w400,
//                 fontSize: 14,
//               ),
//             ),
//           ),
//         ),
//         Positioned(
//           bottom: 0,
//           left: 0,
//           child: widget.product.freeShip == 1
//               ? Image.asset(
//                   ImagePath.bgFreeship,
//                   height: 32,
//                   width: 136,
//                 )
//               : const SizedBox(),
//         ),
//         // Positioned(
//         //     bottom: 0,
//         //     left: 0,
//         //     child: Image.asset(
//         //       ImagePath.bgFreeship,
//         //       height: 32,
//         //       width: 136,
//         //     )
//         // Container(
//         //   padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//         //   decoration: const BoxDecoration(
//         //     color: Color(0xFFD30003),
//         //     borderRadius: BorderRadius.only(
//         //       bottomLeft: Radius.circular(8),
//         //     ),
//         //   ),
//         //   child: const Row(
//         //     children: [
//         //       Text(
//         //         'freeship',
//         //         style: TextStyle(
//         //           color: Colors.white,
//         //           fontWeight: FontWeight.w900,
//         //           fontSize: 12,
//         //           letterSpacing: 0.5,
//         //         ),
//         //       ),
//         //       SizedBox(width: 4),
//         //       Icon(Icons.local_shipping, color: Colors.white, size: 16),
//         //     ],
//         //   ),
//         // ),
//         // ),
//         Positioned(
//           bottom: 16,
//           left: 0,
//           right: 0,
//           child: Center(
//             child: AnimatedSmoothIndicator(
//               activeIndex: widget.currentImageIndex,
//               count: widget.productImages.length,
//               effect: const SlideEffect(
//                 spacing: 8.0,
//                 radius: 5.0,
//                 dotWidth: 8.0,
//                 dotHeight: 8.0,
//                 paintStyle: PaintingStyle.fill,
//                 dotColor: Colors.grey,
//                 activeDotColor: Color(0xFF81298F),
//               ),
//             ),
//           ),
//         ),
//         // Back button positioned within the carousel
//       ],
//     );
//   }

//   Widget _buildImageWidget(String imageUrl) {
//     return Image.network(
//       imageUrl,
//       fit: BoxFit.cover,
//       errorBuilder: (context, error, stackTrace) {
//         return Container(
//           color: Colors.grey[200],
//           child: const Center(
//             child: Icon(
//               Icons.image_not_supported,
//               color: Colors.grey,
//               size: 40,
//             ),
//           ),
//         );
//       },
//       loadingBuilder: (context, child, loadingProgress) {
//         if (loadingProgress == null) return child;
//         return Center(
//           child: CircularProgressIndicator(
//             value: loadingProgress.expectedTotalBytes != null
//                 ? loadingProgress.cumulativeBytesLoaded /
//                     loadingProgress.expectedTotalBytes!
//                 : null,
//           ),
//         );
//       },
//     );
//   }
// }
