import 'package:dat_san_247_mobile/features/details/presentation/pages/details_page.dart';
import 'package:dat_san_247_mobile/features/home/presentation/widgets/nearby_venues_section.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';

class FeaturedVenuesSection extends StatefulWidget {
  const FeaturedVenuesSection({super.key});

  @override
  State<FeaturedVenuesSection> createState() => _FeaturedVenuesSectionState();
}

class _FeaturedVenuesSectionState extends State<FeaturedVenuesSection> {
  final List<VenueCardItem> nearbyVenues = [
    VenueCardItem(
      name: "Sân bóng Mỹ Đình",
      address: "Nam Từ Liêm, Hà Nội",
      price: 200000,
      rating: 4.8,
      reviewCount: 156,
      imageUrl:
          "https://images.unsplash.com/photo-1574629810360-7efbbe195018?w=400",
      distance: "2.1 km",
      isPromoted: true,
    ),
    VenueCardItem(
      name: "Sân cầu lông Thanh Xuân",
      address: "Thanh Xuân, Hà Nội",
      price: 80000,
      rating: 4.6,
      reviewCount: 89,
      imageUrl:
          "https://images.unsplash.com/photo-1551698618-1dfe5d97d256?w=400",
      distance: "1.5 km",
    ),
    VenueCardItem(
      name: "Sân tennis Hoàng Mai",
      address: "Hoàng Mai, Hà Nội",
      price: 150000,
      rating: 4.7,
      reviewCount: 134,
      imageUrl:
          "https://images.unsplash.com/photo-1579952363873-27d3bfad9c0d?w=400",
      distance: "3.2 km",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.orange[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.star, color: Colors.orange[600], size: 16),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Sân nổi bật',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3748),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: nearbyVenues
                  .map(
                    (venue) => Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: _buildHorizontalVenueCard(venue, theme),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHorizontalVenueCard(VenueCardItem venue, ThemeData theme) {
    return InkWell(
      onTap: () {
        // TODO: Navigate to venue details
        Get.to(() => DetailsPage(venueId: 4));
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 15,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Stack(
              children: [
                ClipRRect(
                  // borderRadius: BorderRadius.circular(16), // Bo đều 4 góc
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                  ), // Bo đều 2 góc bên trái
                  child: Image.network(
                    venue.imageUrl,
                    width: 120,
                    height: 120,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        Icons.image_not_supported,
                        color: Colors.grey[400],
                        size: 32,
                      ),
                    ),
                  ),
                ),

                if (venue.isPromoted)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.red.withOpacity(0.2),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Text(
                        'KHUYẾN MÃI',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 10, left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            venue.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2D3748),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: Icon(
                            Icons.favorite_border,
                            color: Colors.grey[400],
                            size: 20,
                          ),
                          onPressed: () {},
                        ),
                      ],
                    ),

                    const SizedBox(height: 4),

                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 14,
                          color: Colors.grey[500],
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            venue.address,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[600],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    Row(
                      children: [
                        Icon(
                          Icons.near_me,
                          size: 14,
                          color: theme.primaryColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          venue.distance,
                          style: TextStyle(
                            fontSize: 13,
                            color: theme.primaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              size: 16,
                              color: Colors.amber[600],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${venue.rating} (${venue.reviewCount})',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: theme.primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${NumberFormat('#,##0').format(venue.price)}đ/h',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: theme.primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
