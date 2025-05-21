import 'dart:async';
import 'dart:io';

import 'package:disign/app/modules/auth/providers/login_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../routes/app_pages.dart';
import '../../../data/models/login_model.dart';
import '../../../utils/debug_values.dart';

class LoginController extends GetxController {
  var isDebug = DEBUG.IS_DEBUG;
  var isObscure = true.obs;
  var isLoading = false.obs;
  late final String? PLATFORM_ID;

  final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    _getId();
    checkLoginStatus();
  }

  @override
  void onReady() {
    super.onReady();
    if (isDebug) {
      usernameController.text = DEBUG.USERNAME;
      passwordController.text = DEBUG.PASSWORD;
    }
  }

  @override
  void onClose() {}

  loginWithRetry() async {
    isLoading.value = true;
    LoginProvider loginProvider = LoginProvider();
    String username;
    String password;

    username = usernameController.text;
    password = passwordController.text;
    String hwid = PLATFORM_ID ?? '';
    try {
      Login login = Login(username: username, password: password, hwid: hwid);
      var result = await loginProvider.postLogin(login);
      debugPrint(result.toString());
      isLoading.value = false;
      if (result.token != null) {
        await _saveLoginStatus(result.token);
        result.device == null ? redirectOffRegisterDevice() : redirectOffHome();
      } else {
        _showWarning(
            title: "Login failed!", message: result.message.toString());
      }
    } on TimeoutException catch (e) {
      print('Timeout occurred: $e');
      // Retry after a delay
      await Future.delayed(const Duration(seconds: 2));
      await loginWithRetry(); // Recursive call to retry fetching data
    } catch (e) {
      print('Error occurred: $e');
      isLoading.value = false;
      _showWarning(title: "Error", message: e.toString());
    }
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
    } catch (e) {
      debugPrint("Error getting device ID: $e");
      PLATFORM_ID = 'error_getting_id';
    }
  }

  _saveLoginStatus(token) async {
    debugPrint("TOKEN-SAVE : " + token!);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    // You can save other relevant information like user ID, email, etc.
    await prefs.setString('token', token);
    var tok = prefs.getString('token');
    debugPrint("TOKEN-SAVE-AFTER : ${tok!}");

    await prefs.setString('PLATFORM_ID', PLATFORM_ID ?? '');
  }

  void checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    if (isLoggedIn) {
      // User is logged in, navigate to the home screen.
      redirectOffHome();
    } else {
      // User is not logged in, navigate to the login screen.
      // Navigator.pushReplacementNamed(context, '/login');
    }
  }

  void redirectOffRegisterDevice() {
    Get.offNamed(Routes.REGISTER_DEVICE);
  }

  void redirectOffHome() {
    Get.offNamed(Routes.HOME);
  }

  void redirectToRegister() {
    Get.toNamed(Routes.REGISTER);
  }

  void _showWarning(
      {String title = "Success",
      String message = "",
      IconData icon = Icons.sms_failed_rounded}) async {
    Get.showSnackbar(GetSnackBar(
      title: title,
      message: message,
      icon: Icon(icon),
      duration: const Duration(seconds: 3),
    ));
    await Future.delayed(const Duration(seconds: 3));
    Get.closeCurrentSnackbar();
  }
}