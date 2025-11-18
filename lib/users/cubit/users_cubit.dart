import 'package:hydrated_bloc/hydrated_bloc.dart';

import '../service/users_service.dart';
import 'users_mapper.dart';
import 'users_state.dart';

class UsersCubit extends HydratedCubit<UsersState> {
  final UsersService service;
  UsersCubit(this.service)
    : super(UsersState([], true)) {
    service.getUsers().then((users) {
      emit(UsersState(users, false));
    });
  }

  @override
  UsersState? fromJson(Map<String, dynamic> json) {
    return usersStateFromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(UsersState state) {
    return usersStateToJson(state);
  }
}
