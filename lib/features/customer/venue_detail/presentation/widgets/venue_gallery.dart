import 'package:flutter/material.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import '../../data/models/court_model.dart';

class VenueGallery extends StatelessWidget {
  final List<MediaAttachmentModel> mediaAttachments;
  final String? fallbackThumbnail;

  const VenueGallery({
    super.key,
    required this.mediaAttachments,
    this.fallbackThumbnail,
  });

  @override
  Widget build(BuildContext context) {
    // If no media, display a placeholder
    final images = _getImages();
    if (images.isEmpty) {
      return Container(
        color: AppColors.mutedLight,
        child: const Center(
          child: Icon(Icons.image_not_supported_outlined, size: 50, color: AppColors.mutedForegroundLight),
        ),
      );
    }

    return PageView.builder(
      itemCount: images.length,
      itemBuilder: (context, index) {
        return Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              images[index],
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: AppColors.mutedLight,
                child: const Center(child: Icon(Icons.broken_image_rounded, color: AppColors.mutedForegroundLight)),
              ),
            ),
            // Gradient Overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.black.withOpacity(0.4),
                    AppColors.transparent,
                    AppColors.black.withOpacity(0.6),
                  ],
                ),
              ),
            ),
            // Pagination Indicator
            Positioned(
              bottom: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  '${index + 1}/${images.length}',
                  style: const TextStyle(color: AppColors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  List<String> _getImages() {
    List<String> images = mediaAttachments.map((m) => m.url ?? m.fileId).where((url) => url.isNotEmpty).toList();
    if (images.isEmpty && fallbackThumbnail != null && fallbackThumbnail!.isNotEmpty) {
      images.add(fallbackThumbnail!);
    }
    return images;
  }
}
