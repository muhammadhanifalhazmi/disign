import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../utils/theme.dart';
import '../controllers/list_device_controller.dart';

class ListDeviceView extends GetView<ListDeviceController> {
  const ListDeviceView({super.key});

  _certificateCard(index) {
    return Card(
      color: (controller.listDevices.value.devices![index].lastCertificate
                  ?.isRevoked ==
              1)
          ? alertDesaturatedColor
          : primaryColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 1,
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Device name :",
                      style:
                          secondaryTextStyle.copyWith(color: Colors.grey[300]),
                    ),
                    Text(
                      (controller
                              .listDevices.value.devices![index].deviceName) ??
                          "iPhone X",
                      style: secondaryTextStyle.copyWith(color: Colors.white),
                    ),
                  ],
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "Expires on",
                      style:
                          secondaryTextStyle.copyWith(color: Colors.grey[300]),
                    ),
                    Text(
                      (controller.listDevices.value.devices![index]
                              .lastCertificate?.expires) ??
                          "--/--/--",
                      style: secondaryTextStyle.copyWith(color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
            const Divider(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Device ID : ',
                  style: secondaryTextStyle.copyWith(color: Colors.grey[300]),
                ),
                Text(controller.listDevices.value.devices![index].hwid!,
                    style: secondaryTextStyle.copyWith(color: Colors.white))
              ],
            ),
            const Divider(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Last Login Device : ',
                  style: secondaryTextStyle.copyWith(color: Colors.grey[300]),
                ),
                Text(controller.listDevices.value.devices![index].lastActive!,
                    style: secondaryTextStyle.copyWith(color: Colors.white))
              ],
            ),
            const Divider(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Certificate Serial : ',
                  style: secondaryTextStyle.copyWith(color: Colors.grey[300]),
                ),
                Text(
                    controller.listDevices.value.devices![index]
                        .lastCertificate!.certificateSrl
                        .toString(),
                    style: secondaryTextStyle.copyWith(color: Colors.white))
              ],
            ),
            const Divider(),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Status : ',
                      style:
                          secondaryTextStyle.copyWith(color: Colors.grey[300]),
                    ),
                    Text(controller.getStatus(index),
                        style: secondaryTextStyle.copyWith(color: Colors.white))
                  ],
                ),
                (controller.listDevices.value.devices![index].lastCertificate
                            ?.isRevoked ==
                        1)
                    ? const SizedBox()
                    : const Spacer(),
                (controller.listDevices.value.devices![index].lastCertificate
                            ?.isRevoked ==
                        1)
                    ? const SizedBox()
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 0, // Set the elevation value
                          backgroundColor:
                              alertDesaturatedColor, // Set the button color
                          // You can also customize other properties like padding, shape, etc. here
                        ),
                        onPressed: () => controller.redirectToRevokePage(index),
                        child: Text(
                          'Revoke',
                          style:
                              secondaryTextStyle.copyWith(color: Colors.white),
                          // textAlign: TextAlign.end,
                        )),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ignore: unused_element
  _header() {
    // TODO : Bisa dikasih ornamen
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

  // ignore: unused_element
  _generateCert() {
    return FloatingActionButton(
        backgroundColor: primaryColor,
        // backgroundColor: accent1Color,
        child: const Icon(Icons.dashboard_customize_rounded),
        onPressed: () => controller.redirectToCertificatePage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      resizeToAvoidBottomInset: false,
      appBar: _appBar('Devices'),
      // floatingActionButton: _generateCert(),
      body: SafeArea(
        child: Obx(() => (controller.isLoading.value)
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Container(
                // margin: EdgeInsets.all(defaultMargin),
                margin: const EdgeInsets.symmetric(horizontal: defaultMargin),
                child: RefreshIndicator(
                  onRefresh: () => controller.handleRefresh(),
                  child: ListView.builder(
                    itemCount: controller.listDevices.value.devices!.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.only(top: defaultMargin),
                        child:
                            controller.listDevices.value.devices!.length - 1 ==
                                    index
                                ? Column(
                                    children: [
                                      _certificateCard(index),
                                      Container(
                                        margin: const EdgeInsets.symmetric(
                                            vertical: defaultMargin),
                                        child: Text(
                                          "pull to refresh",
                                          style: secondaryTextStyle,
                                        ),
                                      ),
                                    ],
                                  )
                                : _certificateCard(index),
                      );
                    },
                  ),
                ),
              )),
      ),
    );
  }
}
