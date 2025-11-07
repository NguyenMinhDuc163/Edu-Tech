import 'package:flutter/material.dart';

@immutable
class BrandColors extends ThemeExtension<BrandColors> {
  final Color accent;
  final Color success;
  final Color warning;
  final Color info;
  final Color cardBackground;
  final Color borderColor;
  final Color searchBarBackground;
  final Color searchBarText;
  final Color searchBarIcon;
  final Color avatarBackground;
  final Color statusActive;
  final Color statusInactive;
  final Color progressBackground;
  final Color progressValue;
  final Color buttonPrimary;
  final Color buttonSecondary;
  final Color buttonDestructive;
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;

  const BrandColors({
    required this.accent,
    required this.success,
    required this.warning,
    required this.info,
    required this.cardBackground,
    required this.borderColor,
    required this.searchBarBackground,
    required this.searchBarText,
    required this.searchBarIcon,
    required this.avatarBackground,
    required this.statusActive,
    required this.statusInactive,
    required this.progressBackground,
    required this.progressValue,
    required this.buttonPrimary,
    required this.buttonSecondary,
    required this.buttonDestructive,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
  });

  @override
  BrandColors copyWith({
    Color? accent,
    Color? success,
    Color? warning,
    Color? info,
    Color? cardBackground,
    Color? borderColor,
    Color? searchBarBackground,
    Color? searchBarText,
    Color? searchBarIcon,
    Color? avatarBackground,
    Color? statusActive,
    Color? statusInactive,
    Color? progressBackground,
    Color? progressValue,
    Color? buttonPrimary,
    Color? buttonSecondary,
    Color? buttonDestructive,
    Color? textPrimary,
    Color? textSecondary,
    Color? textMuted,
  }) {
    return BrandColors(
      accent: accent ?? this.accent,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      info: info ?? this.info,
      cardBackground: cardBackground ?? this.cardBackground,
      borderColor: borderColor ?? this.borderColor,
      searchBarBackground: searchBarBackground ?? this.searchBarBackground,
      searchBarText: searchBarText ?? this.searchBarText,
      searchBarIcon: searchBarIcon ?? this.searchBarIcon,
      avatarBackground: avatarBackground ?? this.avatarBackground,
      statusActive: statusActive ?? this.statusActive,
      statusInactive: statusInactive ?? this.statusInactive,
      progressBackground: progressBackground ?? this.progressBackground,
      progressValue: progressValue ?? this.progressValue,
      buttonPrimary: buttonPrimary ?? this.buttonPrimary,
      buttonSecondary: buttonSecondary ?? this.buttonSecondary,
      buttonDestructive: buttonDestructive ?? this.buttonDestructive,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textMuted: textMuted ?? this.textMuted,
    );
  }

  @override
  BrandColors lerp(ThemeExtension<BrandColors>? other, double t) {
    if (other is! BrandColors) return this;
    return BrandColors(
      accent: Color.lerp(accent, other.accent, t)!,
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      info: Color.lerp(info, other.info, t)!,
      cardBackground: Color.lerp(cardBackground, other.cardBackground, t)!,
      borderColor: Color.lerp(borderColor, other.borderColor, t)!,
      searchBarBackground:
          Color.lerp(searchBarBackground, other.searchBarBackground, t)!,
      searchBarText: Color.lerp(searchBarText, other.searchBarText, t)!,
      searchBarIcon: Color.lerp(searchBarIcon, other.searchBarIcon, t)!,
      avatarBackground:
          Color.lerp(avatarBackground, other.avatarBackground, t)!,
      statusActive: Color.lerp(statusActive, other.statusActive, t)!,
      statusInactive: Color.lerp(statusInactive, other.statusInactive, t)!,
      progressBackground:
          Color.lerp(progressBackground, other.progressBackground, t)!,
      progressValue: Color.lerp(progressValue, other.progressValue, t)!,
      buttonPrimary: Color.lerp(buttonPrimary, other.buttonPrimary, t)!,
      buttonSecondary: Color.lerp(buttonSecondary, other.buttonSecondary, t)!,
      buttonDestructive:
          Color.lerp(buttonDestructive, other.buttonDestructive, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
    );
  }
}
