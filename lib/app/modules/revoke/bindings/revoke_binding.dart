import 'package:get/get.dart';

import '../controllers/revoke_controller.dart';

class RevokeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RevokeController>(
      () => RevokeController(),
    );
  }
}
