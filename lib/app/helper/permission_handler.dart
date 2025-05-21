import 'dart:io';

import 'package:permission_handler/permission_handler.dart';

Future<bool> storagePermission() async {
  PermissionStatus manageFilesStatus = await Permission.storage.request();
  if (manageFilesStatus.isGranted || manageFilesStatus.isLimited) return true;
  if (manageFilesStatus.isDenied || manageFilesStatus.isPermanentlyDenied) {
    openAppSettings();
  }
  return false;
}

Future<bool> manageExStoragePermission() async {
  if (Platform.isIOS) return true;
  PermissionStatus manageFilesStatus = await Permission.manageExternalStorage.request();
  if (manageFilesStatus.isGranted || manageFilesStatus.isLimited) return true;
  if (manageFilesStatus.isDenied || manageFilesStatus.isPermanentlyDenied) {
    openAppSettings();
  }
  return false;
}