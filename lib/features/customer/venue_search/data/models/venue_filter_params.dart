import 'package:equatable/equatable.dart';

class VenueFilterParams extends Equatable {
  final String? sportType;
  final String? city;
  final String? district;
  final double? minPrice;
  final double? maxPrice;
  final DateTime? availableDate;
  final String? availableStartTime;
  final String? availableEndTime;
  final List<String> amenities;

  const VenueFilterParams({
    this.sportType,
    this.city,
    this.district,
    this.minPrice,
    this.maxPrice,
    this.availableDate,
    this.availableStartTime,
    this.availableEndTime,
    this.amenities = const [],
  });

  VenueFilterParams copyWith({
    String? sportType,
    String? city,
    String? district,
    double? minPrice,
    double? maxPrice,
    DateTime? availableDate,
    String? availableStartTime,
    String? availableEndTime,
    List<String>? amenities,
  }) {
    return VenueFilterParams(
      sportType: sportType ?? this.sportType,
      city: city ?? this.city,
      district: district ?? this.district,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      availableDate: availableDate ?? this.availableDate,
      availableStartTime: availableStartTime ?? this.availableStartTime,
      availableEndTime: availableEndTime ?? this.availableEndTime,
      amenities: amenities ?? this.amenities,
    );
  }
  
  // Clear method to reset a specific field or all fields
  VenueFilterParams clear() => const VenueFilterParams();

  @override
  List<Object?> get props => [
        sportType,
        city,
        district,
        minPrice,
        maxPrice,
        availableDate,
        availableStartTime,
        availableEndTime,
        amenities,
      ];
}
