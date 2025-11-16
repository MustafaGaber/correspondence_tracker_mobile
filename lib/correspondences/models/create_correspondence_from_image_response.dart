import 'package:equatable/equatable.dart';

class CreateCorrespondenceFromImageResponse extends Equatable {
  final String id;
  final String content;
  final String summary;
  final String fileId;

  const CreateCorrespondenceFromImageResponse({
    required this.id,
    required this.content,
    required this.summary,
    required this.fileId,
  });

  @override
  List<Object?> get props => [id, content, summary, fileId];
}