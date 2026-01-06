// ════════════════════════════════════════════════════════════════
// 📁 lib/core/usecases/usecase.dart
// ════════════════════════════════════════════════════════════════
import 'package:dat_san_247_mobile/core/errors/result.dart';

/// Base UseCase với params
abstract class UseCase<Type, Params> {
  Future<Result<Type>> call(Params params);
}

/// UseCase không cần params
abstract class UseCaseNoParams<Type> {
  Future<Result<Type>> call();
}

/// UseCase đồng bộ (Synchronous) với params
abstract class SyncUseCase<Type, Params> {
  Result<Type> call(Params params);
}

/// UseCase đồng bộ không params
abstract class SyncUseCaseNoParams<Type> {
  Result<Type> call();
}

/// Stream UseCase - Dùng cho realtime data
abstract class StreamUseCase<Type, Params> {
  Stream<Result<Type>> call(Params params);
}

/// Stream UseCase không params
abstract class StreamUseCaseNoParams<Type> {
  Stream<Result<Type>> call();
}

// ════════════════════════════════════════════════════════════════
// 📁 lib/core/usecases/params.dart
// ════════════════════════════════════════════════════════════════
import 'package:equatable/equatable.dart';

/// Dùng khi UseCase không cần params
class NoParams extends Equatable {
  const NoParams();

  @override
  List<Object?> get props => [];
}

/// Base class cho các params khác (optional)
abstract class Params extends Equatable {
  const Params();
}

// ════════════════════════════════════════════════════════════════
// 📁 EXAMPLES - Các trường hợp UseCase thực tế
// ════════════════════════════════════════════════════════════════

// ────────────────────────────────────────────────────────────────
// 1️⃣ UseCase KHÔNG có params (Get list)
// 📁 lib/features/category/domain/usecases/get_sport_categories.dart
// ────────────────────────────────────────────────────────────────
import 'package:dat_san_247_mobile/core/errors/result.dart';
import 'package:dat_san_247_mobile/core/usecases/usecase.dart';
import 'package:dat_san_247_mobile/features/category/domain/entities/sport_category_entity.dart';
import 'package:dat_san_247_mobile/features/category/domain/repositories/sport_category_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetSportCategories implements UseCaseNoParams<List<SportCategoryEntity>> {
  final SportCategoryRepository _repository;

  GetSportCategories(this._repository);

  @override
  Future<Result<List<SportCategoryEntity>>> call() {
    return _repository.getSportCategories();
  }
}

// Cách dùng trong Bloc:
// final result = await _getSportCategories();

// ────────────────────────────────────────────────────────────────
// 2️⃣ UseCase CÓ params đơn giản (Get by ID)
// 📁 lib/features/category/domain/usecases/get_category_by_id.dart
// ────────────────────────────────────────────────────────────────
@injectable
class GetCategoryById implements UseCase<SportCategoryEntity, int> {
  final SportCategoryRepository _repository;

  GetCategoryById(this._repository);

  @override
  Future<Result<SportCategoryEntity>> call(int categoryId) {
    return _repository.getCategoryById(categoryId);
  }
}

// Cách dùng:
// final result = await _getCategoryById(5);

// ────────────────────────────────────────────────────────────────
// 3️⃣ UseCase CÓ params phức tạp (Filter, Search, Pagination)
// 📁 lib/features/venue/domain/usecases/search_venues.dart
// ────────────────────────────────────────────────────────────────
class SearchVenuesParams extends Params {
  final String? keyword;
  final int? categoryId;
  final String? city;
  final double? minPrice;
  final double? maxPrice;
  final int page;
  final int limit;

  const SearchVenuesParams({
    this.keyword,
    this.categoryId,
    this.city,
    this.minPrice,
    this.maxPrice,
    this.page = 1,
    this.limit = 20,
  });

  @override
  List<Object?> get props => [
        keyword,
        categoryId,
        city,
        minPrice,
        maxPrice,
        page,
        limit,
      ];

