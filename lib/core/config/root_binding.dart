import 'package:gemini_clone/presention/controllers/home_controller.dart';
import 'package:gemini_clone/presention/controllers/starter_controller.dart';
import 'package:get/get.dart';

class RootBinding implements Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => StarterController(), fenix: true);
    Get.lazyPut(() => HomeController(), fenix: true);
  }
}