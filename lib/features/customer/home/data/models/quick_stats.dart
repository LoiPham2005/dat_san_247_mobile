class QuickStats {
  final int totalVenues;
  final int totalBookingsToday;
  final int totalUsers;

  QuickStats({
    required this.totalVenues,
    required this.totalBookingsToday,
    required this.totalUsers,
  });

  // JSON -> Dart object
  factory QuickStats.fromJson(Map<String, dynamic> json) {
    return QuickStats(
      totalVenues: json['totalVenues'] ?? 0,
      totalBookingsToday: json['totalBookingsToday'] ?? 0,
      totalUsers: json['totalUsers'] ?? 0,
    );
  }

  // Dart object -> JSON
  Map<String, dynamic> toJson() {
    return {
      'totalVenues': totalVenues,
      'totalBookingsToday': totalBookingsToday,
      'totalUsers': totalUsers,
    };
  }
}
