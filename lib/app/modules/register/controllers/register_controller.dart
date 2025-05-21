import 'dart:async';
import 'dart:io';

import 'package:disign/app/data/models/register_response_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/models/register_model.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/debug_values.dart';
import '../providers/register_provider.dart';

class RegisterController extends GetxController {
  var isDebug = DEBUG.IS_DEBUG;
  var isLoading = false.obs;
  var isObscure = true.obs;
  var isPinObscure = true.obs;
  var currentStep = 0.obs;
  var isPasswordOk = false.obs;
  final GlobalKey<FormState> pinFormKey = GlobalKey<FormState>();
  TextEditingController deviceIdController = TextEditingController();
  TextEditingController deviceNameController = TextEditingController();
  TextEditingController pinController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordConfirmController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  late final String? PLATFORM_ID;
  
  final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  @override
  void onInit() {
    super.onInit();
    _getId();
    locationController.text = "Indonesia";
  }

  @override
  void onReady() {
    super.onReady();
    if (isDebug) {
      usernameController.text = DEBUG.USERNAME;
      nameController.text = DEBUG.NAME;
      locationController.text = DEBUG.LOCATION_INFO;
      emailController.text = DEBUG.EMAIL;
      passwordController.text = DEBUG.PASSWORD;
      passwordConfirmController.text = DEBUG.PASSWORD;
      pinController.text = DEBUG.PIN;
      // deviceIdController.text = PLATFORM_ID!;
      deviceNameController.text = DEBUG.DEVICE_NAME;
      // currentStep.value = 2;
    }
  }

  @override
  void onClose() {}

  _registerWithRetry() async {
    isLoading.value = true;
    RegisterProvider registerProvider = RegisterProvider();
    final newUser = <String, dynamic>{};

    newUser['username'] = usernameController.text;
    newUser['name'] = nameController.text;
    newUser['location_info'] = locationController.text;
    newUser['email'] = emailController.text;
    newUser['password'] = passwordController.text;
    newUser['pin'] = pinController.text;
    newUser['hwid'] = deviceIdController.text;
    newUser['device_name'] = deviceNameController.text;

    // Register register = Register(username: newUser['username'], name: newUser['name'], location_info: newUser['location_info'], email: newUser['email'], password: newUser['password'], pin: newUser['pin'], hwid: newUser['hwid'], deviceName: newUser['device_name']);
    Register register = Register.fromJson(newUser);
    debugPrint(register.toJson().toString());
    RegisterResponse? result;
    try {
      // Start a timer and wait for a response within the specified duration
      result = await registerProvider.postRegister(register);
      if (result.token != null) {
        await _saveLoginStatus(result.token);
        _redirectToCertificate();
        _showWarning(success: true, message: result.message.toString());
        isLoading.value = false;
      } else {
        _showWarning(
            success: false,
            title: "Failed!",
            message: result.message.toString());
        isLoading.value = false;
      }
      // Handle the response
      // ...
    } on TimeoutException catch (e) {
      // Handle the timeout exception
      print('Timeout occurred: $e');
      await Future.delayed(const Duration(seconds: 3));
      await _registerWithRetry();
      // ...
    } catch (e) {
      // Handle other exceptions
      print('Error occurred: $e');
      isLoading.value = false;
      _showWarning(
          success: false,
          title: "Error",
          message: "Registration failed: ${e.toString()}");
      // ...
    }
  }

  // bool _validateForm() {
  //   if (usernameController.text.isEmpty ||
  //       nameController.text.isEmpty ||
  //       emailController.text.isEmpty ||
  //       passwordController.text.isEmpty ||
  //       passwordConfirmController.text.isEmpty) return false;
  //   if (!emailController.text.isEmail) return false;
  //   if (passwordConfirmController.text != passwordController.text) return false;
  //   return true;
  // }

  bool _validateFormOne() {
    if (usernameController.text.isEmpty ||
        nameController.text.isEmpty ||
        emailController.text.isEmpty) {
      return false;
    }
    if (!emailController.text.isEmail) return false;
    return true;
  }

  bool _validateFormTwo() {
    if (deviceIdController.text.isEmpty || deviceNameController.text.isEmpty) {
      return false;
    }
    return true;
  }

  bool _validateFormThree() {
    if (!pinFormKey.currentState!.validate()) return false;
    if (pinController.text.isEmpty ||
        passwordController.text.isEmpty ||
        passwordConfirmController.text.isEmpty) {
      return false;
    }
    if (!isPasswordOk.value) return false;
    if (passwordConfirmController.text != passwordController.text) return false;
    return true;
  }

  String? validatePin(value) {
    if (value.isEmpty) {
      return 'PIN is required';
    } else if (value.length != 6) {
      return 'PIN must be 6 characters long';
    } else if (!isNumeric(value)) {
      return 'PIN must only contain numbers';
    }
    return null;
  }

  bool isNumeric(String? value) {
    if (value == null) {
      return false;
    }
    return double.tryParse(value) != null;
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

  void onStepCancel() {
    (currentStep == 0) ? null : currentStep -= 1;
  }

  void onStepContinue() {
    // debugPrint(_validateFormThree().toString());

    if (currentStep == 0) {
      (!_validateFormOne() ? null : currentStep += 1);
    } else if (currentStep == 1)
      (!_validateFormTwo() ? null : currentStep += 1);
    else
      (!_validateFormThree() ? null : _registerWithRetry());
  }

  _redirectToCertificate() {
    Get.offNamed(Routes.CERTIFICATE);
  }

  _saveLoginStatus(token) async {
    if (token == null || PLATFORM_ID == null) {
      debugPrint("Cannot save login status: token or PLATFORM_ID is null");
      return;
    }
    
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      // You can save other relevant information like user ID, email, etc.
      await prefs.setString('token', token);
      await prefs.setString('PLATFORM_ID', PLATFORM_ID!);
      debugPrint("Login status saved successfully");
    } catch (e) {
      debugPrint("Error saving login status: $e");
    }
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