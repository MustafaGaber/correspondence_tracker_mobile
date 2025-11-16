import 'package:equatable/equatable.dart';

class GenerateCorrespondenceReplyRequest extends Equatable {
  final String prompt;

  const GenerateCorrespondenceReplyRequest(this.prompt);

  @override
  List<Object?> get props => [prompt];

  Map<String, dynamic> toMap() => {'prompt': prompt};
}