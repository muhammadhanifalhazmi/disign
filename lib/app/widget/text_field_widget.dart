import 'package:flutter/material.dart';

import '../utils/theme.dart';

class CustomTextFieldWidget extends StatelessWidget {
  final String text;
  const CustomTextFieldWidget({ super.key, required this.text });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsetsDirectional.only(top: 15),
      child: TextFormField(
        decoration: InputDecoration(
            // prefixIcon: const Icon(
            //   Icons.person,
            //   color: Colors.grey,
            // ),
          border: OutlineInputBorder(
            // width: 0.0 produces a thin "hairline" border
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide(color: accent1Color)
          ),
          hintStyle: secondaryTextStyle,
          hintText: text,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide(color: accent1Color),
          ),
        ),
      ),
    );
  }
}