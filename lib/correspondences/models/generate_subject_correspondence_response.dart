import 'package:equatable/equatable.dart';

class GenerateSubjectCorrespondenceResponse extends Equatable {
  final String generatedContent;

  const GenerateSubjectCorrespondenceResponse(this.generatedContent);

  @override
  List<Object?> get props => [generatedContent];
}