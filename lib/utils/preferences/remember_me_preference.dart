import 'package:sp_util/sp_util.dart';

class RememberMePreference {
  static const String _key = 'remember_me';

  static bool get() {
    return SpUtil.getBool(_key) ?? true;
  }

  static Future<void> set(bool value) async {
    await SpUtil.putBool(_key, value);
  }
}
