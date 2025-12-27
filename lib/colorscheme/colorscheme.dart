import 'package:flutter/material.dart';

// ✅ CUSTOM MODERN THEME (Yellow, Black, White, Grey)
// optimized for high contrast and a clean look.
const Color textYellow = Color(0xFF9E7C00);

const ColorScheme chengEngCustomScheme = ColorScheme(
  brightness: Brightness.light,

  // --- BRAND ACTIONS (Buttons, FABs, Active States) ---
  // We use your Yellow as the main Primary color.
  primary: Color(0xFFFFD700), 
  // Text on top of Yellow must be Black for readability
  onPrimary: Color(0xFF000000), 
  
  // A lighter yellow for selected states/highlights
  primaryContainer: Color(0xFFFFF4B0), 
  onPrimaryContainer: Color(0xFF3E3000), 

  // --- SECONDARY ELEMENTS (Icons, Secondary Buttons) ---
  // Using Black as secondary gives a sharp, modern "Industrial" feel.
  secondary: Color(0xFF000000), 
  onSecondary: Color(0xFFFFFFFF), 
  
  // Light Grey for secondary containers (like Chip backgrounds)
  secondaryContainer: Color(0xFFEEEEEE), 
  onSecondaryContainer: Color(0xFF000000), 

  // --- TERTIARY (Accents) ---
  // A dark grey for subtle accents (like "Air-Cond" icons)
  tertiary: Color(0xFF424242), 
  onTertiary: Color(0xFFFFFFFF), 
  tertiaryContainer: Color(0xFFE0E0E0), 
  onTertiaryContainer: Color(0xFF000000), 

  // --- ERRORS ---
  error: Color(0xFFBA1A1A), 
  onError: Color(0xFFFFFFFF), 
  errorContainer: Color(0xFFFFDAD6), 
  onErrorContainer: Color(0xFF410002), 

  // --- BACKGROUNDS & SURFACES ---
  // Modern apps often use off-white for the main background 
  // and pure white for cards to create depth without shadows.
  surface: Color(0xFFF9F9F9), // Very light grey (almost white) background
  onSurface: Color(0xFF1C1C1C), // Almost Black text (softer on eyes)
  onSurfaceVariant: Color(0xFF757575), // Grey text for subtitles

  // --- CONTAINERS (Cards, Input Fields, Bottom Sheets) ---
  // Use these to distinguish layers
  surfaceContainerLowest: Color(0xFFFFFFFF), // Pure White
  surfaceContainerLow: Color(0xFFFFFFFF),
  surfaceContainer: Color(0xFFFFFFFF), // Standard Card = White
  surfaceContainerHigh: Color(0xFFEEEEEE), // Input Fields = Light Grey
  surfaceContainerHighest: Color(0xFFE0E0E0), 

  // --- OUTLINES ---
  outline: Color(0xFFBDBDBD), // Text Field borders
  outlineVariant: Color(0xFFEEEEEE), // Dividers

  // --- DARK ELEMENTS IN LIGHT MODE ---
  inverseSurface: Color(0xFF121212), // Black Snackbars
  onInverseSurface: Color(0xFFF5F5F5), // White text on Snackbars
  inversePrimary: Color(0xFFFFE57F), // Yellow text on dark backgrounds

  // --- MISC ---
  shadow: Color(0xFF000000), 
  scrim: Color(0xFF000000), 
);