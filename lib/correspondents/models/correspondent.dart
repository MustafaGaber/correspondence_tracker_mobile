import 'package:equatable/equatable.dart';

class Correspondent extends Equatable {
  final String id;
  final String name;

  const Correspondent(this.id, this.name);

  @override
  List<Object?> get props => [id, name];
}