import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppTheme {
  static ThemeData get darkTheme {
    final base = ThemeData.dark(useMaterial3: true);
    final textTheme = GoogleFonts.interTextTheme(
      base.textTheme,
    ).apply(bodyColor: AppColors.softWhite, displayColor: AppColors.softWhite);

    return base.copyWith(
      scaffoldBackgroundColor: AppColors.matteBlack,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.mutedLavender,
        secondary: AppColors.warmBeige,
        surface: AppColors.deepSurface,
      ),
      textTheme: textTheme,
      cardColor: AppColors.glassSurface,
      dividerColor: AppColors.outline,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.softWhite,
      ),
    );
  }

  static ThemeData get lightTheme {
    final base = ThemeData.light(useMaterial3: true);
    final textTheme = GoogleFonts.interTextTheme(base.textTheme);

    return base.copyWith(
      textTheme: textTheme,
      colorScheme: const ColorScheme.light(
        primary: AppColors.mutedLavender,
        secondary: AppColors.warmBeige,
      ),
    );
  }
}
