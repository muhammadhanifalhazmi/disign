import 'package:get/get.dart';

import '../controllers/list_device_controller.dart';

class ListDeviceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ListDeviceController>(
      () => ListDeviceController(),
    );
  }
}
