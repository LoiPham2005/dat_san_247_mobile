import 'package:freezed_annotation/freezed_annotation.dart';

part 'venue_filter_params.freezed.dart';
part 'venue_filter_params.g.dart';

@freezed
abstract class VenueFilterParams with _$VenueFilterParams {
  const factory VenueFilterParams({
    String? sportType,
    String? city,
    String? district,
    double? minPrice,
    double? maxPrice,
    DateTime? availableDate,
    String? availableStartTime,
    String? availableEndTime,
    @Default([]) List<String> amenities,
  }) = _VenueFilterParams;

  factory VenueFilterParams.fromJson(Map<String, dynamic> json) => _$VenueFilterParamsFromJson(json);
}
