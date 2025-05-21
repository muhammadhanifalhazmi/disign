import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../utils/theme.dart';
import '../controllers/register_device_controller.dart';

class RegisterDeviceView extends GetView<RegisterDeviceController> {
  const RegisterDeviceView({super.key});

  _registerBtn() {
    return Container(
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(10.0), // Set the desired border radius
            ),
          ),
          onPressed: () => controller.registerDeviceWithRetry(),
          child: const Text('Register')),
    );
  }

  _deviceNameField() {
    return Container(
      margin: const EdgeInsetsDirectional.only(top: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Device Name : "),
          const SizedBox(
            height: 8,
          ),
          TextFormField(
            controller: controller.deviceNameController,
            decoration: InputDecoration(
              prefixIcon: const Icon(
                Icons.devices_outlined,
                color: Colors.grey,
              ),
              labelText: "device name",
              border: OutlineInputBorder(
                  // width: 0.0 produces a thin "hairline" border
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: accent1Color)),
              hintStyle: secondaryTextStyle,
              hintText: "name this device",
              // enabledBorder: OutlineInputBorder(
              //   borderRadius: BorderRadius.circular(20),
              //   borderSide: BorderSide(color: accent1Color),
              // ),
            ),
          ),
        ],
      ),
    );
  }

  _hwidField() {
    return Container(
      margin: const EdgeInsetsDirectional.only(top: 15),
      child: TextFormField(
        enabled: false,
        controller: controller.deviceIdController,
        decoration: InputDecoration(
          prefixIcon: const Icon(
            Icons.perm_device_info,
            color: Colors.grey,
          ),
          labelText: "device id",
          labelStyle: primaryTextStyle,
          border: OutlineInputBorder(
              // width: 0.0 produces a thin "hairline" border
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: accent1Color)),
          hintStyle: secondaryTextStyle,
          // hintText: "location",
          // enabledBorder: OutlineInputBorder(
          //   borderRadius: BorderRadius.circular(20),
          //   borderSide: BorderSide(color: accent1Color),
          // ),
        ),
      ),
    );
  }

  _appBar(String text) {
    return AppBar(
      automaticallyImplyLeading: true,
      // leading: GestureDetector(
      //   child: Container(
      //       margin: const EdgeInsetsDirectional.only(top: defaultMargin),
      //       child: Icon(Icons.arrow_back, color: secondaryTextColor)),
      //   onTap: () => {},
      // ),
      title: Container(
        // margin: const EdgeInsets.only(top: defaultMargin),
        child: Text(
          text,
          style: secondaryTextStyle,
        ),
      ),
      centerTitle: true,
      backgroundColor: whiteColor,
      elevation: 0,
      iconTheme: const IconThemeData(color: Colors.grey),
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: whiteColor,
        appBar: _appBar("Register New Device"),
        body: SafeArea(
          child: Obx(() => (controller.isLoading.value == true) ? const Center(child: CircularProgressIndicator(backgroundColor: Color(0x99ffffff),),) : Container(
                height: height,
                margin: const EdgeInsets.all(defaultMargin),
                child: ListView(children: [
                  const Text(
                    'RegisterDeviceView is working',
                    style: TextStyle(fontSize: 20),
                  ),
                  _hwidField(),
                  _deviceNameField(),
                  const SizedBox(
                    height: 16,
                  ),
                  _registerBtn()
                ]),
              )),
        ));
  }
}
