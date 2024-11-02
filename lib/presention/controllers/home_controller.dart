import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/service/log_service.dart';
import '../../core/service/utils_service.dart';
import '../../data/models/message_model.dart';
import '../../data/repositories/gemini_talk_repository_impl.dart';
import '../../domain/usecases/gemini_text_and_image_usecase.dart';
import '../../domain/usecases/gemini_text_only_usecase.dart';

class HomeController extends GetxController {
  GeminiTextOnlyUsecase textOnlyUseCase = GeminiTextOnlyUsecase(GeminiTalkRepositoryImpl());
  GeminiTextAndImageUsecase textAndImageUseCase = GeminiTextAndImageUsecase(GeminiTalkRepositoryImpl());

  TextEditingController textController = TextEditingController();
  FocusNode textFieldFocus = FocusNode();
  ScrollController scrollController = ScrollController(); // Add ScrollController
  String response = '';
  String pickedImage64 = '';

  List<MessageModel> messages = [];

  @override
  void onClose() {
    textFieldFocus.dispose();
    textController.dispose();
    scrollController.dispose(); // Dispose ScrollController
    super.onClose();
  }

  pickImageFromGallery() async {
    var result = await Utils.pickAndConvertImage();
    LogService.i('Image selected !!!');
    pickedImage64 = result;
    update();
  }

  removePickedImage() {
    pickedImage64 = '';
    update();
  }

  askToGemini() {
    String message = textController.text.toString().trim();

    if (pickedImage64.isNotEmpty) {
      MessageModel mine = MessageModel(isMine: true, message: message, base64: pickedImage64);
      updateMessages(mine);
      apiTextAndImage(message);
    } else {
      MessageModel mine = MessageModel(isMine: true, message: message);
      updateMessages(mine);
      apiTextOnly(message);
    }

    textController.clear();
    removePickedImage();
    textFieldFocus.unfocus();
    scrollToBottom(); // Scroll to the latest message
  }

  apiTextOnly(String text) async {
    var either = await textOnlyUseCase.call(text);
    either.fold((l) {
      LogService.d(l);
      MessageModel gemini = MessageModel(isMine: false, message: l);
      updateMessages(gemini);
      scrollToBottom(); // Scroll after response
    }, (r) async {
      LogService.d(r);
      MessageModel gemini = MessageModel(isMine: false, message: r);
      updateMessages(gemini);
      scrollToBottom(); // Scroll after response
    });
  }

  apiTextAndImage(String text) async {
    var either = await textAndImageUseCase.call(text, pickedImage64);
    either.fold((l) {
      LogService.d(l);
      MessageModel gemini = MessageModel(isMine: false, message: l);
      updateMessages(gemini);
      scrollToBottom(); // Scroll after response
    }, (r) async {
      LogService.d(r);
      MessageModel gemini = MessageModel(isMine: false, message: r);
      updateMessages(gemini);
      scrollToBottom(); // Scroll after response
    });
  }

  updateMessages(MessageModel messageModel) {
    messages.add(messageModel);
    update();
  }

  void scrollToBottom() {
    if (scrollController.hasClients) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }
}
