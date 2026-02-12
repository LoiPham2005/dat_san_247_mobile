import 'package:equatable/equatable.dart';

abstract class BbbbbbbbEvent extends Equatable {
  const BbbbbbbbEvent();

  @override
  List<Object?> get props => [];
}

class LoadBbbbbbbbs extends BbbbbbbbEvent {
  final Map<String, dynamic>? params;

  const LoadBbbbbbbbs({this.params});

  @override
  List<Object?> get props => [params];
}
