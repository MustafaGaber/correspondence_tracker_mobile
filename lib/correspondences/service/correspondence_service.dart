import 'dart:convert';
import 'dart:typed_data';
import 'package:correspondence_tracker/shared/functions/api_functions.dart';
import 'package:correspondence_tracker/shared/functions/date_functions.dart';
import 'package:http/http.dart' as http;
import '../models/correspondence.dart';
import '../models/correspondence_request.dart';
import '../models/correspondence_with_follow_ups.dart';
import '../models/create_correspondence_from_image_request.dart' show CreateCorrespondenceFromImageRequest;
import '../models/create_correspondence_from_image_response.dart';
import '../models/generate_correspondence_reply_request.dart';
import '../models/generate_subject_correspondence_response.dart';
import '../models/get_correspondences_filter_model.dart';
import 'correspondence_service_mapper.dart'; // Adjust path

class CorrespondenceService {
  final http.Client _http = http.Client();
  final String _baseUrl;
  final String _filesUrl;

  CorrespondenceService(String apiUrl)
      : _baseUrl = '$apiUrl/Correspondence',
        _filesUrl = '$apiUrl/Files';


  Future<void> closeCorrespondence(String id) async {
    final uri = Uri.parse('$_baseUrl/$id/Close');
    await _http.patch(uri, headers: {
      'Content-Type': 'application/json',
    });
  }

  Future<void> setCorrespondenceFile(String id, String filePath,
      String fileName) async {
    final uri = Uri.parse('$_baseUrl/$id/SetFile');
    final request = http.MultipartRequest('POST', uri);
    request.files.add(
        await http.MultipartFile.fromPath('file', filePath,
            filename: fileName));
    
     await request.send();
  }

