import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'home_page.dart';

class StarterPage extends StatefulWidget {
  static const String id = 'starter_page';
  const StarterPage({super.key});

  @override
  State<StarterPage> createState() => _StarterPageState();
}

class _StarterPageState extends State<StarterPage> {
  late VideoPlayerController videoPlayerController;

  @override
  void initState() {
    super.initState();
    videoPlayerController =
        VideoPlayerController.asset("assets/videos/gemini_video.mp4")
          ..initialize().then((_) {
            setState(() {});
          });

    videoPlayerController.play();
    videoPlayerController.setLooping(true);
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 40),
        child: Column(
          children: [
            Container(
              child: Image(
                width: 150,
                image: AssetImage('assets/images/gemini_logo.png'),
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              child: videoPlayerController.value.isInitialized
                  ? VideoPlayer(videoPlayerController)
                  : Container(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: (){
                    Navigator.pushReplacementNamed(context, HomePage.id);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey, width: 2
                      ),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Row(
                      children: [
                        Text(
                          'Chat with Gemini',
                          style: TextStyle(color: Colors.grey[400], fontSize: 18),
                        ),
                        Icon(
                          Icons.arrow_forward,
                          color: Colors.grey,
                        )
                      ],
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
