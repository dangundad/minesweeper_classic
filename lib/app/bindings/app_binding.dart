import 'package:get/get.dart';

import 'package:minesweeper_classic/app/controllers/game_controller.dart';
import 'package:minesweeper_classic/app/controllers/home_controller.dart';
import 'package:minesweeper_classic/app/controllers/setting_controller.dart';
import 'package:minesweeper_classic/app/services/hive_service.dart';

class AppBinding implements Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<HiveService>()) {
      Get.put(HiveService(), permanent: true);
    }
    if (!Get.isRegistered<SettingController>()) {
      Get.put(SettingController(), permanent: true);
    }

    // GameController is permanent so HomePage can access it for best records
    if (!Get.isRegistered<GameController>()) {
      Get.put(GameController(), permanent: true);
    }

    Get.lazyPut(() => HomeController(), fenix: true);
  }
}
