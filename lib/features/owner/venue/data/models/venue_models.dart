import 'package:equatable/equatable.dart';

// ── VenueStatus enum ─────────────────────────────────────────
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

// ── OwnerVenueModel ─────────────────────────────────────────────────────────
class OwnerVenueModel extends Equatable {
  final String id;
  final String ownerId;
  final String name;
  final String slug;
  final String? description;
  final String address;
  final String city;
  final String district;
  final String? ward;
  final String? phone;
  final String? email;
  final String? thumbnailUrl;
  final String? fbUrl;
  final String? instagramUrl;
  final String? zaloUrl;
  final String? youtubeUrl;
  final VenueStatus status;
  final String? rejectionReason;
  final bool isActive;
  final bool isFeatured;
  final double rating;
  final double ratingCleanliness;
  final double ratingFacilities;
  final double ratingStaff;
  final int totalReviews;
  final double commissionRate;
  final double vatRate;
  final bool autoAcceptBookings;
  final int minBookingHours;
  final int maxBookingHours;
  final int minBookingBeforeHours;
  final int cancellationBeforeHours;
  final DateTime? approvedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int courtCount;
  final List<String> sportTypes;

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

// ── VenueOperatingHoursModel ────────────────────────────────────────────────
class VenueOperatingHoursModel extends Equatable {
  final String id;
  final String venueId;
  final OwnerDayOfWeek dayOfWeek;
  final String openingTime;
  final String closingTime;
  final bool isClosed;

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

// ── VenueScheduleExceptionModel ──────────────────────────────────────────────
class VenueScheduleExceptionModel extends Equatable {
  final String id;
  final String venueId;
  final DateTime date;
  final bool isClosed;
  final String? openTime;
  final String? closeTime;
  final String? reason;
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

// ── AmenityModel ─────────────────────────────────────────────────────────────
class AmenityModel extends Equatable {
  final String id;
  final String? venueId;
  final String? courtId;
  final String name;
  final String? icon;
  final bool isFree;

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

// ── OwnerCourtModel ──────────────────────────────────────────────────────────
class OwnerCourtModel extends Equatable {
  final String id;
  final String venueId;
  final String name;
  final String? description;
  final double pricePerHour;
  final CourtSurfaceType? surfaceType;
  final String? size;
  final bool isIndoor;
  final bool isActive;
  final int displayOrder;
  final String? thumbnailUrl;
  final List<String> sportTypes;
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

// ── OwnerPricingRuleModel ───────────────────────────────────────────────────
class OwnerPricingRuleModel extends Equatable {
  final String id;
  final String courtId;
  final String courtName;
  final String? name;
  final String? dayOfWeek;
  final String startTime;
  final String endTime;
  final double price;
  final DateTime? startDate;
  final DateTime? endDate;
  final int priority;
  final bool isActive;
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

// ── MediaAttachmentModel ────────────────────────────────────────────────────
class MediaAttachmentModel extends Equatable {
  final String id;
  final String fileId;
  final String publicUrl;
  final String? caption;
  final bool isCover;
  final int displayOrder;

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

// ── Venue Verification Models ───────────────────────────────────────────────
enum VerificationDocStatus { PENDING, APPROVED, REJECTED }

extension VerificationDocStatusX on VerificationDocStatus {
  String get label => switch (this) {
    VerificationDocStatus.PENDING  => 'Đang xét duyệt',
    VerificationDocStatus.APPROVED => 'Đã xác minh',
    VerificationDocStatus.REJECTED => 'Bị từ chối',
  };
  String get emoji => switch (this) {
    VerificationDocStatus.PENDING  => '⏳',
    VerificationDocStatus.APPROVED => '✅',
    VerificationDocStatus.REJECTED => '❌',
  };
}

class VenueVerificationModel {
  final String id;
  final String venueId;
  final int version;
  final String businessLicenseUrl;
  final String idCardFrontUrl;
  final String idCardBackUrl;
  final String ownerPhotoUrl;
  final VerificationDocStatus status;
  final DateTime? verifiedAt;
  final String? rejectionReason;
  final DateTime createdAt;
  final DateTime updatedAt;

