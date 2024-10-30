import 'package:gemini_clone/domain/repositories/gemini_talk_repository.dart';
import 'package:dartz/dartz.dart';


class GeminiTextAndImageUsecase {
  final GeminiTalkRepository repository;

  GeminiTextAndImageUsecase(this.repository);

  Future<Either<String, String>>call(String text, String base64)async{
    return await repository.onTextAndImage(text, base64);
  }
}