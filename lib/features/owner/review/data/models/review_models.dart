// // ══════════════════════════════════════════════════════════════════════════════
// // reviews model — O-12
// // DB: reviews (venue_id), users (reviewer)
// // ══════════════════════════════════════════════════════════════════════════════
// class OwnerReviewModel {
//   final String id;
//   final String bookingId;
//   final String venueId;
//   final String? courtId;
//   final String userId;
//   final String reviewerName;
//   final String? reviewerAvatar;

//   final int rating;
//   final int? ratingCleanliness;
//   final int? ratingFacilities;
//   final int? ratingStaff;
//   final String? comment;

//   final String? response;
//   final String? respondedBy;
//   final DateTime? respondedAt;

//   final bool isVisible;
//   final DateTime createdAt;

//   const OwnerReviewModel({
//     required this.id,
//     required this.bookingId,
//     required this.venueId,
//     this.courtId,
//     required this.userId,
//     required this.reviewerName,
//     this.reviewerAvatar,
//     required this.rating,
//     this.ratingCleanliness,
//     this.ratingFacilities,
//     this.ratingStaff,
//     this.comment,
//     this.response,
//     this.respondedBy,
//     this.respondedAt,
//     this.isVisible = true,
//     required this.createdAt,
//   });

//   bool get hasResponse => response != null && response!.isNotEmpty;
//   double get avgSubRating {
//     final scores = [ratingCleanliness, ratingFacilities, ratingStaff]
//         .where((s) => s != null).cast<int>().toList();
//     if (scores.isEmpty) return rating.toDouble();
//     return scores.fold(0, (a, b) => a + b) / scores.length;
//   }
// }
