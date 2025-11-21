import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants.dart';
import '../../../core/utils.dart';

abstract interface class OnboardRepository {
  const OnboardRepository();

  bool isOnboard();
  Future<void> removeOnboard();

  int getTemplateID();
  Future<void> setTemplatedID(int id);
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
  int getTemplateID() {
    return _prefs.getInt(Keys.templateID) ?? 1;
  }

  @override
  Future<void> setTemplatedID(int id) async {
    logger(id);
    await _prefs.setInt(Keys.templateID, id);
  }
}
