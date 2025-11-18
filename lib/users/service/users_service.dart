import 'package:correspondence_tracker/shared/functions/api_functions.dart';
import 'package:http/http.dart' as http;
import '../models/user.dart';

class UsersService {
  final http.Client _http = http.Client();
  final String _baseUrl;

  UsersService(String apiUrl) : _baseUrl = '$apiUrl/Users';

  Future<List<User>> getUsers() async {
    final uri = Uri.parse(_baseUrl);
    final response = await _http.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );
    final result = handleResponse(response) as List<dynamic>? ?? [];
    return result.map((item) => userFromMap(item)).toList();
  }

  User userFromMap(dynamic map) {
    return User(map['id'], map['name']);
  }
}