  // Copy with cho dễ update
  SearchVenuesParams copyWith({
    String? keyword,
    int? categoryId,
    String? city,
    double? minPrice,
    double? maxPrice,
    int? page,
    int? limit,
  }) {
    return SearchVenuesParams(
      keyword: keyword ?? this.keyword,
      categoryId: categoryId ?? this.categoryId,
      city: city ?? this.city,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      page: page ?? this.page,
      limit: limit ?? this.limit,
    );
  }
}

@injectable
class SearchVenues implements UseCase<List<VenueEntity>, SearchVenuesParams> {
  final VenueRepository _repository;

  SearchVenues(this._repository);

  @override
  Future<Result<List<VenueEntity>>> call(SearchVenuesParams params) {
    return _repository.searchVenues(
      keyword: params.keyword,
      categoryId: params.categoryId,
      city: params.city,
      minPrice: params.minPrice,
      maxPrice: params.maxPrice,
      page: params.page,
      limit: params.limit,
    );
  }
}

// Cách dùng:
// final result = await _searchVenues(
//   SearchVenuesParams(
//     keyword: 'sân bóng',
//     categoryId: 1,
//     city: 'Hà Nội',
//     page: 1,
//   ),
// );

// ────────────────────────────────────────────────────────────────
// 4️⃣ UseCase CREATE/UPDATE (Post, Put)
// 📁 lib/features/booking/domain/usecases/create_booking.dart
// ────────────────────────────────────────────────────────────────
class CreateBookingParams extends Params {
  final int venueId;
  final DateTime startTime;
  final DateTime endTime;
  final String? note;

  const CreateBookingParams({
    required this.venueId,
    required this.startTime,
    required this.endTime,
    this.note,
  });

  @override
  List<Object?> get props => [venueId, startTime, endTime, note];

  Map<String, dynamic> toJson() {
    return {
      'venueId': venueId,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'note': note,
    };
  }
}

@injectable
class CreateBooking implements UseCase<BookingEntity, CreateBookingParams> {
  final BookingRepository _repository;

  CreateBooking(this._repository);

  @override
  Future<Result<BookingEntity>> call(CreateBookingParams params) {
    return _repository.createBooking(params);
  }
}

// Cách dùng:
// final result = await _createBooking(
//   CreateBookingParams(
//     venueId: 10,
//     startTime: DateTime.now(),
//     endTime: DateTime.now().add(Duration(hours: 2)),
//     note: 'Đặt sân cho team',
//   ),
// );

// ────────────────────────────────────────────────────────────────
// 5️⃣ UseCase DELETE
// 📁 lib/features/booking/domain/usecases/cancel_booking.dart
// ────────────────────────────────────────────────────────────────
@injectable
class CancelBooking implements UseCase<bool, int> {
  final BookingRepository _repository;

  CancelBooking(this._repository);

  @override
  Future<Result<bool>> call(int bookingId) {
    return _repository.cancelBooking(bookingId);
  }
}

// Cách dùng:
// final result = await _cancelBooking(bookingId);

// ────────────────────────────────────────────────────────────────
// 6️⃣ Synchronous UseCase (Validation, Transform)
// 📁 lib/features/auth/domain/usecases/validate_email.dart
// ────────────────────────────────────────────────────────────────
@injectable
class ValidateEmail implements SyncUseCase<bool, String> {
  @override
  Result<bool> call(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    if (email.isEmpty) {
      return const ResultFailure(
        ValidationFailure(message: 'Email không được để trống'),
      );
    }

    if (!emailRegex.hasMatch(email)) {
      return const ResultFailure(
        ValidationFailure(message: 'Email không hợp lệ'),
      );
    }

    return const ResultSuccess(true);
  }
}

// Cách dùng:
// final result = _validateEmail('test@example.com');

// ────────────────────────────────────────────────────────────────
// 7️⃣ Stream UseCase (Realtime data, Chat, Notifications)
// 📁 lib/features/chat/domain/usecases/listen_messages.dart
// ────────────────────────────────────────────────────────────────
@injectable
class ListenMessages implements StreamUseCase<List<MessageEntity>, int> {
  final ChatRepository _repository;

  ListenMessages(this._repository);

