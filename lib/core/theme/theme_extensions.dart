import 'package:flutter/material.dart';
import 'brand_colors.dart';

extension ThemeExtensions on BuildContext {
  /// Lấy BrandColors từ theme hiện tại
  ///
  /// Sử dụng: context.brandColors.accent
  BrandColors get brandColors => Theme.of(this).extension<BrandColors>()!;

  /// Lấy ColorScheme từ theme hiện tại
  ///
  /// Sử dụng: context.colors.primary
  ColorScheme get colors => Theme.of(this).colorScheme;

  /// Lấy ThemeData từ theme hiện tại
  ///
  /// Sử dụng: context.theme.textTheme
  ThemeData get theme => Theme.of(this);

  /// Lấy bất kỳ ThemeExtension nào từ theme
  ///
  /// Sử dụng: context.extension<MyCustomColors>()
  T extension<T extends ThemeExtension<T>>() {
    return Theme.of(this).extension<T>()!;
  }
}
