import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class StarterController extends GetxController {
  late VideoPlayerController videoPlayerController;

  initVideoPlayer() {
    videoPlayerController =
    VideoPlayerController.asset("assets/videos/gemini_video.mp4")
      ..initialize().then((_) {
        update();
      });
    videoPlayerController.play();
    videoPlayerController.setLooping(true);
  }

  exitVideoPlayer(){
    videoPlayerController.dispose();
  }
}