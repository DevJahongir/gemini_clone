import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gemini_clone/core/service/log_service.dart';
import 'package:gemini_clone/core/service/utils_service.dart';
import 'package:gemini_clone/data/repositories/gemini_talk_repository_impl.dart';
import 'package:gemini_clone/domain/usecases/gemini_text_and_image_usecase.dart';
import 'package:gemini_clone/domain/usecases/gemini_text_only_usecase.dart';
import 'package:image_picker/image_picker.dart';

import '../../data/models/message_model.dart';
import '../widgets/item_gemini_message.dart';
import '../widgets/item_user_message.dart';

class HomePage extends StatefulWidget {
  static const String id = 'home_page';

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GeminiTextOnlyUsecase textOnlyUsecase =
      GeminiTextOnlyUsecase(GeminiTalkRepositoryImpl());
  GeminiTextAndImageUsecase textAndImageUsecase =
      GeminiTextAndImageUsecase(GeminiTalkRepositoryImpl());

  final FocusNode _focusNode = FocusNode();
  TextEditingController textController = TextEditingController();
  String response = '';
  String base64 = '';
  File? _image;

  List<MessageModel> messages = [
    //   MessageModel(
    //       isMine: true,
    //       message:
    //           'How to learn Flutter? How to learn Flutter?How to learn Flutter?efwefewfewfewfff'),
    //   MessageModel(
    //       isMine: false,
    //       message:
    //           'In Flutter, the BorderRadius.only constructor is used to apply rounded corners to specific edges of a widget. It provides more granular control compared to other BorderRadius constructors that set a uniform radius for all corners'),
    //   MessageModel(
    //       isMine: true, message: 'What is this picture?', base64: testImage),
    //   MessageModel(
    //       isMine: false,
    //       message:
    //           "In Flutter, the BorderRadius.only constructor is used to apply rounded corners to specific edges of a widget. It provides more granular control compared to other BorderRadius constructors that set a uniform radius for all cornersIn Flutter, the BorderRadius.only constructor is used to apply rounded corners to specific edges of a widget. It provides more granular control compared to other BorderRadius constructors that set a uniform radius for all corners")
  ];

  _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      base64 = await Utils.pickAndConvertImage();
      LogService.i('Image selected !!!');
    }
  }

  apiTextOnly(String text) async {
    MessageModel mine = MessageModel(isMine: true, message: text);
    setState(() {
      messages.add(mine);
    });

    var either = await textOnlyUsecase.call(text);
    either.fold((l) {
      LogService.d(l);
    }, (r) async {
      LogService.d(r);
      MessageModel mine = MessageModel(isMine: false, message: r);
      setState(() {
        messages.add(mine);
      });
    });
  }

  apiTextAndImage(String text) async {
    var either = await textAndImageUsecase.call(text, base64);
    either.fold((l) {
      LogService.d(l);
    }, (r) async {
      LogService.d(r);
      MessageModel responseMessage = MessageModel(isMine: false, message: r);
      setState(() {
        messages.add(responseMessage);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () {
          _focusNode.unfocus();
        },
        child: Container(
          padding: EdgeInsets.only(bottom: 20, top: 40),
          child: Column(
            children: [
              SizedBox(
                height: 45,
                child: Image(
                  image: AssetImage('assets/images/gemini_logo.png'),
                  fit: BoxFit.cover,
                ),
              ),
              Expanded(
                child: Container(
                    margin: EdgeInsets.all(15),
                    child: messages.isEmpty
                        ? Center(
                            child: SizedBox(
                              height: 100,
                              width: 100,
                              child:
                                  Image.asset('assets/images/gemini_icon.png'),
                            ),
                          )
                        : ListView.builder(
                            itemCount: messages.length,
                            itemBuilder: (context, index) {
                              var message = messages[index];
                              if (message.isMine!) {
                                return itemOfUserMessage(message);
                              } else {
                                return itemOfGeminiMessage(message);
                              }
                            },
                          )),
              ),
              Container(
                margin: EdgeInsets.only(right: 20, left: 20),
                padding: EdgeInsets.only(left: 20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(color: Colors.grey, width: 1.5)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _image == null
                        ? SizedBox.shrink()
                        : Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.white),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.file(
                                _image!,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: textController,
                            maxLines: null,
                            style: TextStyle(
                              color: Colors.white,
                            ),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Message',
                              hintStyle: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),

                        SizedBox(
                          width: 10,
                        ),

                        //add photo
                        IconButton(
                          onPressed: () async {
                           await _pickImage();
                          },
                          icon: Icon(
                            Icons.add_photo_alternate_outlined,
                            color: Colors.grey,
                          ),
                        ),

                        //send message
                        IconButton(
                          onPressed: () async {
                            if (textController.text.isNotEmpty || _image != null) {
                              if (base64 != '') {
                                apiTextAndImage(textController.text);
                              } else {
                                apiTextOnly(textController.text);
                              }
                              textController.clear();
                              setState(() {
                                _image = null;
                                base64 = '';
                              });
                            }
                            _focusNode.unfocus();
                          },
                          icon: Icon(Icons.send_rounded, color: Colors.grey),
                        ),

                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
