import 'package:disign/app/utils/theme.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../widget/header_widget.dart';
import '../controllers/certificate_controller.dart';

class CertificateView extends GetView<CertificateController> {
  const CertificateView({super.key});

  nextBtn() {
    return Obx(() => Padding(
          padding: const EdgeInsets.only(bottom: defaultMargin),
          child: Align(
            // alignment: Alignment.center,
            child: TextButton(
                onPressed: controller.isEnabled.value
                    ? () => controller.redirectToHomePage()
                    : null,
                style: ButtonStyle(
                    fixedSize:
                        WidgetStateProperty.all<Size>(const Size(190, 40)),
                    backgroundColor: WidgetStateProperty.all<Color>(
                        (controller.isEnabled.value)
                            ? primaryColor
                            : secondaryTextColor),
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ))),
                child: Text(
                  "continue",
                  style: primaryTextStyle.copyWith(
                      color: (controller.isEnabled.value)
                          ? whiteColor
                          : disabledTextColor),
                )),
          ),
        ));
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
      appBar: appBar(""),
      body: SafeArea(
        child: Obx(() => (controller.isLoading.value)
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Container(
                margin: const EdgeInsets.all(defaultMargin),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomHeaderWidget(
                          title: controller.title,
                          subTitle: controller.subTitle,
                          marginTop: 15),
                      const Spacer(),
                      nextBtn(),
                    ]),
              )),
      ),
    );
  }
}
