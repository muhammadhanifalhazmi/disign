import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../utils/theme.dart';
import '../controllers/auth_controller.dart';

class AuthView extends GetView<AuthController> {
  const AuthView({super.key});

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
    controller.isVerified = false;
    return Scaffold(
        backgroundColor: whiteColor,
        resizeToAvoidBottomInset: false,
        appBar: _appBar('Enter PIN'),
        body: SafeArea(
          child: Obx(
            () => (controller.isLoading.value == true)
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Container(
                    margin: const EdgeInsets.all(defaultMargin),
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Enter your PIN to proceed signing',
                          style: primaryTextStyle.copyWith(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        PinCodeTextField(
                          // controller: controller.pinController,
                          autoFocus: true,
                          autoUnfocus: true,
                          // showCursor: true,
                          appContext: context,
                          length: 6,
                          autoDismissKeyboard: false,
                          obscureText: true,
                          blinkWhenObscuring: true,
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            debugPrint(value);
                          },
                          onCompleted: (value) =>
                              controller.comparePinWithRetry(value),
                          pinTheme: PinTheme(
                            shape: PinCodeFieldShape.box,
                            inactiveColor: Colors.grey[600],
                            inactiveFillColor: Colors.grey[800],
                            borderRadius: BorderRadius.circular(15),
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                        ),
                        TextButton(
                            onPressed: () => {debugPrint("test")},
                            child: const Text('asdas'))
                      ],
                    ),
                  ),
          ),
        ));
  }
}
