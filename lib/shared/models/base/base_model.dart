import 'package:equatable/equatable.dart';

/// Base Model cho tất cả models trong app
/// Hỗ trợ JSON serialization và comparison
abstract class BaseModel extends Equatable {
  const BaseModel();

  /// Convert model sang JSON
  Map<String, dynamic> toJson();

  /// Copy với các giá trị mới
  BaseModel copyWith();

  @override
  bool? get stringify => true;
}

/// Mixin hỗ trợ JSON serialization
mixin JsonSerializable {
  Map<String, dynamic> toJson();

  @override
  String toString() => toJson().toString();
}

/// Mixin hỗ trợ Entity mapping
mixin EntityMapper<E> {
  E toEntity();
}
