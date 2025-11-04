/// Application color constants and utilities
///
/// This file centralizes all hardcoded color values used throughout the app,
/// making it easy to maintain and modify the color scheme.
library;
import 'package:flutter/material.dart';

class AppColors {
  // Semantic colors
  static const Color primary = Color(0xff162783);
  static const Color secondary = Color(0xff059669);
  static const Color darkPrimary = Color(0xffe4d75a);
  static const Color darkSecondary = Color(0xff5ae492);

  // Dialog colors
  static const Color dialogBackgroundLight = Color(0xff18170f);
  static const Color dialogBackgroundDark = Color(0xff121212);
  static const Color dialogSurfaceDark = Color(0xff201f15);

  // App bar
  static const Color appBarBackground = Color(0xFF13B9FF);

  // Utility colors
  static const Color transparent = Colors.transparent;
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color red = Color(0xFFFF3B30);
  static const Color green = Color(0xFF34C759);

  /// Get the appropriate dialog background color based on brightness
  static Color getDialogBackgroundColor(Brightness brightness) {
    return brightness == Brightness.dark
        ? AppColors.dialogBackgroundDark
        : AppColors.dialogBackgroundLight;
  }
}
