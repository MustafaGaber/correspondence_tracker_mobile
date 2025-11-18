import 'package:correspondence_tracker/shared/functions/api_functions.dart';
import 'package:http/http.dart' as http;
import '../models/subject.dart';

class SubjectsService {
  final http.Client _http = http.Client();
  final String _baseUrl;

  SubjectsService(String apiUrl) : _baseUrl = '$apiUrl/Subjects';

  Future<List<Subject>> getSubjects() async {
    final uri = Uri.parse(_baseUrl);
    final response = await _http.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );
    final result = handleResponse(response) as List<dynamic>? ?? [];
    return result.map((item) => subjectFromMap(item)).toList();
  }

  Subject subjectFromMap(dynamic map) {
    return Subject(map['id'], map['name']);
  }
}
