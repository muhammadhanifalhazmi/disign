import 'package:flutter/material.dart';

import '../utils/theme.dart';

class CustomHeaderWidget extends StatelessWidget {
  final String title;
  final String subTitle;
  final double marginTop;

  const CustomHeaderWidget({super.key, required this.title, this.subTitle = '', this.marginTop = 45});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsetsDirectional.only(top: marginTop),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: headerTextStyle.copyWith(fontSize: 20),
          ),
          const SizedBox(height: 8),
          (subTitle != '')
              ? Text(
                  subTitle,
                  style: secondaryTextStyle,
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}

header({required String title, String subTitle = '', double marginTop = 45}) {
  
}
