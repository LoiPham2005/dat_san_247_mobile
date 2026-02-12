
import '../../../my_booking/data/models/venue.dart';

class VenueStatistic {
  final int statId;
  final int venueId;
  final String date;
  final int totalViews;
  final int totalBookings;
  final double totalRevenue;
  final double commissionEarned;
  final double averageRating;
  final int totalFavorites;
  final int totalMessages;
  final double cancellationRate;
  final int responseTimeAvg;
  final DateTime createdAt;

  // Optional: nếu bạn muốn lấy Venue luôn trong response
  final Venue? venue;

  VenueStatistic({
    required this.statId,
    required this.venueId,
    required this.date,
    required this.totalViews,
    required this.totalBookings,
    required this.totalRevenue,
    required this.commissionEarned,
    required this.averageRating,
    required this.totalFavorites,
    required this.totalMessages,
    required this.cancellationRate,
    required this.responseTimeAvg,
    required this.createdAt,
    this.venue,
  });

  // JSON -> Dart object
  factory VenueStatistic.fromJson(Map<String, dynamic> json) {
    return VenueStatistic(
      statId: json['stat_id'] ?? 0,
      venueId: json['venue_id'] ?? 0,
      date: json['date'] ?? '',
      totalViews: json['total_views'] ?? 0,
      totalBookings: json['total_bookings'] ?? 0,
      totalRevenue: (json['total_revenue'] ?? 0).toDouble(),
      commissionEarned: (json['commission_earned'] ?? 0).toDouble(),
      averageRating: (json['average_rating'] ?? 0).toDouble(),
      totalFavorites: json['total_favorites'] ?? 0,
      totalMessages: json['total_messages'] ?? 0,
      cancellationRate: (json['cancellation_rate'] ?? 0).toDouble(),
      responseTimeAvg: json['response_time_avg'] ?? 0,
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      venue: json['venue'] != null ? Venue.fromJson(json['venue']) : null,
    );
  }

  // Dart object -> JSON
  Map<String, dynamic> toJson() {
    return {
      'stat_id': statId,
      'venue_id': venueId,
      'date': date,
      'total_views': totalViews,
      'total_bookings': totalBookings,
      'total_revenue': totalRevenue,
      'commission_earned': commissionEarned,
      'average_rating': averageRating,
      'total_favorites': totalFavorites,
      'total_messages': totalMessages,
      'cancellation_rate': cancellationRate,
      'response_time_avg': responseTimeAvg,
      'created_at': createdAt.toIso8601String(),
      'venue': venue?.toJson(),
    };
  }
}
