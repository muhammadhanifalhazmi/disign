import 'dart:io';

import 'package:path_provider/path_provider.dart';

Future<Directory> getDirectory() async {
  //Get external storage directory
  // final directory = await getExternalStorageDirectory();
  Directory directory;
  if (Platform.isAndroid) {
    directory = Directory("/storage/emulated/0/Documents/disign");
    if (!await directory.exists()) {
      directory.create(recursive: true);
    }
  } else {
    directory = await getApplicationDocumentsDirectory();
    directory = Directory("${directory.path}/disign");
    if (!await directory.exists()) {
      directory.create(recursive: true);
    }
    // debugPrint(directory.path + "TESTDIR");
  }

  return directory;
  //Get directory path
  // final path = directory!.path;
}
