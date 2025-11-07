import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

import 'locale_service.dart';

/// Cubit quản lý state ngôn ngữ của app
class LocaleCubit extends Cubit<Locale> {
  LocaleCubit() : super(LocaleService.load());

  bool _isChanging = false;

  /// Các locale được hỗ trợ
  static const List<Locale> supportedLocales = [
    Locale('en', 'US'),
    Locale('vi', 'VN'),
  ];

  /// Chuyển đổi sang locale cụ thể
  Future<void> changeLocale(Locale locale, BuildContext context) async {
    // Ngăn chặn multiple clicks
    if (_isChanging) {
      debugPrint('⚠️ Locale change already in progress, ignoring...');
      return;
    }

    if (!supportedLocales.contains(locale)) {
      debugPrint('⚠️ Locale $locale is not supported');
      return;
    }

    // Nếu locale đã là locale hiện tại, không làm gì
    if (state == locale) {
      debugPrint('ℹ️ Locale is already ${locale.languageCode}_${locale.countryCode}');
      return;
    }

    _isChanging = true;

    try {
      debugPrint('🔄 Changing locale to: ${locale.languageCode}_${locale.countryCode}');

      // Cập nhật EasyLocalization context TRƯỚC
      if (context.mounted) {
        await context.setLocale(locale);
      }

      // Lưu vào SharedPreferences
      await LocaleService.save(locale);

      // Emit state mới SAU KHI đã update context
      emit(locale);

      debugPrint('✅ Locale changed to: ${locale.languageCode}_${locale.countryCode}');
    } finally {
      _isChanging = false;
    }
  }

  /// Toggle giữa tiếng Anh và tiếng Việt
  Future<void> toggleLocale(BuildContext context) async {
    final currentLocale = state;
    final newLocale = currentLocale.languageCode == 'en'
        ? const Locale('vi', 'VN')
        : const Locale('en', 'US');

    await changeLocale(newLocale, context);
  }

  /// Kiểm tra locale hiện tại có phải tiếng Việt không
  bool get isVietnamese => state.languageCode == 'vi';

  /// Kiểm tra locale hiện tại có phải tiếng Anh không
  bool get isEnglish => state.languageCode == 'en';

  /// Lấy tên ngôn ngữ hiện tại
  String get currentLanguageName {
    switch (state.languageCode) {
      case 'vi':
        return 'Tiếng Việt';
      case 'en':
        return 'English';
      default:
        return 'Unknown';
    }
  }
}
