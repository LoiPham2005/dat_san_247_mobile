import 'package:equatable/equatable.dart';

// ══════════════════════════════════════════════════════════════════════════════
// Owner Data Models — từ schema.prisma
// ══════════════════════════════════════════════════════════════════════════════

// ── VenueStatus enum (schema.prisma) ─────────────────────────────────────────
enum VenueStatus { PENDING, APPROVED, REJECTED, SUSPENDED }

extension VenueStatusExt on VenueStatus {
  String get label => switch (this) {
        VenueStatus.PENDING => 'Chờ duyệt',
        VenueStatus.APPROVED => 'Đã duyệt',
        VenueStatus.REJECTED => 'Bị từ chối',
        VenueStatus.SUSPENDED => 'Bị tạm khóa',
      };
}

// ── CourtSurfaceType enum ─────────────────────────────────────────────────────
enum CourtSurfaceType { GRASS, ARTIFICIAL_GRASS, CONCRETE, WOOD, CLAY, RUBBER, OTHER }

extension CourtSurfaceTypeExt on CourtSurfaceType {
  String get label => switch (this) {
        CourtSurfaceType.GRASS => 'Sân cỏ tự nhiên',
        CourtSurfaceType.ARTIFICIAL_GRASS => 'Sân cỏ nhân tạo',
        CourtSurfaceType.CONCRETE => 'Sân bê tông',
        CourtSurfaceType.WOOD => 'Sân gỗ',
        CourtSurfaceType.CLAY => 'Sân đất nện',
        CourtSurfaceType.RUBBER => 'Sân cao su',
        CourtSurfaceType.OTHER => 'Khác',
      };
}

// ── VerificationStatus ────────────────────────────────────────────────────────
enum VerificationStatus { PENDING, APPROVED, REJECTED }

// ── DayOfWeek ────────────────────────────────────────────────────────────────
enum OwnerDayOfWeek { MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY, SATURDAY, SUNDAY }

extension OwnerDayOfWeekExt on OwnerDayOfWeek {
  String get short => switch (this) {
        OwnerDayOfWeek.MONDAY => 'T2',
        OwnerDayOfWeek.TUESDAY => 'T3',
        OwnerDayOfWeek.WEDNESDAY => 'T4',
        OwnerDayOfWeek.THURSDAY => 'T5',
        OwnerDayOfWeek.FRIDAY => 'T6',
        OwnerDayOfWeek.SATURDAY => 'T7',
        OwnerDayOfWeek.SUNDAY => 'CN',
      };
  bool get isWeekend => this == OwnerDayOfWeek.SATURDAY || this == OwnerDayOfWeek.SUNDAY;
}

// ══════════════════════════════════════════════════════════════════════════════
// venues model  — O-02 / O-03
// ══════════════════════════════════════════════════════════════════════════════
class OwnerVenueModel extends Equatable {
  final String id;
  final String ownerId; // venues.owner_id
  final String name; // @db.VarChar(255)
  final String slug; // @unique @db.VarChar(255)
  final String? description; // @db.Text
  final String address; // @db.VarChar(500)
  final String city; // @db.VarChar(100)
  final String district; // @db.VarChar(100)
  final String? ward; // @db.VarChar(100)
  final String? phone; // @db.VarChar(20)
  final String? email; // @db.VarChar(255)
  final String? thumbnailUrl; // @db.VarChar(500)

  // Social links
  final String? fbUrl;
  final String? instagramUrl;
  final String? zaloUrl;
  final String? youtubeUrl;

  final VenueStatus status; // @default(PENDING)
  final String? rejectionReason;
  final bool isActive; // @default(true)
  final bool isFeatured; // @default(false)

  // Ratings (denormalized)
  final double rating; // @db.Decimal(3,2)
  final double ratingCleanliness;
  final double ratingFacilities;
  final double ratingStaff;
  final int totalReviews;

  // Business config
  final double commissionRate; // @db.Decimal(5,2)
  final double vatRate; // @db.Decimal(5,2)
  final bool autoAcceptBookings; // @default(true)
  final int minBookingHours; // @default(1)
  final int maxBookingHours; // @default(24)
  final int minBookingBeforeHours; // @default(0)
  final int cancellationBeforeHours; // @default(24)

  final DateTime? approvedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Joined / computed
  final int courtCount; // COUNT courts WHERE is_active=true
  final List<String> sportTypes; // sport_assignments.sport_type

