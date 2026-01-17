import 'package:flutter/material.dart';

const Color textYellow = Color(0xFF9E7C00);

const ColorScheme chengEngCustomScheme = ColorScheme(
  brightness: Brightness.light,

  //BRAND ACTIONS (Buttons, FABs, Active States)
  primary: Color(0xFFFFD700), 
  onPrimary: Color(0xFF000000), 
  primaryContainer: Color(0xFFFFF4B0), 
  onPrimaryContainer: Color(0xFF3E3000), 

  //SECONDARY ELEMENTS (Icons, Secondary Buttons) 
  secondary: Color(0xFF000000), 
  onSecondary: Color(0xFFFFFFFF), 
  secondaryContainer: Color(0xFFEEEEEE), 
  onSecondaryContainer: Color(0xFF000000), 

  //TERTIARY (Accents)
  tertiary: Color(0xFF424242), 
  onTertiary: Color(0xFFFFFFFF), 
  tertiaryContainer: Color(0xFFE0E0E0), 
  onTertiaryContainer: Color(0xFF000000), 

  //ERRORS
  error: Color(0xFFBA1A1A), 
  onError: Color(0xFFFFFFFF), 
  errorContainer: Color(0xFFFFDAD6), 
  onErrorContainer: Color(0xFF410002), 

  //BACKGROUNDS & SURFACES
  surface: Color(0xFFF9F9F9),
  onSurface: Color(0xFF1C1C1C),
  onSurfaceVariant: Color(0xFF757575), 

  //CONTAINERS (Cards, Input Fields, Bottom Sheets) 
  surfaceContainerLowest: Color(0xFFFFFFFF), 
  surfaceContainerLow: Color(0xFFFFFFFF),
  surfaceContainer: Color(0xFFFFFFFF),
  surfaceContainerHigh: Color(0xFFEEEEEE), 
  surfaceContainerHighest: Color(0xFFE0E0E0), 

  //OUTLINES
  outline: Color(0xFFBDBDBD),
  outlineVariant: Color(0xFFEEEEEE),

  //DARK ELEMENTS IN LIGHT MODE
  inverseSurface: Color(0xFF121212),
  onInverseSurface: Color(0xFFF5F5F5),
  inversePrimary: Color(0xFFFFE57F),

  //MISC
  shadow: Color(0xFF000000), 
  scrim: Color(0xFF000000), 
);