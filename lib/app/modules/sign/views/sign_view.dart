import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../utils/theme.dart';
import '../controllers/sign_controller.dart';

class SignView extends GetView<SignController> {
  const SignView({super.key});

  btnSign() {
    return Padding(
      padding: const EdgeInsets.only(bottom: defaultMargin),
      child: Align(
        // alignment: Alignment.center,
        child: TextButton(
            onPressed: controller.isEnabled.value ? () => controller.verifyPin() : null,
            style: ButtonStyle(
                fixedSize: WidgetStateProperty.all<Size>(const Size(190, 40)),
                backgroundColor: WidgetStateProperty.all<Color>(
                    (controller.isEnabled.value)
                        ? primaryColor
                        : secondaryTextColor),
                shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ))),
            child: Text(
              "sign",
              style: primaryTextStyle.copyWith(
                  color: (controller.isEnabled.value)
                      ? whiteColor
                      : disabledTextColor),
            )),
      ),
    );
  }

  resultPath(){
    return Padding(
      padding: const EdgeInsets.only(top: 30),
      child: Text("Result Path: \n${controller.output.value}", style: primaryTextStyle,),
    );
  }

  chooseReason() {
    return Container(
      margin: const EdgeInsets.only(top: 45),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Reason : ",
              style: secondaryTextStyle.copyWith(fontSize: mediumFs)),
          DropdownButtonFormField(
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: secondaryTextColor, width: 2),
                  borderRadius: BorderRadius.circular(15)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: primaryColor, width: 2),
                  borderRadius: BorderRadius.circular(15)),
              filled: true,
              fillColor: whiteColor,
            ),
            dropdownColor: whiteColor,
            value: controller.dropdownValue.value,
            onChanged: ((String? newValue) {
              controller.setSelected(newValue!);
            }),
            items: controller.reasonList
                .map<DropdownMenuItem<String>>((String selected) {
              return DropdownMenuItem<String>(
                value: selected,
                child: Text(
                  selected,
                  style: const TextStyle(fontSize: 20),
                ),
              );
            }).toList(),
          )
        ],
      ),
    );
  }

  chooseFile() {
    return Container(
      margin: const EdgeInsets.only(top: 45),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("filename : ",
              style: secondaryTextStyle.copyWith(fontSize: mediumFs)),
          GestureDetector(
            onTap: () => controller.choosePDF(),
            child: Text(
                  (controller.fileName.value == "")
                      ? "choose file"
                      : controller.fileName.value,
                  style: primaryTextStyle.copyWith(
                      fontSize: largeFs, decoration: TextDecoration.underline),
                ),
          )
        ],
      ),
    );
  }

  appBar(String text) {
    return AppBar(
      // automaticallyImplyLeading: false,
      // leading: GestureDetector(
      //   child: Container(
      //       margin: const EdgeInsetsDirectional.only(top: defaultMargin),
      //       child: Icon(Icons.arrow_back, color: secondaryTextColor)),
      //   onTap: () => {},
      // ),
      title: Container(
        // margin: const EdgeInsets.only(top: defaultMargin),
        child: Text(
          text,
          style: secondaryTextStyle,
        ),
      ),
      centerTitle: true,
      backgroundColor: whiteColor,
      elevation: 0,
      iconTheme: const IconThemeData(color: Colors.grey),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      resizeToAvoidBottomInset: false,
      appBar: appBar('Sign Document'),
      body: SafeArea(
        child: Container(
            margin: const EdgeInsets.symmetric(horizontal: defaultMargin),
            child: Obx(() => Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: controller.isLoading.value ? [const Center(child: CircularProgressIndicator())] : [
                          chooseFile(),
                          chooseReason(),
                          (controller.output.value == "") ? const SizedBox() : resultPath(),
                          const Spacer(),
                          btnSign(),
                        ],
                ))),
      ),
    );
  }
}
