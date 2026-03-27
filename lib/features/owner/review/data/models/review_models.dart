import 'package:freezed_annotation/freezed_annotation.dart';

part 'review_models.freezed.dart';
part 'review_models.g.dart';

@freezed
abstract class OwnerReviewModel with _$OwnerReviewModel {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory OwnerReviewModel({
    required String id,
    required String bookingId,
    required String venueId,
    String? courtId,
    required String userId,
    required String reviewerName,
    String? reviewerAvatar,
    required int rating,
    int? ratingCleanliness,
    int? ratingFacilities,
    int? ratingStaff,
    String? comment,
    String? response,
    String? respondedBy,
    DateTime? respondedAt,
    @Default(true) bool isVisible,
    required DateTime createdAt,
  }) = _OwnerReviewModel;

  const OwnerReviewModel._();

  bool get hasResponse => response != null && response!.isNotEmpty;

  double get avgSubRating {
    final scores = [ratingCleanliness, ratingFacilities, ratingStaff]
        .where((s) => s != null)
        .cast<int>()
        .toList();
    if (scores.isEmpty) return rating.toDouble();
    return scores.fold(0, (a, b) => a + (b as int)) / scores.length;
  }

  factory OwnerReviewModel.fromJson(Map<String, dynamic> json) =>
      _$OwnerReviewModelFromJson(json);

  Map<String, dynamic> toJson();
}