  @override
  Stream<Result<List<MessageEntity>>> call(int chatRoomId) {
    return _repository.listenMessages(chatRoomId).map(
      (messages) => ResultSuccess(messages),
    ).handleError(
      (error) => ResultFailure(
        ServerFailure(message: error.toString()),
      ),
    );
  }
}

// Cách dùng trong Bloc:
// await emit.forEach<Result<List<MessageEntity>>>(
//   _listenMessages(chatRoomId),
//   onData: (result) => result.fold(
//     onSuccess: (messages) => MessagesLoaded(messages),
//     onFailure: (failure) => MessagesError(failure),
//   ),
// );

// ────────────────────────────────────────────────────────────────
// 8️⃣ Multiple params với Named Parameters
// 📁 lib/features/auth/domain/usecases/login.dart
// ────────────────────────────────────────────────────────────────
class LoginParams extends Params {
  final String email;
  final String password;
  final bool rememberMe;

  const LoginParams({
    required this.email,
    required this.password,
    this.rememberMe = false,
  });

  @override
  List<Object?> get props => [email, password, rememberMe];
}

@injectable
class Login implements UseCase<UserEntity, LoginParams> {
  final AuthRepository _repository;

  Login(this._repository);

  @override
  Future<Result<UserEntity>> call(LoginParams params) {
    return _repository.login(
      email: params.email,
      password: params.password,
      rememberMe: params.rememberMe,
    );
  }
}

// Cách dùng:
// final result = await _login(
//   LoginParams(
//     email: 'user@example.com',
//     password: '123456',
//     rememberMe: true,
//   ),
// );

// ════════════════════════════════════════════════════════════════
// 📋 TỔNG KẾT CẤU TRÚC THỨ MỤC
// ════════════════════════════════════════════════════════════════
/*
lib/
├── core/
│   ├── usecases/
│   │   ├── usecase.dart               ← Base classes
│   │   └── params.dart                ← NoParams, Params base
│   └── errors/
│       ├── result.dart                ← Result pattern
│       └── failures.dart              ← Failure classes
│
└── features/
    └── [feature_name]/
        ├── data/
        │   ├── datasources/
        │   ├── models/
        │   └── repositories/          ← Repository implementation
        │
        ├── domain/
        │   ├── entities/              ← Business entities
        │   ├── repositories/          ← Repository interface
        │   └── usecases/              ← ⭐ UseCases ở đây
        │       ├── get_xxx.dart
        │       ├── create_xxx.dart
        │       ├── update_xxx.dart
        │       ├── delete_xxx.dart
        │       └── params/            ← (Optional) Nếu có nhiều params
        │           └── xxx_params.dart
        │
        └── presentation/
            ├── bloc/
            ├── pages/
            └── widgets/
*/

// ════════════════════════════════════════════════════════════════
// 📝 NAMING CONVENTIONS
// ════════════════════════════════════════════════════════════════
/*
UseCase naming pattern:
- Get:     GetXxx, GetXxxById, GetXxxList
- Create:  CreateXxx, AddXxx
- Update:  UpdateXxx, EditXxx
- Delete:  DeleteXxx, RemoveXxx, CancelXxx
- Search:  SearchXxx, FilterXxx
- Validate: ValidateXxx, CheckXxx
- Listen:  ListenXxx, WatchXxx, StreamXxx

Params naming pattern:
- XxxParams (e.g., SearchVenuesParams, CreateBookingParams)
- File: xxx_params.dart nếu phức tạp
- Inline trong usecase file nếu đơn giản
*/

// ════════════════════════════════════════════════════════════════
// 🎯 BEST PRACTICES
// ════════════════════════════════════════════════════════════════
/*
1. Mỗi UseCase chỉ làm 1 việc (Single Responsibility)
2. Params phải immutable (final fields, const constructor)
3. Params extends Equatable để so sánh dễ dàng
4. Luôn dùng @injectable để DI hoạt động
5. UseCase phải return Result<T>, KHÔNG throw exception
6. Tên UseCase phải rõ ràng, dễ hiểu
7. Complex params → Tách file riêng trong params/
8. Simple params → Inline trong usecase file
9. Stream UseCase cho realtime data
10. Sync UseCase cho validation, business logic đơn giản
*/
