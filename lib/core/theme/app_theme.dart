import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_text_styles.dart';
import 'brand_colors.dart';

class AppTheme {
  static ThemeData light() {
    final ColorScheme colorScheme = const ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.deepBlue,
      error: AppColors.error,
      background: AppColors.bodyBackground,
      surface: AppColors.white,
      onPrimary: Colors.white, // Text màu trắng cho drawer
      onSecondary: Colors.white10,
      onError: Colors.white,
      onBackground: AppColors.text,
      onSurface: AppColors.text,
      // Material 3 colors - fix màu TextField
      surfaceContainerHighest: AppColors.lightGray,
      onSurfaceVariant: AppColors.text,
      outline: AppColors.colorB8B8D2,
    );

    return ThemeData(
      colorScheme: colorScheme,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.bodyBackground,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.white,
        elevation: 0,
        foregroundColor: AppColors.text,
        titleTextStyle: AppTextStyles.appbarTitle,
      ),
      dividerColor: AppColors.divider,
      iconTheme: const IconThemeData(color: AppColors.icon),
      textTheme: const TextTheme(
        bodyLarge: AppTextStyles.textStyleDefault,
        bodyMedium: AppTextStyles.text,
        // titleLarge: AppTextStyles.textHeader2,
        // titleMedium: AppTextStyles.textHeader3,
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(
          color: Color(0xFF6B7280), // Xám đậm - hot reload work
          fontSize: 15,
          fontWeight: FontWeight.w400,
        ),
        floatingLabelStyle: AppTextStyles.inputFieldLabel,
      ),
      useMaterial3: true,
      extensions: const [
        BrandColors(
          accent: Color(0xFF10B981),
          success: Color(0xFF059669),
          warning: Color(0xFFF59E0B),
          info: Color(0xFF3B82F6),
          cardBackground: AppColors.deepBlue,
          borderColor: Color(0xFFE5E7EB),
          searchBarBackground: AppColors.deepBlue,
          searchBarText: Color(0xFFFFFFFF),
          searchBarIcon: Color(0xFFFFFFFF),
          avatarBackground: Color(0x1A0E2B5C),
          statusActive: Color(0xFF4CAF50),
          statusInactive: Color(0xFFFF9800),
          progressBackground: Color(0xFFE5E7EB),
          progressValue: Color(0xFF4CAF50),
          buttonPrimary: AppColors.deepBlue,
          buttonSecondary: Color(0xFF374151),
          buttonDestructive: Color(0xFFF44336),
          textPrimary: Color(0xFFFFFFFF),
          textSecondary: Color(0xB3FFFFFF),
          textMuted: Color(0x80FFFFFF),
        ),
      ],
    );
  }

  static ThemeData dark() {
    const Color background = Color(0xFF0F1115);
    const Color surface = Color(0xFF141821);
    const Color text = Color(0xFFE6E8EC);

    final ColorScheme colorScheme = const ColorScheme.dark(
      primary: surface, // Sử dụng surface color cho dark theme
      secondary: AppColors.deepBlue,
      error: AppColors.error,
      background: background,
      surface: surface,
      onPrimary: Colors.white, // Text màu trắng cho drawer dark theme
      onSecondary: Colors.white,
      onError: Colors.white,
      onBackground: text,
      onSurface: text,
      // Material 3 colors - fix màu TextField dark mode
      surfaceContainerHighest: Color(0xFF1E293B),
      onSurfaceVariant: text,
      outline: Color(0xFF374151),
    );

    return ThemeData(
      colorScheme: colorScheme,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      appBarTheme: const AppBarTheme(
        backgroundColor: surface,
        elevation: 0,
        foregroundColor: text,
      ),
      dividerColor: const Color(0xFF2A2F3A),
      iconTheme: const IconThemeData(color: text),
      textTheme: const TextTheme(
        bodyLarge: AppTextStyles.textStyleDefault,
        bodyMedium: AppTextStyles.text,
        // titleLarge: AppTextStyles.textHeader2,
        // titleMedium: AppTextStyles.textHeader3,
      ).apply(bodyColor: text, displayColor: text),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(
          color: Color(0x80E6E8EC), // Xám sáng với opacity - dark mode
          fontSize: 15,
          fontWeight: FontWeight.w400,
        ),
        floatingLabelStyle: AppTextStyles.inputFieldLabel.copyWith(color: text),
      ),
      useMaterial3: true,
      extensions: const [
        BrandColors(
          accent: Color(0xFF81D334),
          success: Color(0xFFB91083),
          warning: Color(0xFF51492C),
          info: Color(0xFF65FA60),
          cardBackground: Color(
            0xFF1E293B,
          ), // Màu xám xanh sáng hơn cho dark mode
          borderColor: Color(0xFF374151),
          searchBarBackground: Color(0x1FFFFFFF),
          searchBarText: Color(0xB3FFFFFF),
          searchBarIcon: Color(0xB3FFFFFF),
          avatarBackground: Color(0x3DFFFFFF),
          statusActive: Color(0xFF66BB6A),
          statusInactive: Color(0xFFFFB74D),
          progressBackground: Color(0x1FFFFFFF),
          progressValue: Color(0xFF66BB6A),
          buttonPrimary: Color(0xFF64B5F6),
          buttonSecondary: Color(0x1FFFFFFF),
          buttonDestructive: Color(0xFFEF5350),
          textPrimary: Color(0xFFFFFFFF),
          textSecondary: Color(0xB3FFFFFF),
          textMuted: Color(0x80FFFFFF),
        ),
      ],
    );
  }
}