  const OwnerVenueModel({
    required this.id,
    required this.ownerId,
    required this.name,
    required this.slug,
    this.description,
    required this.address,
    required this.city,
    required this.district,
    this.ward,
    this.phone,
    this.email,
    this.thumbnailUrl,
    this.fbUrl,
    this.instagramUrl,
    this.zaloUrl,
    this.youtubeUrl,
    required this.status,
    this.rejectionReason,
    this.isActive = true,
    this.isFeatured = false,
    this.rating = 0,
    this.ratingCleanliness = 0,
    this.ratingFacilities = 0,
    this.ratingStaff = 0,
    this.totalReviews = 0,
    this.commissionRate = 0,
    this.vatRate = 0,
    this.autoAcceptBookings = true,
    this.minBookingHours = 1,
    this.maxBookingHours = 24,
    this.minBookingBeforeHours = 0,
    this.cancellationBeforeHours = 24,
    this.approvedAt,
    required this.createdAt,
    required this.updatedAt,
    this.courtCount = 0,
    this.sportTypes = const [],
  });

  factory OwnerVenueModel.fromJson(Map<String, dynamic> j) => OwnerVenueModel(
        id: j['id'],
        ownerId: j['owner_id'],
        name: j['name'],
        slug: j['slug'],
        description: j['description'],
        address: j['address'],
        city: j['city'],
        district: j['district'],
        ward: j['ward'],
        phone: j['phone'],
        email: j['email'],
        thumbnailUrl: j['thumbnail_url'],
        fbUrl: j['fb_url'],
        instagramUrl: j['instagram_url'],
        zaloUrl: j['zalo_url'],
        youtubeUrl: j['youtube_url'],
        status: VenueStatus.values
            .firstWhere((e) => e.name == j['status'], orElse: () => VenueStatus.PENDING),
        rejectionReason: j['rejection_reason'],
        isActive: j['is_active'] ?? true,
        isFeatured: j['is_featured'] ?? false,
        rating: (j['rating'] as num?)?.toDouble() ?? 0,
        ratingCleanliness: (j['rating_cleanliness'] as num?)?.toDouble() ?? 0,
        ratingFacilities: (j['rating_facilities'] as num?)?.toDouble() ?? 0,
        ratingStaff: (j['rating_staff'] as num?)?.toDouble() ?? 0,
        totalReviews: j['total_reviews'] ?? 0,
        commissionRate: (j['commission_rate'] as num?)?.toDouble() ?? 0,
        vatRate: (j['vat_rate'] as num?)?.toDouble() ?? 0,
        autoAcceptBookings: j['auto_accept_bookings'] ?? true,
        minBookingHours: j['min_booking_hours'] ?? 1,
        maxBookingHours: j['max_booking_hours'] ?? 24,
        minBookingBeforeHours: j['min_booking_before_hours'] ?? 0,
        cancellationBeforeHours: j['cancellation_before_hours'] ?? 24,
        approvedAt: j['approved_at'] != null ? DateTime.tryParse(j['approved_at']) : null,
        createdAt: DateTime.parse(j['created_at']),
        updatedAt: DateTime.parse(j['updated_at']),
        courtCount: j['_count']?['courts'] ?? 0,
        sportTypes: List<String>.from(j['sport_assignments']?.map((s) => s['sport_type']) ?? []),
      );

  @override
  List<Object?> get props => [id];
}

// ══════════════════════════════════════════════════════════════════════════════
// venue_operating_hours — O-03
// ══════════════════════════════════════════════════════════════════════════════
class VenueOperatingHoursModel extends Equatable {
  final String id;
  final String venueId;
  final OwnerDayOfWeek dayOfWeek; // DayOfWeek
  final String openingTime; // @db.Time(6) → HH:mm
  final String closingTime; // @db.Time(6) → HH:mm
  final bool isClosed; // @default(false)

  const VenueOperatingHoursModel({
    required this.id,
    required this.venueId,
    required this.dayOfWeek,
    required this.openingTime,
    required this.closingTime,
    this.isClosed = false,
  });

  factory VenueOperatingHoursModel.fromJson(Map<String, dynamic> j) => VenueOperatingHoursModel(
        id: j['id'],
        venueId: j['venue_id'],
        dayOfWeek: OwnerDayOfWeek.values
            .firstWhere((e) => e.name == j['day_of_week'], orElse: () => OwnerDayOfWeek.MONDAY),
        openingTime: _pt(j['opening_time']),
        closingTime: _pt(j['closing_time']),
        isClosed: j['is_closed'] ?? false,
      );

  static String _pt(dynamic t) {
    if (t == null) return '00:00';
    final s = t.toString();
    if (s.contains('T')) {
      final dt = DateTime.tryParse(s);
      if (dt != null)
        return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    }
    return s.length >= 5 ? s.substring(0, 5) : s;
  }

