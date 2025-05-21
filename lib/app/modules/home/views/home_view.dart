import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:get/get.dart';

import '../../../utils/theme.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  listFiles(height) {
    return SizedBox(
        height: height * 0.5,
        child: Obx(() => ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            separatorBuilder: (context, index) => const Divider(
                  thickness: 1,
                ),
            shrinkWrap: true,
            itemCount: controller.filenames.length,
            itemBuilder: (context, int index) {
              return Slidable(
                key: Key(index.toString()),
                endActionPane: ActionPane(motion: const ScrollMotion(), children: [
                  SlidableAction(
                      borderRadius: BorderRadius.circular(10),
                      backgroundColor: Colors.red.shade400,
                      icon: Icons.delete_forever,
                      onPressed: (context) =>
                          controller.deletePdf(controller.files[index])),
                ]),
                child: Column(
                  children: [
                    ListTile(
                        leading: Icon(
                          Icons.picture_as_pdf_rounded,
                          color: accent1Color,
                        ),
                        trailing: InkWell(
                            onTap: () =>
                                controller.sharePdf(controller.files[index]),
                            child: const Icon(Icons.share)),
                        title: InkWell(
                            onTap: () =>
                                controller.openPdf(controller.files[index]),
                            child: Text("${controller.filenames[index]}"))),
                    controller.filenames.length - 1 == index
                        ? Container(
                            margin:
                                const EdgeInsets.symmetric(vertical: defaultMargin),
                            child: Text(
                              "pull to refresh",
                              style: secondaryTextStyle,
                            ),
                          )
                        : const SizedBox(),
                  ],
                ),
              );
            })));
  }

  signedPdfs() {
    return TextButton(onPressed: () => {}, child: const Text("GetFiles"));
  }

  // generateCsr() {
  //   return ElevatedButton(
  //     onPressed: () => controller.redirectToCertificatePage(),
  //     style: ButtonStyle(
  //         // fixedSize: MaterialStateProperty.all<Size>(const Size(190, 40)),
  //         backgroundColor: MaterialStateProperty.all<Color>(primaryColor),
  //         shape: MaterialStateProperty.all<RoundedRectangleBorder>(
  //             RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(18.0),
  //         ))),
  //     child: Padding(
  //       padding: const EdgeInsets.all(8.0),
  //       child: Column(
  //         // mainAxisSize: MainAxisSize.min,
  //         children: [
  //           Icon(
  //             // <-- Icon
  //             Icons.vpn_key_rounded,
  //             size: 64,
  //           ),
  //           SizedBox(
  //             height: 5,
  //           ),
  //           Text('Generate Certificate'), // <-- Text
  //         ],
  //       ),
  //     ),
  //   );
  // }

  signPdf() {
    return FloatingActionButton.extended(
        backgroundColor: primaryColor,
        // backgroundColor: accent1Color,
        label: const Text('Sign PDF'),
        icon: const Icon(Icons.edit_document),
        onPressed: () => controller.redirectToSignPage());
  }

  _header() {
    // TODO : Bisa dikasih ornamen
    return Container(
      margin: const EdgeInsets.only(top: 0),
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Welcome back fellas!",
            style: headerTextStyle.copyWith(fontSize: 20),
          ),
          const SizedBox(height: 8),
          Card(
            color: (controller.isRevoked.value == true)
                ? alertDesaturatedColor
                : accent1Color,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            elevation: 1,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.blueGrey[200],
                        // radius: 1,
                        child: const Icon(
                          Icons.person,
                          color: Colors.white,
                        ), //CircleAvatar
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Text(
                        (controller.info.value.user?.name) ?? "Irfan",
                        style: primaryTextStyle.copyWith(
                            fontSize: mediumFs, color: whiteColor),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.arrow_forward_ios_rounded),
                        color: Colors.blueGrey[200],
                        onPressed: () => (controller.isRevoked.value == true)
                            ? {}
                            : controller.redirectToDevicesPage(),
                      )
                    ],
                  ),
                  const Divider(
                    color: Colors.white,
                  ),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Device name :",
                            style: secondaryTextStyle.copyWith(
                                color: Colors.grey[300]),
                          ),
                          Text(
                            (controller.info.value.device?.deviceName) ??
                                "iPhone X",
                            style: secondaryTextStyle.copyWith(
                                color: Colors.white),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            (controller.isRevoked.value == true)
                                ? "Status"
                                : "Expires on",
                            style: secondaryTextStyle.copyWith(
                                color: Colors.grey[300]),
                          ),
                          Text(
                            (controller.isRevoked.value == true)
                                ? "Revoked"
                                : ((controller.info.value.device!
                                        .activeCertificate?.expires) ??
                                    "--/--/--"),
                            style: secondaryTextStyle.copyWith(
                                color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(),
        ],
      ),
    );
  }

  appBar(String text) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Center(
            child: Text(
              "",
              style: secondaryTextStyle,
              textAlign: TextAlign.center,
            ),
          ),
          const Spacer(),
          InkWell(
            onTap: () => controller.logoutWithRetry(),
            child: Icon(
              Icons.logout_rounded,
              color: secondaryTextColor,
            ),
          )
        ],
      ),
      centerTitle: true,
      backgroundColor: whiteColor,
      elevation: 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: appBar("Home"),
      floatingActionButton: signPdf(),
      body: SafeArea(
        child: Obx(() => (controller.isLoading.value)
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Container(
                // height: height,
                padding: const EdgeInsets.all(defaultMargin),
                child: Column(
                  children: [
                    _header(),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      'You can verify signed pdf using Foxit PDF',
                      style: secondaryTextStyle,
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    const Text('Signed PDF'),
                    const Divider(
                      thickness: 3,
                    ),
                    RefreshIndicator(
                      color: whiteColor,
                      backgroundColor: primaryColor,
                      onRefresh: () => controller.handleRefresh(),
                      child: listFiles(height),
                    ),
                  ],
                ),
              )),
      ),
    );
  }
}
