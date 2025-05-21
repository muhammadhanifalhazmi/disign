import 'dart:async';
import 'dart:io';

import 'package:disign/app/modules/register_device/providers/register_device_response_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../routes/app_pages.dart';

class RegisterDeviceController extends GetxController {
  TextEditingController deviceIdController = TextEditingController();
  TextEditingController deviceNameController = TextEditingController();
  String? PLATFORM_ID;
  var isLoading = false.obs;
  String? token;
  
  final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  @override
  void onInit() {
    super.onInit();
    _getInfo();
  }

  registerDeviceWithRetry() async {
    isLoading.value = true;
    String? value = validateName();
    if (value == null) {
      // Form is valid, continue with form submission or other actions
      RegisterDeviceProvider deviceProvider = RegisterDeviceProvider();
      var req = {};
      req['hwid'] = deviceIdController.text;
      req['device_name'] = deviceNameController.text;
      try {
        if (token == null) {
          isLoading.value = false;
          _showWarning(success: false, title: "Failed!", message: "Authentication token is missing");
          return;
        }
        
        var result = await deviceProvider.postRegisterDevice(req, token: token);
        isLoading.value = false;
        _showWarning(success: true, message: result.message!);
        await Future.delayed(const Duration(seconds: 2));
        redirectOffCertificate();
      } on TimeoutException catch (e) {
        print('Timeout occurred: $e');
        // Retry after a delay
        await Future.delayed(const Duration(seconds: 3));
        await registerDeviceWithRetry(); // Recursive call to retry fetching data
      } catch (e) {
        print('Error occurred: $e');
        isLoading.value = false;
        _showWarning(success: false, title: "Error", message: "Failed to register device: ${e.toString()}");
        // Handle other exceptions
        // ...
      }
    } else {
      debugPrint("OKE!");
      _showWarning(success: false, title: "Failed!", message: value);
      isLoading.value = false;
    }
  }

  String? validateName() {
    String? value = deviceNameController.text;
    if (value.isEmpty) {
      return 'Device name is required';
    }
    return null;
  }

  _getInfo() async {
    await _getId();
    _checkLoginStatus();
  }

  _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (isLoggedIn) {
      // User is logged in, navigate to the home screen.
      // PLATFORM_ID = await prefs.getString('PLATFORM_ID');
      token = prefs.getString('token');
      if (token != null) {
        debugPrint("TOKEN-AFTER : $token");
      } else {
        debugPrint("Token is null");
      }
    } else {
      // User is not logged in, navigate to the login screen.
    }
    return isLoggedIn;
  }

  _getId() async {
    try {
      if (Platform.isAndroid) {
        // Get Android device ID
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        PLATFORM_ID = androidInfo.id;
      } else if (Platform.isIOS) {
        // Get iOS device ID
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        PLATFORM_ID = iosInfo.identifierForVendor;
      } else {
        // For other platforms
        PLATFORM_ID = 'unknown_platform';
      }
      debugPrint("Device ID: $PLATFORM_ID");
      
      if (PLATFORM_ID != null) {
        deviceIdController.text = PLATFORM_ID!;
      } else {
        debugPrint("Failed to get device ID");
        deviceIdController.text = "unknown_device";
      }
    } catch (e) {
      debugPrint("Error getting device ID: $e");
      PLATFORM_ID = 'error_getting_id';
      deviceIdController.text = PLATFORM_ID!;
    }
  }

  redirectOffCertificate() {
    Get.offNamed(Routes.CERTIFICATE);
  }

  redirectOffHome() {
    Get.offNamed(Routes.HOME);
  }

  _showWarning(
      {String title = "Success",
      String message = "",
      IconData icon = Icons.check_circle,
      bool success = true}) async {
    if (success == false) icon = Icons.sms_failed_rounded;
    Get.showSnackbar(GetSnackBar(
      title: title,
      message: message,
      icon: Icon(icon),
      duration: const Duration(seconds: 6),
    ));
    await Future.delayed(const Duration(seconds: 6));
    Get.closeCurrentSnackbar();
  }
}