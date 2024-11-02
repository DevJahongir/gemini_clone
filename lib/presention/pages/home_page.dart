import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/constants/constants.dart';
import '../../data/models/message_model.dart';
import '../../domain/usecases/gemini_text_and_image_usecase.dart';
import '../../domain/usecases/gemini_text_only_usecase.dart';
import '../controllers/home_controller.dart';
import '../widgets/item_gemini_message.dart';
import '../widgets/item_user_message.dart';

class HomePage extends StatefulWidget {
  static const String id = 'home_page';

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GetBuilder<HomeController>(
        builder: (_) {
          return GestureDetector(
            onTap: () {
              _controller.textFieldFocus.unfocus();
            },
            child: Container(
              padding: EdgeInsets.only(bottom: 20, top: 20),
              child: Column(
                children: [
                  const SizedBox(
                    height: 45,
                    child: Image(
                      image: AssetImage('assets/images/gemini_logo.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.all(15),
                      child: _controller.messages.isEmpty
                          ? Center(
                        child: SizedBox(
                          height: 100,
                          width: 100,
                          child: Image.asset('assets/images/gemini_icon.png'),
                        ),
                      )
                          : ListView.builder(
                        controller: _controller.scrollController, // Attach ScrollController
                        itemCount: _controller.messages.length,
                        itemBuilder: (context, index) {
                          var message = _controller.messages[index];
                          return message.isMine!
                              ? itemOfUserMessage(message)
                              : itemOfGeminiMessage(message);
                        },
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 20, left: 20),
                    padding: const EdgeInsets.only(left: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: Colors.grey, width: 1.5),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _controller.pickedImage64.isEmpty
                            ? SizedBox.shrink()
                            : Stack(
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              height: 70,
                              width: 70,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.white),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.memory(
                                  base64Decode(_controller.pickedImage64),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: IconButton(
                                onPressed: () {
                                  _controller.removePickedImage();
                                },
                                icon: Icon(Icons.clear_rounded, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                focusNode: _controller.textFieldFocus,
                                controller: _controller.textController,
                                maxLines: null,
                                style: TextStyle(color: Colors.white),
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Message',
                                  hintStyle: TextStyle(color: Colors.grey),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            IconButton(
                              onPressed: () async {
                                _controller.pickImageFromGallery();
                              },
                              icon: const Icon(
                                Icons.add_photo_alternate_outlined,
                                color: Colors.grey,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                _controller.askToGemini();
                              },
                              icon: const Icon(
                                Icons.send,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

