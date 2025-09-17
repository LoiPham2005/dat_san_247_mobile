import 'package:dat_san_247_mobile/core/utils/extensions/int_ext.dart';
import 'package:dat_san_247_mobile/core/widgets/custom_image.dart';
import 'package:dat_san_247_mobile/features/my_booking/data/models/venue.dart';
import 'package:flutter/material.dart';

class ListVenue extends StatelessWidget {
  final List<Venue> venues;
  const ListVenue({super.key, required this.venues});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: venues.length,
      separatorBuilder: (context, index) => 16.height,
      itemBuilder: (context, index) {
        final venue = venues[index];
        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          margin: EdgeInsets.symmetric(horizontal: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Ảnh sân
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                child: CustomImage(
                  // imageUrl: venue.images?.isNotEmpty == true
                  //     ? venue.images!.first.imageUrl ?? ''
                  //     : '',
                  imageUrl:
                      "https://photo.znews.vn/w660/Uploaded/mdf_eioxrd/2021_07_06/2.jpg",
                  height: 140,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tên sân
                    Text(
                      venue.venueName ?? 'Chưa có tên',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff2d5533),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8),
                    // Địa chỉ
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 16,
                          color: Color(0xff62b766),
                        ),
                        SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            venue.address ?? 'Chưa có địa chỉ',
                            style: TextStyle(color: Colors.grey[700]),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    // Đánh giá
                    Row(
                      children: [
                        Icon(Icons.star, size: 16, color: Colors.amber),
                        SizedBox(width: 4),
                        Text(
                          venue.averageRating ?? '0.0',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          ' (${venue.totalReviews ?? 0} đánh giá)',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    // Tiện ích
                    if (venue.amenities != null && venue.amenities!.isNotEmpty)
                      Wrap(
                        spacing: 8,
                        children: venue.amenities!
                            .where((amenity) => amenity.available == true)
                            .map(
                              (amenity) => Chip(
                                label: Text(
                                  amenity.name ?? '',
                                  style: TextStyle(fontSize: 12),
                                ),
                                backgroundColor: Color(
                                  0xff62b766,
                                ).withOpacity(0.12),
                              ),
                            )
                            .toList(),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
