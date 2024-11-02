import 'package:flutter/material.dart';
import 'package:gemini_clone/presention/controllers/starter_controller.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

import 'home_page.dart';

class StarterPage extends StatefulWidget {
  const StarterPage({super.key});

  @override
  State<StarterPage> createState() => _StarterPageState();
}

class _StarterPageState extends State<StarterPage> {
  final _controller = Get.find<StarterController>();

  @override
  void initState() {
    super.initState();
    _controller.initVideoPlayer();
  }

  @override
  void dispose() {
    _controller.exitVideoPlayer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GetBuilder<StarterController>(
        builder: (_){
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: Column(
              children: [
                Container(
                  child: const Image(
                    width: 150,
                    image: AssetImage('assets/images/gemini_logo.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                Expanded(
                  child: _controller.videoPlayerController.value.isInitialized
                      ? VideoPlayer(_controller.videoPlayerController)
                      : Container(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacementNamed(context, HomePage.id);
                      },
                      child: Container(
                        padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 2),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Row(
                          children: [
                            Text(
                              'Chat with Gemini ',
                              style: TextStyle(color: Colors.grey[400], fontSize: 18),
                            ),
                            const Icon(
                              Icons.arrow_forward,
                              color: Colors.grey,
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      )
    );
  }
}