  const VenueVerificationModel({
    required this.id,
    required this.venueId,
    required this.version,
    required this.businessLicenseUrl,
    required this.idCardFrontUrl,
    required this.idCardBackUrl,
    required this.ownerPhotoUrl,
    required this.status,
    this.verifiedAt,
    this.rejectionReason,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isPending  => status == VerificationDocStatus.PENDING;
  bool get isApproved => status == VerificationDocStatus.APPROVED;
  bool get isRejected => status == VerificationDocStatus.REJECTED;
  bool get canResubmit => isRejected;
}

// ── VenueService Models ─────────────────────────────────────────────────────
enum VenueServiceType { PRODUCT, SERVICE }

extension VenueServiceTypeX on VenueServiceType {
  String get label => switch (this) {
    VenueServiceType.PRODUCT => 'Sản phẩm',
    VenueServiceType.SERVICE => 'Dịch vụ',
  };
  String get emoji => switch (this) {
    VenueServiceType.PRODUCT => '📦',
    VenueServiceType.SERVICE => '🛎️',
  };
}

enum ServiceUnit { UNIT, HOUR, SESSION, PERSON, SET }

extension ServiceUnitX on ServiceUnit {
  String get label => switch (this) {
    ServiceUnit.UNIT    => 'cái',
    ServiceUnit.HOUR    => 'giờ',
    ServiceUnit.SESSION => 'buổi',
    ServiceUnit.PERSON  => 'người',
    ServiceUnit.SET     => 'bộ',
  };
}

class VenueServiceModel {
  final String id;
  final String venueId;
  final String name;
  final String? description;
  final double price;
  final ServiceUnit unit;
  final VenueServiceType type;
  final String? category;
  final bool isAvailable;
  final bool trackInventory;
  final int stockQuantity;
  final DateTime createdAt;
  final DateTime updatedAt;

  const VenueServiceModel({
    required this.id,
    required this.venueId,
    required this.name,
    this.description,
    required this.price,
    this.unit = ServiceUnit.UNIT,
    this.type = VenueServiceType.SERVICE,
    this.category,
    this.isAvailable = true,
    this.trackInventory = false,
    this.stockQuantity = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  VenueServiceModel copyWith({
    String? name, String? description, double? price, ServiceUnit? unit,
    VenueServiceType? type, String? category, bool? isAvailable,
    bool? trackInventory, int? stockQuantity,
  }) => VenueServiceModel(
    id: id, venueId: venueId,
    name: name ?? this.name, description: description ?? this.description,
    price: price ?? this.price, unit: unit ?? this.unit, type: type ?? this.type,
    category: category ?? this.category, isAvailable: isAvailable ?? this.isAvailable,
    trackInventory: trackInventory ?? this.trackInventory, stockQuantity: stockQuantity ?? this.stockQuantity,
    createdAt: createdAt, updatedAt: DateTime.now(),
  );

  bool get isLowStock => trackInventory && stockQuantity <= 3 && stockQuantity > 0;
  bool get isOutOfStock => trackInventory && stockQuantity <= 0;
}

// ── RefundPolicy Models ─────────────────────────────────────────────────────
class RefundRuleModel {
  final String id;
  final String policyId;
  final int cancelBeforeHours;
  final double refundPercentage;
  final String? description;

  const RefundRuleModel({
    required this.id, required this.policyId,
    required this.cancelBeforeHours, required this.refundPercentage,
    this.description,
  });

  String get label {
    if (cancelBeforeHours >= 24) return 'Hủy trước ${cancelBeforeHours ~/ 24} ngày';
    return 'Hủy trước ${cancelBeforeHours}h';
  }
}

class RefundPolicyModel {
  final String id;
  final String? venueId;
  final String name;
  final String? description;
  final bool isActive;
  final bool isDefault;
  final List<RefundRuleModel> rules;
  final DateTime createdAt;
  final DateTime updatedAt;

  const RefundPolicyModel({
    required this.id, this.venueId, required this.name,
    this.description, this.isActive = true, this.isDefault = false,
    this.rules = const [], required this.createdAt, required this.updatedAt,
  });

  RefundPolicyModel copyWith({
    String? name, String? description, bool? isActive, bool? isDefault,
    List<RefundRuleModel>? rules,
  }) => RefundPolicyModel(
    id: id, venueId: venueId,
    name: name ?? this.name, description: description ?? this.description,
    isActive: isActive ?? this.isActive, isDefault: isDefault ?? this.isDefault,
    rules: rules ?? this.rules, createdAt: createdAt, updatedAt: DateTime.now(),
  );
}
