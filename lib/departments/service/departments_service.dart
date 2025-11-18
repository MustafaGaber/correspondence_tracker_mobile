import 'package:correspondence_tracker/shared/functions/api_functions.dart';
import 'package:http/http.dart' as http;
import '../models/department.dart';

class DepartmentsService {
  final http.Client _http = http.Client();
  final String _baseUrl;

  DepartmentsService(String apiUrl) : _baseUrl = '$apiUrl/Departments';

  Future<List<Department>> getDepartments() async {
    final uri = Uri.parse(_baseUrl);
    final response = await _http.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );
    final result = handleResponse(response) as List<dynamic>? ?? [];
    return result.map((item) => departmentFromMap(item)).toList();
  }

  Department departmentFromMap(dynamic map) {
    return Department(map['id'], map['name']);
  }
}
