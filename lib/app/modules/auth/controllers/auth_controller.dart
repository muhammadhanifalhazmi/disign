import 'dart:async';
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:disign/app/modules/auth/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  // TextEditingController pinController = TextEditingController();
  // var userPin = md5.convert(utf8.encode("999999")).toString();
  var isLoading = false.obs;
  bool? isVerified;
  // ignore: non_constant_identifier_names
  String? PLATFORM_ID;
  String? token;

  @override
  void onInit() {
    super.onInit();
    _checkLoginStatus();
  }


  @override
  void onClose() {}

  String convertMd5(pin) {
    var res = md5.convert(utf8.encode(pin)).toString();
    return res;
  }

  comparePinWithRetry(pin) async {
    isLoading.value= true;
    // var pin = pinController.;
    // debugPrint(pin);
    // var pinMd5 = convertMd5(pin);
    // debugPrint((userPin == pinMd5).toString());
    // isVerified = (userPin == pinMd5);

    AuthProvider authProvider = AuthProvider();
    var req = {'pin' : pin};
    try {
      var result = await authProvider.postAuth(req, token: token);
      isVerified = result.isValid;
      isLoading.value = false;
      Get.back(result: isVerified);
    } on TimeoutException catch (e) {
      print('Timeout occurred: $e');
      // Retry after a delay
      await Future.delayed(const Duration(seconds: 3));
      await comparePinWithRetry(pin); // Recursive call to retry fetching data
    } catch (e) {
      print('Error occurred: $e');
      // Handle other exceptions
      // ...
    }
  }

  _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (isLoggedIn) {
      // User is logged in, navigate to the home screen.
      PLATFORM_ID = prefs.getString('PLATFORM_ID');
      token = prefs.getString('token');
      debugPrint("TOKEN-AFTER : ${token!}");
    } else {
      // User is not logged in, navigate to the login screen.
    }
    return isLoggedIn;
  }
}
