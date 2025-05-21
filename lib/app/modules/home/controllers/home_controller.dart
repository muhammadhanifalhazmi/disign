import 'dart:async';
import 'dart:io';

import 'package:disign/app/helper/get_directory.dart';
import 'package:disign/app/modules/auth/providers/logout_provider.dart';
import 'package:disign/app/modules/home/providers/user_info_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/models/user_info_model.dart';
import '../../../helper/permission_handler.dart';
import '../../../routes/app_pages.dart';

class HomeController extends GetxController {
  var isLoading = true.obs;
  List<FileSystemEntity> files = [];
  var filenames = [].obs;
  // Map? allInfo = {}.obs;
  var info = UserInfo().obs;
  String? PLATFORM_ID;
  String? token;
  var isRevoked = true.obs;

  final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  @override
  void onInit() {
    super.onInit();
    _getAllInfo();
    // _getDeviceInfo();
  }

  @override
  void onReady() {
    super.onReady();
    _getFiles();
  }

  @override
  void onClose() {}

  _getAllInfo() async {
    var isLoggedIn = await _checkLoginStatus();
    if (isLoggedIn) {
      await _getUserDataWithRetry();
      await Future.delayed(const Duration(seconds: 1));
      _checkIsRevoked();
      isLoading.value = false;
    }
  }

  void deletePdf(FileSystemEntity file) async {
    await file.delete();
    _showWarning(message: "File deleted", icon: Icons.delete_forever_outlined);
    _getFiles();
  }

  void sharePdf(FileSystemEntity file) async {
    var filePath = file.path;
    final xFile = XFile(filePath);
    var isGranted = await storagePermission();
    if (!isGranted) {
      // await permissionHandler();
      openAppSettings();
    }
    await Share.shareXFiles([xFile]);
  }

  void openPdf(FileSystemEntity file) async {
    var filePath = file.path;
    var isGranted = await manageExStoragePermission();
    if (!isGranted) {
      // await permissionHandler();
      openAppSettings();
    }

    try {
      // The open_file package has a slightly different API than open_file_plus
      var result = await OpenFile.open(filePath);
      debugPrint("Open file result: ${result.type} - ${result.message}");
    } catch (e) {
      debugPrint("Error opening file: $e");
      _showWarning(
        success: false,
        title: "Error",
        message: "Could not open the file: ${e.toString()}",
      );
    }
  }

  Future<void> handleRefresh() async {
    await _checkLoginStatus();
    if (token != null) {
      debugPrint("TOKEN : $token");
      await _getUserDataWithRetry();
      await Future.delayed(const Duration(seconds: 2));
      await _checkIsRevoked();
      await _getFiles();
    }
  }

  // _getDeviceInfo() async {
  //   final deviceInfoPlugin = DeviceInfoPlugin();
  //   final deviceInfo = await deviceInfoPlugin.deviceInfo;
  //   allInfo = deviceInfo.data;
  //   print(allInfo);
  // }

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
      debugPrint("HWID : $PLATFORM_ID");
    } catch (e) {
      debugPrint("Error getting device ID: $e");
      PLATFORM_ID = 'error_getting_id';
    }
  }

  _getUserDataWithRetry() async {
    if (PLATFORM_ID == null || token == null) {
      debugPrint("PLATFORM_ID or token is null");
      return;
    }

    debugPrint("TOKEN-FETCH : $token");

    UserInfoProvider userProvider = UserInfoProvider();
    try {
      var result = await userProvider.getUser(PLATFORM_ID!, token: token);
      info.value = result!;
    } on TimeoutException catch (e) {
      print('Timeout occurred: $e');
      // Retry after a delay
      await Future.delayed(const Duration(seconds: 3));
      await _getUserDataWithRetry(); // Recursive call to retry fetching data
    } catch (e) {
      print('Error occurred: $e');
      // Handle other exceptions
      // ...
    }
  }

  Future<void> _getFiles() async {
    var isGranted = await manageExStoragePermission();
    if (isGranted) {
      Directory dir = await getDirectory();
      files = dir.listSync();
      filenames.value = [];
      for (FileSystemEntity file in files) {
        filenames.add(file.path.split('/').last);
        // file =
        // outputFileName = outputFileName.split('.').first +
        //     "_" +
        //     DateTime.now().toString().split('.').last;
        // debugPrint(file.path);
        // debugPrint(file.absolute.toString());
        // debugPrint(file.statSync().toString());
      }
      debugPrint(filenames.toString());
    }
  }

  logoutWithRetry() async {
    isLoading.value = true;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    LogoutProvider logoutProvider = LogoutProvider();

    try {
      if (token != null) {
        await logoutProvider.postLogout(token);
      }
      await prefs.setBool('isLoggedIn', false);
      await prefs.remove('token');
      await prefs.clear();
      redirectOfLoginPage();
    } on TimeoutException catch (e) {
      print('Timeout occurred: $e');
      // Retry after a delay
      await Future.delayed(const Duration(seconds: 3));
      await logoutWithRetry(); // Recursive call to retry fetching data
    } catch (e) {
      print('Error occurred: $e');
      isLoading.value = false;
      _showWarning(
        success: false,
        title: "Error",
        message: "Logout failed: ${e.toString()}",
      );
    }

    isLoading.value = false;
  }

  _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (isLoggedIn) {
      // User is logged in, navigate to the home screen.
      PLATFORM_ID = prefs.getString('PLATFORM_ID');
      token = prefs.getString('token');
      if (token != null) {
        debugPrint("TOKEN-AFTER : $token");
      }
    } else {
      // User is not logged in, navigate to the login screen.
      await _getId();
      redirectOfLoginPage();
    }
    return isLoggedIn;
  }

  _checkIsRevoked() {
    debugPrint(info.value.device?.activeCertificate?.isRevoked.toString());
    isRevoked.value =
        (info.value.device?.activeCertificate != null) ? false : true;
  }

  void redirectOfLoginPage() {
    Get.offNamed(Routes.LOGIN);
  }

  void redirectToDevicesPage() {
    Get.toNamed(Routes.DEVICE);
  }

  void redirectToSignPage() async {
    if (isRevoked != true) {
      await Get.toNamed(Routes.SIGN);
      await handleRefresh();
    } else {
      _showWarning(
          duration: 10,
          success: false,
          title: "Unable to Digitally Sign",
          message: "Your Certificate has been Revoked");
    }
  }

  _showWarning(
      {String title = "Success",
      String message = "",
      IconData icon = Icons.check_circle,
      bool success = true,
      int duration = 6}) async {
    if (success == false) icon = Icons.sms_failed_rounded;
    Get.showSnackbar(GetSnackBar(
      title: title,
      message: message,
      icon: Icon(icon),
      duration: Duration(seconds: duration),
    ));
    await Future.delayed(Duration(seconds: duration));
    Get.closeCurrentSnackbar();
  }
}
