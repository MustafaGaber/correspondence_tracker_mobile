import 'package:equatable/equatable.dart';

import '../models/correspondent.dart'; 

class CorrespondentsState extends Equatable {
  final List<Correspondent> correspondents;
  final bool isLoading;

  const CorrespondentsState(
    this.correspondents,
    this.isLoading,
  );

  @override
  List<Object?> get props => [correspondents, isLoading];
}