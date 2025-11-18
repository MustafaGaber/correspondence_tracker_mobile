import 'dart:convert';
import 'package:http/http.dart' as http;

dynamic handleResponse(http.Response response) {
  if (response.statusCode >= 200 && response.statusCode < 300) {
    if (response.body.isEmpty) return null;
    final decoded = json.decode(response.body);
    return decoded['result']; // Assuming all responses have a 'result' wrapper
  } else {
    throw Exception('API Error: ${response.statusCode} - ${response.body}');
  }
}
