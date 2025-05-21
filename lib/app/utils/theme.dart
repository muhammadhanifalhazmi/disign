import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const defaultMargin = 30.00;

// #opacity      0% — 00
// 100% — FF    50% — 80
// 95% — F2     45% — 73
// 90% — E6     40% — 66
// 85% — D9     35% — 59
// 80% — CC     30% — 4D
// 75% — BF     25% — 40
// 70% — B3     20% — 33
// 65% — A6     15% — 26
// 60% — 99     10% — 1A
// 55% — 8C      5% — 0D

Color alertColor = const Color(0xff8c5349);
Color alertDesaturatedColor = const Color(0xffb2543d);
Color accent1Color = const Color(0x804B82AB);
Color accent2Color = const Color(0xffFDFDFF);
Color placeholderColor = const Color(0xffCACACA);
Color primaryColor = const Color(0xff4B82AB);
Color whiteColor = const Color(0xffFFFFFF);
Color primaryTextColor = const Color(0xff000000);
Color secondaryTextColor = const Color(0xff999999);
Color disabledTextColor = const Color(0xff616161);


TextStyle signTextStyle = GoogleFonts.kaushanScript(
  color: primaryColor
);

TextStyle headerTextStyle = GoogleFonts.poppins(
  color: primaryColor
);

TextStyle primaryTextStyle = GoogleFonts.poppins(
  color: primaryTextColor
);

TextStyle secondaryTextStyle = GoogleFonts.poppins(
  color: secondaryTextColor
);

TextStyle alertTextStyle = GoogleFonts.poppins(
  color: alertColor
);

FontWeight light = FontWeight.w300;
FontWeight regular = FontWeight.w400;
FontWeight medium = FontWeight.w500;
FontWeight semiBold = FontWeight.w600;
FontWeight bold = FontWeight.w700;
FontWeight extraBold = FontWeight.w900;

const double xSmallFs = 10;
const double smallFs = 12;
const double baseFs = 14;
const double mediumFs = 16;
const double largeFs = 18;
const double titleFs = 20;