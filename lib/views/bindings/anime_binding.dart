import 'package:get/get.dart';
import 'package:responsi/controllers/anime_controller.dart';

class AnimeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AnimeController>(() => AnimeController());
  }
}
