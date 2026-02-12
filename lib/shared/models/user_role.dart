enum UserRole {
  customer,
  venueManager, // Staff
  venueOwner,
  admin,
  guest;

  bool get isCustomer => this == UserRole.customer;
  bool get isStaff => this == UserRole.venueManager;
  bool get isOwner => this == UserRole.venueOwner;
  bool get isAdmin => this == UserRole.admin;
  bool get isGuest => this == UserRole.guest;

  String get displayName {
    switch (this) {
      case UserRole.customer:
        return 'Customer';
      case UserRole.venueManager:
        return 'Staff';
      case UserRole.venueOwner:
        return 'Owner';
      case UserRole.admin:
        return 'Admin';
      case UserRole.guest:
        return 'Guest';
    }
  }
}