  Future<List<Correspondence>> searchCorrespondences(
      GetCorrespondencesFilterModel filter) async {
    final uri = Uri.parse(_baseUrl);
    final response = await _http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(filter.toMap()), // Use the toMap() method
    );
    final result = handleResponse(response) as List<dynamic>? ?? [];
    return result.map((item) => correspondenceFromMap(item)).toList();
  }

  Future<CorrespondenceWithFollowUps> getCorrespondenceById(String id) async {
    final uri = Uri.parse('$_baseUrl/$id');
    final response = await _http.get(uri);
    final result = handleResponse(response);
    return correspondenceWithFollowUpsFromMap(result);
  }

  Future<List<Correspondence>> createCorrespondences(
      List<CorrespondenceRequest> requests) async {
    final uri = Uri.parse('$_baseUrl/CreateList');
    
    // Convert requests to the format expected by the backend
    final body = requests.map((r) => {
      'id': r.id,
      'incomingNumber': r.incomingNumber,
      'incomingDate': r.incomingDate?.toString(),
      'outgoingNumber': r.outgoingNumber,
      'outgoingDate': r.outgoingDate?.toString(),
      'senderId': r.senderId,
      'departmentId': r.departmentId,
      'content': r.content,
      'summary': r.summary,
      'followUpUserId': r.followUpUserId,
      'responsibleUserId': r.responsibleUserId,
      'subjectId': r.subjectId,
      'notes': r.notes,
      'isClosed': r.isClosed,
    }).toList();

    final response = await _http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(body),
    );
    
    final result = handleResponse(response) as List<dynamic>? ?? [];
    return result.map((item) => correspondenceFromMap(item)).toList();
  }

  Future<CreateCorrespondenceFromImageResponse> createFromImage(
      CreateCorrespondenceFromImageRequest request) async {
    final uri = Uri.parse('$_baseUrl/CreateFromImage');
    final multiRequest = http.MultipartRequest('POST', uri);
    
    multiRequest.fields['senderId'] = request.senderId;
    
    if (request.filePath != null && request.fileName != null) {
      multiRequest.files.add(await http.MultipartFile.fromPath(
          'file', request.filePath!,
          filename: request.fileName));
    }
    
    final response = await multiRequest.send();
    final result = handleResponse(await http.Response.fromStream(response));
    return createFromImageResponseFromMap(result);
  }

  Future<String> createCorrespondence(CorrespondenceRequest request) async {
    final uri = Uri.parse('$_baseUrl/Create');
    final multiRequest = await _buildMultipartRequest('POST', uri, request);
    
    final response = await multiRequest.send();
    final result = handleResponse(await http.Response.fromStream(response));
    return result as String; // Returns the ID
  }

  Future<void> updateCorrespondence(String id, CorrespondenceRequest request) async {
    final uri = Uri.parse('$_baseUrl/$id');
    final multiRequest = await _buildMultipartRequest('PUT', uri, request);

    final response = await multiRequest.send();
    handleResponse(await http.Response.fromStream(response));
  }

  Future<void> deleteCorrespondence(String id) async {
    final uri = Uri.parse('$_baseUrl/$id');
    final response = await _http.delete(uri);
    handleResponse(response);
  }

  Future<Uint8List> downloadFile(String fileId) async {
    final uri = Uri.parse('$_filesUrl/$fileId');
    final response = await _http.get(uri);

    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw Exception('Failed to download file: ${response.statusCode}');
    }
  }

  Future<GenerateSubjectCorrespondenceResponse> generateReply(
      String correspondenceId, GenerateCorrespondenceReplyRequest request) async {
    final uri = Uri.parse('$_baseUrl/$correspondenceId/GenerateReply');
    final response = await _http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(request.toMap()),
    );
    final result = handleResponse(response);
    return generateReplyResponseFromMap(result);
  }

  /// Helper to build the FormData equivalent for create/update.
  Future<http.MultipartRequest> _buildMultipartRequest(
      String method, Uri uri, CorrespondenceRequest request) async {
    final multiRequest = http.MultipartRequest(method, uri);

    // Add all simple fields
    if (request.id != null) multiRequest.fields['id'] = request.id!;
    if (request.incomingNumber != null) {
      multiRequest.fields['incomingNumber'] = request.incomingNumber!;
    }
    if (request.incomingDate != null) {
      multiRequest.fields['incomingDate'] = request.incomingDate.toString();
    }
    if (request.senderId != null) {
      multiRequest.fields['senderId'] = request.senderId!;
    }
    if (request.outgoingNumber != null) {
      multiRequest.fields['outgoingNumber'] = request.outgoingNumber!;
    }
    if (request.outgoingDate != null) {
      multiRequest.fields['outgoingDate'] = request.outgoingDate.toString();
    }
    if (request.departmentId != null) {
      multiRequest.fields['departmentId'] = request.departmentId!;
    }
    if (request.content != null) {
      multiRequest.fields['content'] = request.content!;
    }
    if (request.summary != null) {
      multiRequest.fields['summary'] = request.summary!;
    }
    if (request.followUpUserId != null) {
      multiRequest.fields['followUpUserId'] = request.followUpUserId!;
    }
    if (request.responsibleUserId != null) {
      multiRequest.fields['responsibleUserId'] = request.responsibleUserId!;
    }
    if (request.subjectId != null) {
      multiRequest.fields['subjectId'] = request.subjectId!;
    }
    if (request.notes != null) multiRequest.fields['notes'] = request.notes!;
    multiRequest.fields['isClosed'] = request.isClosed.toString();
    if (request.direction != null) {
      multiRequest.fields['direction'] = request.direction.toString();
    }
    if (request.priorityLevel != null) {
      multiRequest.fields['priorityLevel'] = request.priorityLevel.toString();
    }

    /*// Add file
    if (request.filePath != null) {
      multiRequest.files.add(await http.MultipartFile.fromPath(
        'file',
        request.filePath!,
        filename: request.fileName,
      ));
    }*/

    // Add classificationIds array
    if (request.classificationIds != null) {
      for (final id in request.classificationIds!) {
        multiRequest.fields['classificationIds'] = id;
      }
    }

    // Add reminders array
    if (request.reminders != null) {
      int index = 0;
      for (final reminder in request.reminders!) {
        final prefix = 'reminders[$index]';
        if (reminder.id != null) {
          multiRequest.fields['$prefix.id'] = reminder.id!;
        }
        multiRequest.fields['$prefix.remindTime'] =
            getLocalISOString(reminder.remindTime);
        if (reminder.message != null) {
          multiRequest.fields['$prefix.message'] = reminder.message!;
        }
        multiRequest.fields['$prefix.sendEmailMessage'] =
            reminder.sendEmailMessage.toString();
        index++;
      }
    }
    
    return multiRequest;
  }
}