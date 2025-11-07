import 'package:flutter/material.dart';
import 'package:sp_util/sp_util.dart';

class ThemeService {
  static const String _key = 'app_theme_mode';

  static Future<void> init() async {
    await SpUtil.getInstance();
  }

  static ThemeMode load() {
    final String? value = SpUtil.getString(_key);
    switch (value) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.light; // Mặc định là light
    }
  }

  static Future<void> save(ThemeMode mode) async {
    final String value = switch (mode) {
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
      ThemeMode.system => 'light', // Nếu có system thì lưu thành light
    };
    await SpUtil.putString(_key, value);
  }
}
