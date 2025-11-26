import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants.dart';

abstract interface class OnboardRepository {
  const OnboardRepository();

  bool isOnboard();
  Future<void> removeOnboard();
  int getTemplate();
  Future<void> setTemplate(int template);
}

final class OnboardRepositoryImpl implements OnboardRepository {
  OnboardRepositoryImpl({required SharedPreferences prefs}) : _prefs = prefs;

  final SharedPreferences _prefs;

  @override
  bool isOnboard() {
    return _prefs.getBool(Keys.onboard) ?? true;
  }

  @override
  Future<void> removeOnboard() async {
    await _prefs.setBool(Keys.onboard, false);
  }

  @override
  int getTemplate() {
    return _prefs.getInt(Keys.template) ?? 1;
  }

  @override
  Future<void> setTemplate(int template) async {
    await _prefs.setInt(Keys.template, template);
  }
}
