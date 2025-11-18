
import '../models/user.dart';
import 'users_state.dart';

UsersState? usersStateFromJson(Map<String, dynamic> json) {
  return UsersState(
      List<User>.from(json['users']?.map((b) => userFromJson(b)) ?? []),
      json['lastUpdate']);
}

@override
Map<String, dynamic>? usersStateToJson(UsersState state) {
  return {
    'users': state.users.map((s) => userToJson(s)).toList(),
  };
}

Map<String, dynamic>? userToJson(User user) {
  return {
    'id': user.id,
    'name': user.name,
  };
}

User userFromJson(Map<String, dynamic> json) {
  return User(
    json['id'],
    json['name'],
  );
}
