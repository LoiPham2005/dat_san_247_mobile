import 'package:flutter/material.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import '../../data/models/venue_detail_model.dart';
import 'package:url_launcher/url_launcher.dart';

class VenueInfoCard extends StatelessWidget {
  final VenueDetailModel venue;

  const VenueInfoCard({super.key, required this.venue});

  Future<void> _launchUrl(String urlString) async {
    final uri = Uri.parse(urlString);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.cardLight,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.05),
            offset: const Offset(0, 4),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Name and Rating
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  venue.name,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textPrimary,
                    height: 1.2,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.warning.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.star_rounded, color: AppColors.warning, size: 18),
                    const SizedBox(width: 4),
                    Text(
                      venue.rating.toStringAsFixed(1),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.warning,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          // Address
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.location_on_outlined, color: AppColors.textSecondary, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '${venue.address}, ${venue.ward}, ${venue.district}, ${venue.city}',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    height: 1.4,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Contact Links (Phone, Facebook, Zalo, etc.)
          _buildContactLinks(),
          
          if (venue.description != null && venue.description!.isNotEmpty) ...[
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Divider(color: AppColors.borderLight),
            ),
             const Text(
              'Giới thiệu',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              venue.description!,
              style: const TextStyle(
                color: AppColors.textSecondary,
                height: 1.6,
                fontSize: 14,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildContactLinks() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          if (venue.phone != null) ...[
            _IconLinkPair(
              icon: Icons.phone_rounded,
              color: AppColors.primaryLightBrand,
              label: 'Gọi điện',
              onTap: () => _launchUrl('tel:${venue.phone}'),
            ),
            const SizedBox(width: 16),
          ],
          if (venue.fbUrl != null) ...[
            _IconLinkPair(
              icon: Icons.facebook_rounded,
              color: AppColors.facebook,
              label: 'Facebook',
              onTap: () => _launchUrl(venue.fbUrl!),
            ),
            const SizedBox(width: 16),
          ],
          if (venue.zaloUrl != null) ...[
            _IconLinkPair(
              icon: Icons.message_rounded,
              color: AppColors.info, // closest to zalo blue
              label: 'Zalo',
              onTap: () => _launchUrl(venue.zaloUrl!),
            ),
          ],
        ],
      ),
    );
  }
}

class _IconLinkPair extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final VoidCallback onTap;

  const _IconLinkPair({
    required this.icon,
    required this.color,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
