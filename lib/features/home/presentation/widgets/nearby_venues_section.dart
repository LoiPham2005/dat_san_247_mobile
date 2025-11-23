import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NearbyVenuesSection extends StatefulWidget {
  const NearbyVenuesSection({super.key});

  @override
  State<NearbyVenuesSection> createState() => _NearbyVenuesSectionState();
}

class _NearbyVenuesSectionState extends State<NearbyVenuesSection> {
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
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Icons.near_me, color: theme.primaryColor, size: 20),
                const SizedBox(width: 8),
                const Text(
                  'Sân gần bạn',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3748),
                  ),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: () {},
                  icon: Icon(
                    Icons.arrow_forward_ios,
                    size: 14,
                    color: theme.primaryColor,
                  ),
                  label: Text(
                    'Xem tất cả',
                    style: TextStyle(
                      color: theme.primaryColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          SizedBox(
            height: 330,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              itemCount: nearbyVenues.length,
              itemBuilder: (context, index) {
                final venue = nearbyVenues[index];
                return Container(
                  width: 240,
                  margin: EdgeInsets.only(
                    right: index == nearbyVenues.length - 1 ? 0 : 10,
                  ),
                  child: _buildVenueCard(venue, theme),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVenueCard(VenueCardItem venue, ThemeData theme) {
    return InkWell(
      onTap: () {
        // TODO: Navigate to venue details
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 15,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  child: Image.network(
                    venue.imageUrl,
                    width: double.infinity,
                    height: 170,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: double.infinity,
                      height: 170,
                      color: Colors.grey[200],
                      child: Icon(
                        Icons.image_not_supported,
                        color: Colors.grey[400],
                        size: 48,
                      ),
                    ),
                  ),
                ),

                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: Colors.white,
                          size: 12,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          venue.distance,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                if (venue.isPromoted)
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'HOT',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                Positioned(
                  bottom: 8,
                  right: 8,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: Icon(
                        Icons.favorite_border,
                        color: theme.primaryColor,
                        size: 16,
                      ),
                      onPressed: () {},
                    ),
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    venue.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D3748),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 6),

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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.star, size: 14, color: Colors.amber[600]),
                          const SizedBox(width: 4),
                          Text(
                            '${venue.rating}',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            ' (${venue.reviewCount})',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),

                      Text(
                        '${NumberFormat('#,##0').format(venue.price)}đ/h',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: theme.primaryColor,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 22),

                  SizedBox(
                    width: double.infinity,
                    height: 36,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Đặt ngay',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class VenueCardItem {
  final String name;
  final String address;
  final double price;
  final double rating;
  final int reviewCount;
  final String imageUrl;
  final String distance;
  final bool isPromoted;

  VenueCardItem({
    required this.name,
    required this.address,
    required this.price,
    required this.rating,
    required this.reviewCount,
    required this.imageUrl,
    required this.distance,
    this.isPromoted = false,
  });
}
