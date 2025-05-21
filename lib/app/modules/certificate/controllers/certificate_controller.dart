import 'dart:async';
import 'dart:io';

import 'package:basic_utils/basic_utils.dart';
import 'package:disign/app/modules/certificate/providers/certificate_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/models/csr_model.dart';
import '../../../data/models/certificate_model.dart';
import '../../../data/models/user_info_model.dart';
import '../../../helper/permission_handler.dart';
import '../../../helper/rsa_key_helper.dart';
import '../../../routes/app_pages.dart';
import '../../home/providers/user_info_provider.dart';

class CertificateController extends GetxController {
  var isEnabled = false.obs;
  var isLoading = true.obs;
  late final title;
  late final subTitle;
  late final csr;
  late final pubKeyPem;
  late UserInfo? info;
  String? PLATFORM_ID;
  String? token;
  
  final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  @override
  void onInit() {
    super.onInit();
    title = 'Well done!';
    subTitle = """You've completed the registration process. 
We are now generating your digital identity, 
and it would take several minutes.""";
    _checkLoginStatus();
  }

  @override
  void onReady() {
    super.onReady();
    createPfx();
  }

  @override
  void onClose() {}

  _getAllInfo() async {
    await _checkLoginStatus();
    await _getId();
    await _getUserDataWithRetry();
    // await Future.delayed(Duration(seconds: 1));
    isLoading.value = false;
    // debugPrint(info.cert?.validEnd!);
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

  _getUserDataWithRetry() async {
    if (PLATFORM_ID == null || token == null) {
      debugPrint("PLATFORM_ID or token is null");
      return;
    }
    
    UserInfoProvider userProvider = UserInfoProvider();
    try {
      var result = await userProvider.getUser(PLATFORM_ID!, token: token);
      info = result!;
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

  // Future<bool> _permissionHandler() async {
  //   PermissionStatus manageFilesStatus = await Permission.storage.request();
  //   if (manageFilesStatus.isGranted || manageFilesStatus.isLimited) return true;
  //   if(manageFilesStatus.isDenied || manageFilesStatus.isPermanentlyDenied) openAppSettings();
  //   return false;
  // }

  createPfx() async {
    await _getAllInfo();

    var isGranted = await storagePermission();
    if (isGranted) {
      await _asymKeyGen();
      var cert = await _sendCsrWithRetry();
      Future.delayed(const Duration(seconds: 1));
      if (cert?.userCertificate != null) {
        await _writeCertificate(cert);
        Future.delayed(const Duration(seconds: 1));
        await _convertPfx();
      } else {
        redirectToLoginPage();
      }
      isEnabled.value = true;
    }
    // else createPfx();
  }

  _convertPfx() async {
    //Get external storage directory
    final directory = await getApplicationDocumentsDirectory();
    // final directory = await getDirectory();

    //Get directory path
    final path = directory.path;

    // final String privateKey = await rootBundle.loadString('assets/privkey.pem');
    // final String certificates = await rootBundle.loadString('assets/cert.pem');
    final String privateKey = await File('$path/privkey.pem').readAsString();
    final String certificates = await File('$path/cert.pem').readAsString();
    print(privateKey);
    print(certificates);

    final pfx = Pkcs12Utils.generatePkcs12(privateKey, [certificates],
        password: '1234');
    // print("generated");

    // String s = new String.fromCharCodes(pfx);
    // print(s);
    // var outputAsUint8List = new Uint8List.fromList(s.codeUnits);
    // print(outputAsUint8List);

    //Save the PDF document
    final List<int> bytes = pfx;

    // Set filename and ext
    const filename = "yeah.pfx";

    //Save and dispose the PDF document.
    File file = File('$path/$filename');
    print(file.path);
    await file.writeAsBytes(bytes, flush: true);
  }

  _writeCertificate(CsrResponse? certificate) {
    _saveBytes(certificate?.userCertificate, "cert");
    _saveBytes(certificate?.certificateChain, "chain");
  }

  Future<CsrResponse?> _sendCsrWithRetry() async {
    if (PLATFORM_ID == null) {
      debugPrint("PLATFORM_ID is null");
      return null;
    }
    
    CertificateSigningRequests csrModel = CertificateSigningRequests(
        csr: csr, pubkey: pubKeyPem, hwid: PLATFORM_ID);
    CertificateProvider certificateProvider = CertificateProvider();
    try {
      // Start a timer and wait for a response within the specified duration
      return await certificateProvider.postCertificate(csrModel, token: token);
    } on TimeoutException catch (e) {
      // Handle the timeout exception
      print('Timeout occurred: $e');
      // ...
      await Future.delayed(const Duration(seconds: 3));
      return await _sendCsrWithRetry();
    } catch (e) {
      // Handle other exceptions
      print('Error occurred: $e');
      // ...
    }
    return null;
  }

  _createCSR(RSAPrivateKey privKey, RSAPublicKey pubKey) {
    Map<String, String> x509Subject = {
      'CN': (info?.user?.name!) ?? 'Irfan',
      'C': 'ID',
      'ST': 'Surabaya',
      'L': 'Keputih',
      'O': 'Politeknik Elektronika Negeri Surabaya',
      'OU': 'Signature Service',
      'emailAddress': (info?.user?.email!) ?? 'it@disign.id'
    };

    // AsymmetricKeyPair keyPair = CryptoUtils.generateEcKeyPair();
    csr = X509Utils.generateRsaCsrPem(x509Subject, privKey, pubKey);
    print(csr);
    _saveBytes(csr, "csr");
  }

  _asymKeyGen() {
    final pair = generateRSAkeyPair(exampleSecureRandom());
    final public = pair.publicKey;
    final private = pair.privateKey;

    print(CryptoUtils.encodeRSAPublicKeyToPem(public));
    print(CryptoUtils.encodeRSAPrivateKeyToPem(private));

    _createCSR(private, public);
    pubKeyPem = CryptoUtils.encodeRSAPublicKeyToPem(public);
    final privKeyPem = CryptoUtils.encodeRSAPrivateKeyToPem(private);
    _saveBytes(pubKeyPem, "pubkey");
    _saveBytes(privKeyPem, "privkey");
  }

  _saveBytes(document, String name) async {
    //Get external storage directory
    final directory = await getApplicationDocumentsDirectory();
    // final directory = await getDirectory();

    //Get directory path
    final path = directory.path;
    // //Save and launch file.
    // await FileSaveHelper.saveAndLaunchFile(bytes, 'SignedPdf2.pdf');

    //Save and dispose the PDF document.
    File file = File('$path/$name.pem');
    await file.writeAsString(document, flush: true);
    print('$path/$name.pem');
    print("===\n\n===");
  }

  _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (isLoggedIn) {
      // User is logged in, navigate to the home screen.
      PLATFORM_ID = prefs.getString('PLATFORM_ID');
      token = prefs.getString('token');
      debugPrint(token);
    } else {
      // User is not logged in, navigate to the login screen.
    }
  }

  void redirectToLoginPage() {
    Get.offNamed(Routes.LOGIN);
  }

  void redirectToHomePage() {
    Get.offNamed(Routes.HOME);
  }
}