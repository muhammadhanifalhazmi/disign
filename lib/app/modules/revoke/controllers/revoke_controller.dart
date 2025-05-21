import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:disign/app/modules/revoke/providers/revoke_provider.dart';
import 'package:disign/app/utils/debug_values.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

import '../../../routes/app_pages.dart';

class RevokeController extends GetxController {
  var isDebug = DEBUG.IS_DEBUG;
  var isDebugDocument = true;
  var isLoading = false.obs;
  String? token;
  String? PLATFORM_ID;
  late var data;
  TextEditingController serialController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController hwidController = TextEditingController();
  TextEditingController expireController = TextEditingController();
  TextEditingController detailController = TextEditingController();
  var isEnabled = false.obs;
  var filePath = "".obs;
  var fileName = "".obs;

  @override
  void onInit() {
    super.onInit();
    _checkLoginStatus();
  }

  @override
  void onReady() {
    super.onReady();
    data = Get.arguments;

    serialController.text = data['cert_id'].toString();
    expireController.text = data['cert_expires'];
    nameController.text = data['device_name'];
    hwidController.text = data['hwid'];
    if (isDebug == true) detailController.text = "test revoke";
  }


  verifyPin() async {
    // verify pin
    var isVerified = await Get.toNamed(Routes.AUTH);
    // debugPrint("isVerified : "+isVerified.toString());
    if (isVerified) requestRevoke();
  }

  String _encodePDFToBase64(File file) {
    String base64PDF;
    List<int> bytes = file.readAsBytesSync();
    base64PDF = base64Encode(bytes);

    return base64PDF;
  }

  requestRevoke() async {
    isLoading.value = true;

    // PdfDocument document = await _loadDocument();

    String? base64PDF =
        filePath.value == "" ? null : _encodePDFToBase64(File(filePath.value));

    debugPrint("PDF$base64PDF");

    final FormData formData = FormData({
      'hwid' : data['hwid'],
      'serial' : data['cert_id'],
      'revocation_detail' : detailController.text,
      'file': MultipartFile(File(filePath.value), filename: 'kindacode.jpg'),
    });

    RevokeProvider revokeProvider = RevokeProvider();
    // var request = <String, dynamic>{};
    // request['hwid'] = data['hwid'];
    // request['serial'] = data['cert_id'].toString();
    // request['revocation_detail'] = detailController.text;
    // // print(filePath.value);
    // request['supported_document'] = filePath.value;
    // debugPrint("REQ : "+ _formData.toString());
    try {
      // var result = await revokeProvider.postRevoke(request, token: token);
      var result = await revokeProvider.postRevoke(formData, token: token);
      Future.delayed(const Duration(seconds: 1));
      _showWarning(
        success: true,
        message: result.message!,
      );
    } on TimeoutException catch (e) {
      // Handle the timeout exception
      print('Timeout occurred: $e');
      // ...
    } catch (e) {
      // Handle other exceptions
      print('Error occurred: $e');
      // ...
    }
    isLoading.value = false;
    redirectOffHome();
  }

  Future<List<int>> _readDocumentData(String name,
      [bool isImage = false]) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    final ByteData data =
        await rootBundle.load(isImage ? '$path/$name' : "assets/$name");
    // print(data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
    return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  }

  // ignore: unused_element
  Future<PdfDocument> _loadDocument() async {
    if (isDebugDocument) isDebug = isDebugDocument;

    PdfDocument document;
    if (isDebug == true) {
      document = PdfDocument(inputBytes: await _readDocumentData("sample.pdf"));
      // PdfDocument(inputBytes: await _readDocumentData("digital_signature_template.pdf"));
    } else {
      //Loads an existing PDF document.
      File input = File(filePath.value);
      document = PdfDocument(inputBytes: await input.readAsBytes());
    }
    return document;
  }

  Future<void> choosePDF() async {
    // isLoading = true.obs;
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    File? file;

    if (result != null) {
      file = File(result.files.first.path!);
      filePath.value = file.path;
      fileName.value = filePath.value.split('/').last;
      // output.value = output.value.split('.').first;
      // print(file!.path);
      isEnabled.value = true;
    } else {
      debugPrint("No file selected");
      // file = Null;
    }

    // return file;
  }

  void redirectOffHome() async {
    // final HomeController homeController = Get.find<HomeController>();
    // homeController.handleRefresh();
    // Future.delayed(Duration(seconds: 2));
    await Get.offAllNamed(Routes.HOME);
  }

  redirectToDevice() {
    Get.back();
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
