import 'package:dat_san_247_mobile/features/venue/data/models/venue.dart';

class VenueImages {
  int? imageId;
  int? venueId;
  // Venue? venue;
  String? imageUrl;
  String? imageType;
  String? description;
  int? displayOrder;
  String? createdAt;

  VenueImages(
      {this.imageId,
      this.venueId,
      // this.venue,
      this.imageUrl,
      this.imageType,
      this.description,
      this.displayOrder,
      this.createdAt});

  VenueImages.fromJson(Map<String, dynamic> json) {
    imageId = json['imageId'];
    venueId = json['venueId'];
    // venue = json['venue'] != null ? new Venue.fromJson(json['venue']) : null;
    imageUrl = json['imageUrl'];
    imageType = json['imageType'];
    description = json['description'];
    displayOrder = json['displayOrder'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['imageId'] = this.imageId;
    data['venueId'] = this.venueId;
    // if (this.venue != null) {
    //   data['venue'] = this.venue!.toJson();
    // }
    data['imageUrl'] = this.imageUrl;
    data['imageType'] = this.imageType;
    data['description'] = this.description;
    data['displayOrder'] = this.displayOrder;
    data['createdAt'] = this.createdAt;
    return data;
  }
}