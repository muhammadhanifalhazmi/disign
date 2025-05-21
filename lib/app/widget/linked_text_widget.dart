import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/theme.dart';

class LinkedTextWidget extends StatelessWidget {
  final String text;
  final String routeName;
  final dynamic colour;
  const LinkedTextWidget(
      {super.key, required this.text, required this.routeName, this.colour});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: GestureDetector(
        // onTap: () => Navigator.pushNamed(context, routeName),
        onTap: () => Get.toNamed(routeName),
        child: Text(
          text,
          style: GoogleFonts.poppins(
            decoration: TextDecoration.underline,
            color: (colour != null) ? colour : primaryColor,
          ),
        ),
      ),
    );
  }
}
