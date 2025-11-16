import 'package:equatable/equatable.dart';

class CreateCorrespondenceFromImageRequest extends Equatable {
  final String? filePath; // Changed from File
  final String? fileName; // Added helper for multipart
  final String senderId;

  const CreateCorrespondenceFromImageRequest({
    this.filePath,
    this.fileName,
    required this.senderId,
  });

  @override
  List<Object?> get props => [filePath, fileName, senderId];
}