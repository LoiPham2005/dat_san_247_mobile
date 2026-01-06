import 'package:equatable/equatable.dart';

/// Base Entity cho Domain layer
abstract class BaseEntity extends Equatable {
  const BaseEntity();

  @override
  bool? get stringify => true;
}

/// Entity với ID
abstract class IdentifiableEntity extends BaseEntity {
  const IdentifiableEntity();

  dynamic get id;

  @override
  List<Object?> get props => [id];
}

/// Entity với timestamp
abstract class TimestampEntity extends IdentifiableEntity {
  const TimestampEntity();

  DateTime? get createdAt;
  DateTime? get updatedAt;

  @override
  List<Object?> get props => [id, createdAt, updatedAt];
}
