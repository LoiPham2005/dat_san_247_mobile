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
