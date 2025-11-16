import 'package:equatable/equatable.dart';

class Subject extends Equatable {
  final String id;
  final String name;

  const Subject(this.id, this.name);

  @override
  List<Object?> get props => [id, name];
}