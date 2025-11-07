import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'theme_service.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(ThemeService.load());

  Future<void> setThemeMode(ThemeMode mode) async {
    emit(mode);
    await ThemeService.save(mode);
  }
}
