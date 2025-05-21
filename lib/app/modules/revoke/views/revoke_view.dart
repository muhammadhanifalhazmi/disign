import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../utils/theme.dart';
import '../controllers/revoke_controller.dart';

class RevokeView extends GetView<RevokeController> {
  const RevokeView({super.key});

  _button() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: secondaryTextColor),
                onPressed: () => controller.redirectToDevice(),
                child: const Text('Cancel'))),
        const SizedBox(
          width: 16,
        ),
        Expanded(
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: alertDesaturatedColor),
                onPressed: () => controller.verifyPin(),
                child: const Text('Revoke'))),
      ],
    );
  }

  _chooseFile() {
    return Container(
      margin: const EdgeInsets.only(top: 45),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Supported Document : ",
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

  _revokeDetails() {
    return Container(
      margin: const EdgeInsetsDirectional.only(top: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Reason for requesting certificate revoke : "),
          const SizedBox(
            height: 8,
          ),
          TextFormField(
            keyboardType: TextInputType.multiline,
            maxLines: 4,
            controller: controller.detailController,
            decoration: InputDecoration(
              // labelText: "username",
              border: OutlineInputBorder(
                  // width: 0.0 produces a thin "hairline" border
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: accent1Color)),
              hintStyle: secondaryTextStyle,
              // hintText: "username for sign in",
              // enabledBorder: OutlineInputBorder(
              //   borderRadius: BorderRadius.circular(20),
              //   borderSide: BorderSide(color: accent1Color),
              // ),
            ),
          ),
        ],
      ),
    );
  }

  _expire() {
    return Container(
      margin: const EdgeInsetsDirectional.only(top: 15),
      child: TextFormField(
        enabled: false,
        controller: controller.expireController,
        decoration: InputDecoration(
          // prefixIcon: const Icon(
          //   Icons.person_outline,
          //   color: Colors.grey,
          // ),
          labelText: "Certificate Expired",
          labelStyle: primaryTextStyle,
          border: OutlineInputBorder(
              // width: 0.0 produces a thin "hairline" border
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: accent1Color)),
          hintStyle: secondaryTextStyle,
          // hintText: "username for sign in",
          // enabledBorder: OutlineInputBorder(
          //   borderRadius: BorderRadius.circular(20),
          //   borderSide: BorderSide(color: accent1Color),
          // ),
        ),
      ),
    );
  }

  _certificateSerial() {
    return Container(
      margin: const EdgeInsetsDirectional.only(top: 15),
      child: TextFormField(
        enabled: false,
        controller: controller.serialController,
        decoration: InputDecoration(
          // prefixIcon: const Icon(
          //   Icons.person_outline,
          //   color: Colors.grey,
          // ),
          labelText: "Certificate Serial",
          labelStyle: primaryTextStyle,
          border: OutlineInputBorder(
              // width: 0.0 produces a thin "hairline" border
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: accent1Color)),
          hintStyle: secondaryTextStyle,
          // hintText: "username for sign in",
          // enabledBorder: OutlineInputBorder(
          //   borderRadius: BorderRadius.circular(20),
          //   borderSide: BorderSide(color: accent1Color),
          // ),
        ),
      ),
    );
  }

  _hwid() {
    return Container(
      margin: const EdgeInsetsDirectional.only(top: 15),
      child: TextFormField(
        maxLines: 2,
        enabled: false,
        controller: controller.hwidController,
        decoration: InputDecoration(
          // prefixIcon: const Icon(
          //   Icons.person_outline,
          //   color: Colors.grey,
          // ),
          labelText: "Device ID",
          labelStyle: primaryTextStyle,
          border: OutlineInputBorder(
              // width: 0.0 produces a thin "hairline" border
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: accent1Color)),
          hintStyle: secondaryTextStyle,
          // hintText: "username for sign in",
          // enabledBorder: OutlineInputBorder(
          //   borderRadius: BorderRadius.circular(20),
          //   borderSide: BorderSide(color: accent1Color),
          // ),
        ),
      ),
    );
  }

  _deviceName() {
    return Container(
      margin: const EdgeInsetsDirectional.only(top: 15),
      child: TextFormField(
        enabled: false,
        controller: controller.nameController,
        decoration: InputDecoration(
          // prefixIcon: const Icon(
          //   Icons.person_outline,
          //   color: Colors.grey,
          // ),
          labelText: "Device Name",
          labelStyle: primaryTextStyle,
          border: OutlineInputBorder(
              // width: 0.0 produces a thin "hairline" border
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: accent1Color)),
          hintStyle: secondaryTextStyle,
          // hintText: "username for sign in",
          // enabledBorder: OutlineInputBorder(
          //   borderRadius: BorderRadius.circular(20),
          //   borderSide: BorderSide(color: accent1Color),
          // ),
        ),
      ),
    );
  }

  _appBar(String text) {
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
      appBar: _appBar('Request Revoke'),
      // floatingActionButton: _generateCert(),
      body: SafeArea(
          child: Obx(() => Container(
                margin: const EdgeInsets.all(defaultMargin),
                child: (controller.isLoading.value)
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : ListView(
                        children: [
                          _deviceName(),
                          _hwid(),
                          _certificateSerial(),
                          _expire(),
                          _revokeDetails(),
                          _chooseFile(),
                          const SizedBox(
                            height: 16,
                          ),
                          _button()
                        ],
                      ),
              ))),
    );
  }
}
