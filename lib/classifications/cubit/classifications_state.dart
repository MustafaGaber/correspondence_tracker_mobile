import 'package:equatable/equatable.dart';

import '../models/classification.dart'; 

class ClassificationsState extends Equatable {
  final List<Classification> classifications;
  final bool isLoading;

  const ClassificationsState(
    this.classifications,
    this.isLoading,
  );

  @override
  List<Object?> get props => [classifications, isLoading];
}