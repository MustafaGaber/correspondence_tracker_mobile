import 'package:equatable/equatable.dart';

class Department extends Equatable {
  final String id;
  final String name;

  const Department(this.id, this.name);

  @override
  List<Object?> get props => [id, name];
}