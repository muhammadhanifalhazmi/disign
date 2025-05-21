import 'dart:io';

import 'package:disign/app/routes/app_pages.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

import '../../../helper/get_directory.dart';
import '../../../utils/debug_values.dart';

class SignController extends GetxController {
  var isDebug = DEBUG.IS_DEBUG;
  var isDebugDocument = true;
  var count = "0".obs;
  var isLoading = false.obs;
  var isEnabled = false.obs;
  var filePath = "".obs;
  var fileName = "".obs;
  var output = "".obs;
  // File? output;
  RxString dropdownValue = 'I approve this document'.obs;
  final RxList<String> reasonList =
      ['I approve this document', 'I own this document'].obs;

  @override
  void onInit() {
    super.onInit();
    if (isDebug == true) isEnabled.value = true;
  }


  @override
  void onClose() {}

  void redirectToHomePage()async {
    fileName.value = "";
    filePath.value = "";
    output.value = "";
    await FilePicker.platform.clearTemporaryFiles();

    Get.offNamed(Routes.HOME);
  }

  verifyPin() async {
    // verify pin
    var isVerified = await Get.toNamed(Routes.AUTH);
    // debugPrint("isVerified : "+isVerified.toString());
    if (isVerified) signPDF();
  }

  // Future<Directory> getDirectory() async {
  //   //Get external storage directory
  //   // final directory = await getExternalStorageDirectory();
  //   Directory? directory;
  //   if (Platform.isAndroid)
  //     directory = Directory("/storage/emulated/0/Documents/disign");
  //   if(Platform.isIOS) directory = await getApplicationDocumentsDirectory();
  //   if (!await directory!.exists()) {
  //     directory.create(recursive: true);
  //   }
  //   return directory;
  //   //Get directory path
  //   // final path = directory!.path;
  // }

  Future<List<int>> _readDocumentData(String name,
      [bool isImage = false]) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    final ByteData data =
        await rootBundle.load(isImage ? '$path/$name' : "assets/$name");
    // print(data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
    return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  }

  Future<PdfDocument> _loadDocument() async {
    if(isDebugDocument) isDebug = isDebugDocument;
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

  void signPDF() async {
    isLoading.value = true;
    // debugPrint(this.filePath.value);

    PdfDocument document = await _loadDocument();

    // get document page
    PdfPage page = document.pages[0];

    final pageSize = page.getClientSize();

    // debugPrint(pageSize.width.toString() + " == " + pageSize.height.toString());

    //Get the signatue field bounds.
    final Rect bounds =
        Rect.fromLTWH(pageSize.width - 200, pageSize.height - 120, 140, 40);

    // Create a signature form field and add it to the document.
    document.form.fields
        .add(PdfSignatureField(page, 'signature', //pages[page_index]
            bounds: bounds,
            highlightMode: PdfHighlightMode.push));

    //Get the signature field.
    final PdfSignatureField signatureField =
        document.form.fields[0] as PdfSignatureField;

    // get pfx path
    final dir = await getApplicationDocumentsDirectory();
    final pfxPath = "${dir.path}/yeah.pfx";

    final PdfCertificate certificate =
        PdfCertificate(await File(pfxPath).readAsBytes(), '1234');

    final String subject = certificate.subjectName;
    final now = DateFormat("EEEE, MMM dd y").format(DateTime.now());

    //Creates a digital signature and sets signature information.
    signatureField.signature = PdfSignature(
        certificate: certificate,
        signedName: subject,
        signedDate: DateTime.now(),
        // contactInfo: 'Irfan@owned.us',
        locationInfo: 'Surabaya, Indonesia',
        reason: dropdownValue.value,
        digestAlgorithm: DigestAlgorithm.sha256,
        cryptographicStandard: CryptographicStandard.cades);
    // cryptographicStandard: CryptographicStandard.cms);

    //Set the default appearance.
    document.form.setDefaultAppearance(true);

    final Rect signatureBounds = signatureField.bounds;

    //Gets the signature field appearance graphics.
    PdfGraphics? graphics = signatureField.appearance.normal.graphics;
    if (graphics != null) {
      graphics.drawRectangle(
          pen: PdfPens.black,
          bounds: Rect.fromLTWH(
              0, 0, signatureBounds.width, signatureBounds.height));
      graphics.drawImage(PdfBitmap(await _readDocumentData('signature.png')),
          const Rect.fromLTWH(2, 1, 30, 30));
      graphics.drawString(
          'Digitally signed by $subject \r\nReason: $dropdownValue \r\nDate: $now',
          PdfStandardFont(PdfFontFamily.helvetica, 7),
          // bounds: Rect.fromLTWH(0, 0, bounds.width, bounds.height),
          bounds: Rect.fromLTWH(
              35, 0, signatureBounds.width - 35, signatureBounds.height),
          brush: PdfBrushes.black,
          format: PdfStringFormat(lineAlignment: PdfVerticalAlignment.middle));
    }

    //Add the signature field to the document.
    document.form.fields.add(signatureField);

    //Get external storage directory
    // final directory = await getApplicationSupportDirectory(); // /data/user/0/com.rfms.disign
    final directory = await getDirectory();

    //Get directory path
    final path = directory.path;
    // final path = "/storage/emulated/0/Documents";

    //Save the PDF document
    final List<int> bytes = await document.save();

    //Dispose the document.
    document.dispose();

    // set output filename and path
    var outputFileName = filePath.value.split('/').last;
    outputFileName = "${outputFileName.split('.').first}_${DateTime.now().toString().split('.').last}";

    // set output file path
    File file = File('$path/$outputFileName.pdf');
    debugPrint('$path/$outputFileName.pdf');
    output.value = file.path;

    //Save and dispose the PDF document.
    // await file.writeAsBytes(bytes, flush: true);
    file.writeAsBytesSync(bytes);

    isLoading.value = false;

    await Future.delayed(const Duration(seconds: 3));
    redirectToHomePage();
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

  void setSelected(String value) {
    dropdownValue.value = value;
  }
}