  @override
  List<Object?> get props => [id, dayOfWeek];
}

// ══════════════════════════════════════════════════════════════════════════════
// venue_schedule_exceptions — O-03
// ══════════════════════════════════════════════════════════════════════════════
class VenueScheduleExceptionModel extends Equatable {
  final String id;
  final String venueId;
  final DateTime date; // @db.Date
  final bool isClosed; // @default(true)
  final String? openTime; // @db.Time(6) — HH:mm
  final String? closeTime; // @db.Time(6) — HH:mm
  final String? reason; // @db.VarChar(255)
  final DateTime createdAt;

  const VenueScheduleExceptionModel({
    required this.id,
    required this.venueId,
    required this.date,
    this.isClosed = true,
    this.openTime,
    this.closeTime,
    this.reason,
    required this.createdAt,
  });

  factory VenueScheduleExceptionModel.fromJson(Map<String, dynamic> j) =>
      VenueScheduleExceptionModel(
        id: j['id'],
        venueId: j['venue_id'],
        date: DateTime.parse(j['date']),
        isClosed: j['is_closed'] ?? true,
        openTime: j['open_time'] != null ? VenueOperatingHoursModel._pt(j['open_time']) : null,
        closeTime: j['close_time'] != null ? VenueOperatingHoursModel._pt(j['close_time']) : null,
        reason: j['reason'],
        createdAt: DateTime.parse(j['created_at']),
      );

  @override
  List<Object?> get props => [id, date];
}

// ══════════════════════════════════════════════════════════════════════════════
// amenities — O-03 / O-04
// ══════════════════════════════════════════════════════════════════════════════
class AmenityModel extends Equatable {
  final String id;
  final String? venueId; // xOR court_id
  final String? courtId;
  final String name; // @db.VarChar(100)
  final String? icon; // @db.VarChar(100)
  final bool isFree; // @default(true)

  const AmenityModel({
    required this.id,
    this.venueId,
    this.courtId,
    required this.name,
    this.icon,
    this.isFree = true,
  });

  factory AmenityModel.fromJson(Map<String, dynamic> j) => AmenityModel(
        id: j['id'],
        venueId: j['venue_id'],
        courtId: j['court_id'],
        name: j['name'],
        icon: j['icon'],
        isFree: j['is_free'] ?? true,
      );

  @override
  List<Object?> get props => [id];
}

// ══════════════════════════════════════════════════════════════════════════════
// courts model — O-04
// ══════════════════════════════════════════════════════════════════════════════
class OwnerCourtModel extends Equatable {
  final String id;
  final String venueId; // courts.venue_id
  final String name; // @db.VarChar(255)
  final String? description; // @db.Text
  final double pricePerHour; // @db.Decimal(10,2)
  final CourtSurfaceType? surfaceType; // CourtSurfaceType?
  final String? size; // @db.VarChar(50) e.g. "7x14m"
  final bool isIndoor; // @default(false)
  final bool isActive; // @default(true)
  final int displayOrder; // @default(0)
  final String? thumbnailUrl; // @db.VarChar(500)
  final List<String> sportTypes; // sport_assignments.sport_type
  final List<AmenityModel> amenities;
  final DateTime createdAt;
  final DateTime updatedAt;

