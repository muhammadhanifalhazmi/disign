import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/theme.dart';
class CustomButtonWidget extends StatelessWidget {
  final String text;
  final String routeName;
  final bool isEnabled;
  const CustomButtonWidget({ super.key, required this.text, required this.routeName, this.isEnabled = true });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: TextButton(
        onPressed: () => Navigator.pushNamed(context, routeName),
        style: ButtonStyle(
          fixedSize: WidgetStateProperty.all<Size>(const Size(190, 40)),
          backgroundColor: WidgetStateProperty.all<Color>((isEnabled) ? primaryColor : secondaryTextColor),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
            )
          )
        ), 
        child: Text(
          text,
          style: GoogleFonts.poppins(color: (isEnabled) ? whiteColor : disabledTextColor),
        )
      ),
    );
  }
}

