import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../home/presentation/widgets/list_venue.dart';
import '../../../home/presentation/widgets/nearby_venues_section.dart';
import '../../../my_booking/data/models/amenities.dart';
import '../../../my_booking/data/models/venue.dart';
import '../../../my_booking/data/models/venue_images.dart';
import '../../../my_booking/data/models/venue_rules.dart';

class SearchResultList extends StatefulWidget {
  final String? selectedType;
  final String? selectedDistrict;
  final TextEditingController searchController;

  const SearchResultList({
    super.key,
    required this.selectedType,
    required this.selectedDistrict,
    required this.searchController,
  });

  @override
  State<SearchResultList> createState() => _SearchResultListState();
}

class _SearchResultListState extends State<SearchResultList> {
  final List<Venue> venues = [
    // 1. Sân Thành Phát
    Venue(
      venueName: "Sân Bóng Đá Mini Thành Phát",
      description:
      "Sân bóng đá mini 5-7 người với cỏ nhân tạo chất lượng cao, hệ thống chiếu sáng hiện đại và nhiều tiện ích.",
      address: "123 Lê Văn Lương, Thanh Xuân, Hà Nội",
      latitude: "21.038132",
      longitude: "105.770574",
      phone: "0123456789",
      email: "thanhphat@gmail.com",
      categoryId: 1,
      capacity: 14,
      status: "active",
      averageRating: "4.5",
      totalReviews: 128,
      totalBookings: 450,
      images: [
        VenueImages(
          imageUrl:
          "https://www.sporta.vn/wp-content/uploads/2019/09/san-bong-da-mini-co-nhan-tao-5.jpg",
        ),
        VenueImages(
          imageUrl:
          "https://www.sporta.vn/wp-content/uploads/2019/09/san-bong-da-mini-co-nhan-tao-1.jpg",
        ),
        VenueImages(
          imageUrl:
          "https://photo.znews.vn/w660/Uploaded/mdf_eioxrd/2021_07_06/2.jpg",
        ),
      ],
    ),

    // 2. Sân Hoàng Gia
    Venue(
      venueName: "Sân Bóng Đá Hoàng Gia",
      description:
      "Sân bóng đá mini chất lượng cao, bãi đỗ xe rộng, vị trí thuận tiện, giá thuê hợp lý.",
      address: "45 Nguyễn Trãi, Thanh Xuân, Hà Nội",
      latitude: "21.020451",
      longitude: "105.812341",
      phone: "0909123456",
      email: "hoanggia@gmail.com",
      categoryId: 1,
      capacity: 12,
      status: "active",
      averageRating: "4.7",
      totalReviews: 200,
      totalBookings: 520,
      images: [
        VenueImages(
          imageUrl:
          "https://media.techcombank.com/uploads/2024/02/20/san-bong-mini-1.jpg",
        ),
        VenueImages(
          imageUrl:
          "https://cdn.tgdd.vn/Files/2019/10/11/1209436/cac-kich-thuoc-san-bong-da-11-7-5-nguoi---the-thao-1.jpg",
        ),
        VenueImages(
          imageUrl:
          "https://bazantech.vn/wp-content/uploads/2022/08/san-bong-da-mini-7-nguoi-1.jpg",
        ),
      ],
    ),

    // 3. Sân Sao Mai
    Venue(
      venueName: "Sân Bóng Đá Sao Mai",
      description:
      "Sân bóng rộng, nền cỏ xanh đẹp, thích hợp cho các giải đấu phong trào, có khu nghỉ và phòng thay đồ.",
      address: "88 Trần Duy Hưng, Cầu Giấy, Hà Nội",
      latitude: "21.008912",
      longitude: "105.800342",
      phone: "0988223344",
      email: "saomai@gmail.com",
      categoryId: 1,
      capacity: 16,
      status: "active",
      averageRating: "4.6",
      totalReviews: 150,
      totalBookings: 480,
      images: [
        VenueImages(
          imageUrl:
          "https://cdn.alongwalk.info/vn/wp-content/uploads/2022/03/07185311/image-review-7-san-bong-da-mini-o-quan-9-chat-luong-va-gia-tot-nhat-164665039144986.jpg",
        ),
        VenueImages(
          imageUrl:
          "https://danangagri.com/wp-content/uploads/2023/05/san-bong-da-7-nguoi-1.jpg",
        ),
        VenueImages(
          imageUrl:
          "https://vin turf.vn/wp-content/uploads/2023/07/san-bong-da-5-nguoi.jpg",
        ),
      ],
    ),
  ];


  @override
  Widget build(BuildContext context) {
    // final venueController = Get.find<VenueController>();
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        child:
        // SizedBox()
        // Obx(() {
        //   final filteredVenues = venueController.listVenue
        //       .where((venue) {
        //         final matchesType = selectedType == null;
        //         final matchesDistrict = selectedDistrict == null;
        //         final matchesSearch = searchController.text.isEmpty ||
        //             (venue.venueName ?? '')
        //                 .toLowerCase()
        //                 .contains(searchController.text.toLowerCase());
        //         return matchesType && matchesDistrict && matchesSearch;
        //       })
        //       .toList();
        //
        //   if (filteredVenues.isEmpty) {
        //     return Center(child: Text("Không có kết quả phù hợp"));
        //   }
        //   return ListVenue(venues: filteredVenues);
        // }),
        ListVenue(venues: venues)
      ),
    );
  }
}
