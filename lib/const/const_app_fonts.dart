import 'package:task/const/const_color.dart';
import 'package:flutter/material.dart';

class AppConstFonts {
  static const String ralewayBlack = 'Raleway-Black';
  static const String ralewayBlackItalic = 'Raleway-BlackItalic';
  static const String ralewayBold = 'Raleway-Bold';
  static const String ralewayBoldItalic = 'Raleway-BoldItalic';
  static const String ralewayExtraBold = 'Raleway-ExtraBold';
  static const String ralewayExtraBoldItalic = 'Raleway-ExtraBoldItalic';
  static const String ralewayExtraLight = 'Raleway-ExtraLight';
  static const String ralewayExtraLightItalic = 'Raleway-ExtraLightItalic';
  static const String ralewayItalic = 'Raleway-Italic';
  static const String ralewayLight = 'Raleway-Light';
  static const String ralewayLightItalic = 'Raleway-LightItalic';
  static const String ralewayMedium = 'Raleway-Medium';
  static const String ralewayMediumItalic = 'Raleway-MediumItalic';
  static const String ralewayRegular = 'Raleway-Regular';
  static const String ralewaySemiBold = 'Raleway-SemiBold';
  static const String ralewaySemiBoldItalic = 'Raleway-SemiBoldItalic';
  static const String ralewayThin = 'Raleway-Thin';
  static const String ralewayThinItalic = 'Raleway-ThinItalic';
  static const String pattayaRegular = 'Pattaya-Regular';

}

class AppFonts {
  // Font Family
  static const String raleway = 'Raleway';

  // Font Weights
  static const FontWeight thin = FontWeight.w100;
  static const FontWeight extraLight = FontWeight.w200;
  static const FontWeight light = FontWeight.w300;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
  static const FontWeight extraBold = FontWeight.w800;
  static const FontWeight black = FontWeight.w900;

  // Commonly used TextStyle combinations
  static TextStyle ralewayThin = ralewayStyle(
    fontFamily: raleway,
    fontWeight: thin,
  );

  static TextStyle ralewayExtraLight = ralewayStyle(
    fontFamily: raleway,
    fontWeight: extraLight,
  );

  static TextStyle ralewayLight = ralewayStyle(
    fontFamily: raleway,
    fontWeight: light,
  );

  static TextStyle ralewayRegular = ralewayStyle(
    fontFamily: raleway,
    fontWeight: regular,
  );

  static TextStyle ralewayMedium = ralewayStyle(
    fontFamily: raleway,
    fontWeight: medium,
  );

  static TextStyle ralewaySemiBold = ralewayStyle(
    fontFamily: raleway,
    fontWeight: semiBold,
  );

  static TextStyle ralewayBold = ralewayStyle(
    fontFamily: raleway,
    fontWeight: bold,
  );

  static TextStyle ralewayExtraBold = ralewayStyle(
    fontFamily: raleway,
    fontWeight: extraBold,
  );

  static TextStyle ralewayBlack = ralewayStyle(
    fontFamily: raleway,
    fontWeight: black,
  );

  // Italic versions
  static TextStyle ralewayThinItalic = ralewayStyle(
    fontFamily: raleway,
    fontWeight: thin,
    fontStyle: FontStyle.italic,
  );

  static TextStyle ralewayExtraLightItalic = ralewayStyle(
    fontFamily: raleway,
    fontWeight: extraLight,
    fontStyle: FontStyle.italic,
  );

  static TextStyle ralewayLightItalic = ralewayStyle(
    fontFamily: raleway,
    fontWeight: light,
    fontStyle: FontStyle.italic,
  );

  static TextStyle ralewayItalic = ralewayStyle(
    fontFamily: raleway,
    fontWeight: regular,
    fontStyle: FontStyle.italic,
  );

  static TextStyle ralewayMediumItalic = ralewayStyle(
    fontFamily: raleway,
    fontWeight: medium,
    fontStyle: FontStyle.italic,
  );

  static TextStyle ralewaySemiBoldItalic = ralewayStyle(
    fontFamily: raleway,
    fontWeight: semiBold,
    fontStyle: FontStyle.italic,
  );

  static TextStyle ralewayBoldItalic = ralewayStyle(
    fontFamily: raleway,
    fontWeight: bold,
    fontStyle: FontStyle.italic,
  );

  static TextStyle ralewayExtraBoldItalic = ralewayStyle(
    fontFamily: raleway,
    fontWeight: extraBold,
    fontStyle: FontStyle.italic,
  );

  static TextStyle ralewayBlackItalic = ralewayStyle(
    fontFamily: raleway,
    fontWeight: black,
    fontStyle: FontStyle.italic,
  );

  // Helper methods for custom sizes
  static TextStyle ralewayStyle({
    FontWeight fontWeight = FontWeight.w400,
    double size = 14,
    String fontFamily = raleway,
    Color color = AppColors.black,
    FontStyle fontStyle = FontStyle.normal,
    double? letterSpacing,
    double? height,
  }) {
    return TextStyle(
      fontFamily: fontFamily,
      fontWeight: fontWeight,
      fontSize: size,
      color: color,
      fontStyle: fontStyle,
      letterSpacing: letterSpacing,
      height: height,
    );
  }
}