  const OwnerCourtModel({
    required this.id,
    required this.venueId,
    required this.name,
    this.description,
    required this.pricePerHour,
    this.surfaceType,
    this.size,
    this.isIndoor = false,
    this.isActive = true,
    this.displayOrder = 0,
    this.thumbnailUrl,
    this.sportTypes = const [],
    this.amenities = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  factory OwnerCourtModel.fromJson(Map<String, dynamic> j) => OwnerCourtModel(
        id: j['id'],
        venueId: j['venue_id'],
        name: j['name'],
        description: j['description'],
        pricePerHour: (j['price_per_hour'] as num).toDouble(),
        surfaceType: j['surface_type'] != null
            ? CourtSurfaceType.values.firstWhere((e) => e.name == j['surface_type'],
                orElse: () => CourtSurfaceType.OTHER)
            : null,
        size: j['size'],
        isIndoor: j['is_indoor'] ?? false,
        isActive: j['is_active'] ?? true,
        displayOrder: j['display_order'] ?? 0,
        thumbnailUrl: j['thumbnail_url'],
        sportTypes: List<String>.from(j['sport_assignments']?.map((s) => s['sport_type']) ?? []),
        amenities: (j['amenities'] as List? ?? []).map((a) => AmenityModel.fromJson(a)).toList(),
        createdAt: DateTime.parse(j['created_at']),
        updatedAt: DateTime.parse(j['updated_at']),
      );

  @override
  List<Object?> get props => [id];
}

// ══════════════════════════════════════════════════════════════════════════════
// pricing_rules model — O-05 (reused in VS-09, extended here)
// ══════════════════════════════════════════════════════════════════════════════
class OwnerPricingRuleModel extends Equatable {
  final String id;
  final String courtId; // pricing_rules.court_id
  final String courtName; // joined
  final String? name; // @db.VarChar(100)
  final String? dayOfWeek; // DayOfWeek?
  final String startTime; // @db.Time(6) → HH:mm
  final String endTime;
  final double price; // @db.Decimal(10,2)
  final DateTime? startDate; // @db.Date
  final DateTime? endDate; // @db.Date
  final int priority; // @default(1)
  final bool isActive; // @default(true)
  final DateTime updatedAt;

  const OwnerPricingRuleModel({
    required this.id,
    required this.courtId,
    required this.courtName,
    this.name,
    this.dayOfWeek,
    required this.startTime,
    required this.endTime,
    required this.price,
    this.startDate,
    this.endDate,
    this.priority = 1,
    this.isActive = true,
    required this.updatedAt,
  });

  String get dayLabel {
    const map = {
      'MONDAY': 'T2',
      'TUESDAY': 'T3',
      'WEDNESDAY': 'T4',
      'THURSDAY': 'T5',
      'FRIDAY': 'T6',
      'SATURDAY': 'T7',
      'SUNDAY': 'CN'
    };
    return dayOfWeek != null ? (map[dayOfWeek] ?? dayOfWeek!) : 'Tất cả ngày';
  }

  bool get isPeakHour {
    final h = int.tryParse(startTime.split(':')[0]) ?? 0;
    return h >= 17 && h <= 21;
  }

  bool get isWeekend => dayOfWeek == 'SATURDAY' || dayOfWeek == 'SUNDAY';

  OwnerPricingRuleModel copyWith({String? name, double? price, bool? isActive, int? priority}) =>
      OwnerPricingRuleModel(
        id: id,
        courtId: courtId,
        courtName: courtName,
        name: name ?? this.name,
        dayOfWeek: dayOfWeek,
        startTime: startTime,
        endTime: endTime,
        price: price ?? this.price,
        startDate: startDate,
        endDate: endDate,
        priority: priority ?? this.priority,
        isActive: isActive ?? this.isActive,
        updatedAt: DateTime.now(),
      );

  factory OwnerPricingRuleModel.fromJson(Map<String, dynamic> j) => OwnerPricingRuleModel(
        id: j['id'],
        courtId: j['court_id'],
        courtName: j['courts']?['name'] ?? '',
        name: j['name'],
        dayOfWeek: j['day_of_week'],
        startTime: _pt(j['start_time']),
        endTime: _pt(j['end_time']),
        price: (j['price'] as num).toDouble(),
        startDate: j['start_date'] != null ? DateTime.tryParse(j['start_date']) : null,
        endDate: j['end_date'] != null ? DateTime.tryParse(j['end_date']) : null,
        priority: j['priority'] ?? 1,
        isActive: j['is_active'] ?? true,
        updatedAt: DateTime.parse(j['updated_at']),
      );

  static String _pt(dynamic t) {
    if (t == null) return '00:00';
    final s = t.toString();
    if (s.contains('T')) {
      final dt = DateTime.tryParse(s);
      if (dt != null)
        return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    }
    return s.length >= 5 ? s.substring(0, 5) : s;
  }

  @override
  List<Object?> get props => [id, courtId, dayOfWeek, startTime, endTime];
}

// ── Media attachment snapshot ─────────────────────────────────────────────────
class MediaAttachmentModel extends Equatable {
  final String id;
  final String fileId; // media_attachments.file_id → files.id
  final String publicUrl; // files.public_url @db.VarChar(1000)
  final String? caption; // @db.VarChar(255)
  final bool isCover; // media_attachments.is_cover
  final int displayOrder; // @default(0)

  const MediaAttachmentModel({
    required this.id,
    required this.fileId,
    required this.publicUrl,
    this.caption,
    this.isCover = false,
    this.displayOrder = 0,
  });

  factory MediaAttachmentModel.fromJson(Map<String, dynamic> j) => MediaAttachmentModel(
        id: j['id'],
        fileId: j['file_id'],
        publicUrl: j['files']?['public_url'] ?? j['public_url'] ?? '',
        caption: j['caption'],
        isCover: j['is_cover'] ?? false,
        displayOrder: j['display_order'] ?? 0,
      );

  @override
  List<Object?> get props => [id];
}
