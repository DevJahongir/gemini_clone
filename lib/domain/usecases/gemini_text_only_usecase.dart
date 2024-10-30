import 'package:gemini_clone/domain/repositories/gemini_talk_repository.dart';
import 'package:dartz/dartz.dart';


class GeminiTextOnlyUsecase {
  final GeminiTalkRepository repository;

  GeminiTextOnlyUsecase(this.repository);

  Future<Either<String, String>>call(String text)async{
    return await repository.onTextOnly(text);
  }
}