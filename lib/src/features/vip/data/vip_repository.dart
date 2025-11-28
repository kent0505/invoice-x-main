import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants.dart';

abstract interface class VipRepository {
  const VipRepository();

  int getFree();
  Future<void> setFree(int free);
}

final class VipRepositoryImpl implements VipRepository {
  VipRepositoryImpl({required SharedPreferences prefs}) : _prefs = prefs;

  final SharedPreferences _prefs;

  @override
  int getFree() {
    return _prefs.getInt(Keys.free) ?? Constants.free;
  }

  @override
  Future<void> setFree(int free) async {
    await _prefs.setInt(Keys.free, free);
  }
}
