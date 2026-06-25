import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:sp_util/sp_util.dart';

/// Service quản lý lưu trữ và tải ngôn ngữ
class LocaleService {
  static const String _key = 'app_locale';
  static const List<Locale> supportedLocales = [
    Locale('en', 'US'),
    Locale('vi', 'VN'),
  ];

  /// Load locale từ SharedPreferences
  static Locale load() {
    final String? value = SpUtil.getString(_key);

    if (value == null) {
      return systemLocale;
    }

    // Parse locale từ string format: "en_US" hoặc "vi_VN"
    final parts = value.split('_');
    if (parts.length == 2) {
      return Locale(parts[0], parts[1]);
    }

    return systemLocale;
  }

  /// Lấy locale theo ngôn ngữ hệ thống nếu app hỗ trợ
  static Locale get systemLocale {
    final locale = PlatformDispatcher.instance.locale;
    return supportedLocales.firstWhere(
      (supportedLocale) => supportedLocale.languageCode == locale.languageCode,
      orElse: () => const Locale('en', 'US'),
    );
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
