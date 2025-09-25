
// Model classes
enum BookingStatus { pending, confirmed, completed, cancelled, noShow }

class BookingModel {
  final String id;
  final String venue;
  final String address;
  final DateTime date;
  final String timeStart;
  final String timeEnd;
  final BookingStatus status;
  final double price;
  final int duration;
  final String imageUrl;
  final String category;
  final int playerCount;
  final bool isPaid;

  BookingModel({
    required this.id,
    required this.venue,
    required this.address,
    required this.date,
    required this.timeStart,
    required this.timeEnd,
    required this.status,
    required this.price,
    required this.duration,
    required this.imageUrl,
    required this.category,
    required this.playerCount,
    required this.isPaid,
  });

  BookingModel copyWith({
    String? id,
    String? venue,
    String? address,
    DateTime? date,
    String? timeStart,
    String? timeEnd,
    BookingStatus? status,
    double? price,
    int? duration,
    String? imageUrl,
    String? category,
    int? playerCount,
    bool? isPaid,
  }) {
    return BookingModel(
      id: id ?? this.id,
      venue: venue ?? this.venue,
      address: address ?? this.address,
      date: date ?? this.date,
      timeStart: timeStart ?? this.timeStart,
      timeEnd: timeEnd ?? this.timeEnd,
      status: status ?? this.status,
      price: price ?? this.price,
      duration: duration ?? this.duration,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
      playerCount: playerCount ?? this.playerCount,
      isPaid: isPaid ?? this.isPaid,
    );
  }
}
