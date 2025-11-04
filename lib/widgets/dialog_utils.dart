/// Dialog and form styling utilities
///
/// This file contains reusable utility functions for common dialog and form
/// styling patterns used across multiple screens.
library;
import 'package:flutter/material.dart';
import '../util/tailwind_colors.dart';

/// Get the primary color for a given color name and brightness
Color getPrimaryColor(String colorName, Brightness brightness) {
  return brightness == Brightness.dark
      ? tailwindColors[colorName]![300]!
      : tailwindColors[colorName]![800]!;
}

/// Get the secondary/weaker color for a given color name and brightness
Color getPrimaryColorWeaker(String colorName, Brightness brightness) {
  return brightness == Brightness.dark
      ? tailwindColors[colorName]![300]!
      : tailwindColors[colorName]![700]!;
}

/// Get the background dialog color for a given color name and brightness
Color getBackgroundDialogColor(String colorName, Brightness brightness) {
  return brightness == Brightness.dark
      ? Color.alphaBlend(
          Colors.black.withValues(alpha: 0.60),
          tailwindColors[colorName]![900]!,
        )
      : tailwindColors[colorName]![100]!;
}

/// Get outline color for buttons based on color name and brightness
Color getOutlineColor(String colorName, Brightness brightness) {
  return brightness == Brightness.dark
      ? tailwindColors[colorName]![700]!
      : tailwindColors[colorName]![200]!;
}

/// Get the disabled/selected background color
Color getSelectedBackgroundColor(String colorName, Brightness brightness) {
  return brightness == Brightness.dark
      ? tailwindColors[colorName]![900]!
      : tailwindColors[colorName]![100]!;
}

/// Common input decoration border for text fields
OutlineInputBorder getInputDecorationBorder(Color color) {
  return OutlineInputBorder(
    borderSide: BorderSide(color: color),
    borderRadius: BorderRadius.circular(8),
  );
}
