import 'package:correspondence_tracker/shared/functions/api_functions.dart';
import 'package:http/http.dart' as http;
import '../models/correspondent.dart';

class CorrespondentsService {
  final http.Client _http = http.Client();
  final String _baseUrl;

  CorrespondentsService(String apiUrl) : _baseUrl = '$apiUrl/Correspondents';

  Future<List<Correspondent>> getCorrespondents() async {
    final uri = Uri.parse(_baseUrl);
    final response = await _http.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );
    final result = handleResponse(response) as List<dynamic>? ?? [];
    return result.map((item) => correspondentFromMap(item)).toList();
  }

  Correspondent correspondentFromMap(dynamic map) {
    return Correspondent(map['id'], map['name']);
  }
}
