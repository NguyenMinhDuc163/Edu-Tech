import 'package:flutter/material.dart';
import 'package:sp_util/sp_util.dart';

/// Service quản lý lưu trữ và tải ngôn ngữ
class LocaleService {
  static const String _key = 'app_locale';

  /// Load locale từ SharedPreferences
  static Locale load() {
    final String? value = SpUtil.getString(_key);

    if (value == null) {
      // Mặc định là tiếng Việt
      return const Locale('vi', 'VN');
    }

    // Parse locale từ string format: "en_US" hoặc "vi_VN"
    final parts = value.split('_');
    if (parts.length == 2) {
      return Locale(parts[0], parts[1]);
    }

    // Fallback
    return const Locale('vi', 'VN');
  }

  /// Lưu locale vào SharedPreferences
  static Future<void> save(Locale locale) async {
    final String value = '${locale.languageCode}_${locale.countryCode}';
    await SpUtil.putString(_key, value);
  }

  /// Xóa locale đã lưu (reset về mặc định)
  static Future<void> clear() async {
    await SpUtil.remove(_key);
  }
}
