import 'package:equatable/equatable.dart';

import '../models/user.dart'; 

class UsersState extends Equatable {
  final List<User> users;
  final bool isLoading;

  const UsersState(
    this.users,
    this.isLoading,
  );

  @override
  List<Object?> get props => [users, isLoading];
}