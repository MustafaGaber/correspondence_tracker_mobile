import 'package:equatable/equatable.dart';

class Classification extends Equatable {
  final String id;
  final String name;

  const Classification(this.id, this.name);

  @override
  List<Object?> get props => [id, name];
}