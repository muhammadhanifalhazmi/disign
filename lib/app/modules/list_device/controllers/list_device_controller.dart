import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:disign/app/data/models/list_devices_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../routes/app_pages.dart';
import '../providers/list_devices_provider.dart';

class ListDeviceController extends GetxController {
  var isLoading = true.obs;
  String? PLATFORM_ID;
  var listDevices = ListDevices().obs;
  String? token;
  
  final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  @override
  void onInit() {
    super.onInit();
    // _getId();
    _prepareInfo();
  }

  _prepareInfo() async {
    await getAllDevicesWithRetry();
    _checkCurrentDeviceStatus();
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
    isLoading.value = false;
  }

  String getStatus(index) {
    // String status;
    var isRevoked = false.obs;
    isRevoked.value =
        (listDevices.value.devices![index].lastCertificate?.isRevoked == 0)
            ? false
            : true;

    debugPrint('Status${isRevoked.value}');
    var validEnd = listDevices.value.devices![index].lastCertificate?.validEnd;
    debugPrint(isRevoked.toString());
    return (_checkValidTime(validEnd) == true)
        ? (isRevoked == false)
            ? "Active"
            : "Revoked"
        : "Expired";
  }

  bool _checkValidTime(validEnd) {
    if (validEnd == null) return false;
    
    try {
      // convert string to int
      validEnd = int.parse(validEnd);
      // Convert the timestamp to milliseconds
      validEnd = validEnd * 1000;

      // Create a DateTime object from the milliseconds
      DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(validEnd);

      var currentDate = DateTime.now();
      DateTime serverDate = dateTime;
      return (currentDate.isAfter(serverDate)) ? false : true;
    } catch (e) {
      debugPrint("Error checking valid time: $e");
      return false;
    }
  }

  String getSerial(index) {
    var serial =
        listDevices.value.devices![index].lastCertificate?.certificateSrl ?? "";
    // debugPrint("INDEX : " + index.toString() + "-" + serial!);
    serial = _convertToHex(_encodeNumberToBase64(serial));
    return serial;
  }

  getAllDevicesWithRetry() async {
    await _checkLoginStatus();
    if (token == null) {
      debugPrint("Token is null, cannot get devices");
      isLoading.value = false;
      return;
    }
    
    ListDevicesProvider devicesProvider = ListDevicesProvider();

    try {
      listDevices.value = await devicesProvider.getListDevices(token: token);
      await Future.delayed(const Duration(seconds: 1));
      // debugPrint("DEBUG" + listDevices.value.devices!.length.toString());

      isLoading.value = false;
      // listDevices.value.devices?[0].lastCertificate ??
      // redirectOffHomePage();
    } on TimeoutException catch (e) {
      // Handle the timeout exception
      print('Timeout occurred: $e');
      await Future.delayed(const Duration(seconds: 3));
      await getAllDevicesWithRetry();
      // ...
    } catch (e) {
      // Handle other exceptions
      print('Error occurred: $e');
      // ...
      isLoading.value = false;
      redirectOffHomePage();
    }
  }

  String _convertToHex(String input) {
    return input.codeUnits.map((unit) => unit.toRadixString(16)).join('');
  }

  String _encodeNumberToBase64(String numberString) {
    // Convert the number string to UTF-8 encoded bytes
    List<int> bytes = utf8.encode(numberString);

    // Encode the bytes to base64
    String base64Encoded = base64.encode(bytes);

    return base64Encoded;
  }

  Future<void> handleRefresh() async {
    await _prepareInfo();
    Future.delayed(const Duration(seconds: 1));
  }

  _checkCurrentDeviceStatus() {
    if (PLATFORM_ID == null || listDevices.value.devices == null) {
      return;
    }
    
    bool currentDeviceIsRevoked = false;
    listDevices.value.devices?.forEach((element) {
      if ((element.hwid == PLATFORM_ID) &&
          (element.lastCertificate?.isRevoked == 1)) {
        currentDeviceIsRevoked = true;
      }
    });
    currentDeviceIsRevoked == true ? redirectOffHomePage() : null;
  }

  void redirectToRevokePage(index) {
    if (listDevices.value.devices == null || 
        index >= listDevices.value.devices!.length ||
        listDevices.value.devices![index].lastCertificate == null) {
      debugPrint("Cannot redirect to revoke page: invalid device or certificate");
      return;
    }
    
    final data = <String, dynamic>{};
    data['cert_id'] = listDevices.value.devices![index].lastCertificate?.id;
    data['cert_serial'] = getSerial(index);
    data['cert_expires'] =
        listDevices.value.devices![index].lastCertificate?.expires;
    data['device_name'] = listDevices.value.devices![index].deviceName;
    data['hwid'] = listDevices.value.devices![index].hwid;

    Get.toNamed(Routes.REVOKE, arguments: data);
  }

  _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (isLoggedIn) {
      // User is logged in, navigate to the home screen.
      PLATFORM_ID = prefs.getString('PLATFORM_ID');
      token = prefs.getString('token');
    } else {
      // User is not logged in, navigate to the login screen.
      await _getId();
    }
    if (token != null) {
      debugPrint("Token: $token");
    } else {
      debugPrint("Token is null");
    }
  }

  void redirectOffHomePage() {
    Get.offAllNamed(Routes.HOME);
  }

  void redirectToCertificatePage() {
    Get.toNamed(Routes.CERTIFICATE);
  }
}