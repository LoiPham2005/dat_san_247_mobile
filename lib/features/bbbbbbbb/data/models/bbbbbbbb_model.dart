import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'bbbbbbbb_model.g.dart';

@JsonSerializable()
class BbbbbbbbModel extends Equatable {
  final int id;
  final String name;

  const BbbbbbbbModel({
    required this.id,
    required this.name,
  });

  factory BbbbbbbbModel.fromJson(Map<String, dynamic> json) =>
      _$BbbbbbbbModelFromJson(json);

  Map<String, dynamic> toJson() => _$BbbbbbbbModelToJson(this);

  @override
  List<Object?> get props => [id, name];
}
