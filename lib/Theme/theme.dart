import 'package:flutter/material.dart';

const Color primaryColor_ = Color(0xFFFAFAFA);
const Color secondaryColor_ = Color(0xFFFFFFFF);
const Color teritoryColor_ = Color(0xFF087C7C);

const Color textColor_ = Color(0xFF4D5454);
Color lightTextColor_ = const Color(0xFF4D5454).withOpacity(0.5);
Color widgetsBorderColorLight = const Color(0xffEEEEEE).withOpacity(0.6);

class AppTheme {
  static Color primaryColor = Color(0xFFFAFAFA);
  static Color backgroundColor = primaryColor_;
  static Color teretoryColor = teritoryColor_;
  static Color secondaryColor = secondaryColor_;
  static Color textColor = textColor_;
  static Color lightTextColor = lightTextColor_;
  static Color borderColor = widgetsBorderColorLight;
}
