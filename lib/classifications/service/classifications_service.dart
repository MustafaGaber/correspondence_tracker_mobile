import 'package:correspondence_tracker/shared/functions/api_functions.dart';
import 'package:http/http.dart' as http;
import '../models/classification.dart';

class ClassificationsService {
  final http.Client _http = http.Client();
  final String _baseUrl;

  ClassificationsService(String apiUrl) : _baseUrl = '$apiUrl/Classifications';

  Future<List<Classification>> getClassifications() async {
    final uri = Uri.parse(_baseUrl);
    final response = await _http.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );
    final result = handleResponse(response) as List<dynamic>? ?? [];
    return result.map((item) => classificationFromMap(item)).toList();
  }

  Classification classificationFromMap(dynamic map) {
    return Classification(map['id'], map['name']);
  }
}
