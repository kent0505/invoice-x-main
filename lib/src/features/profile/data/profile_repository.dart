import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants.dart';

abstract interface class ProfileRepository {
  const ProfileRepository();

  String getCurrency();
  Future<void> setCurrency(String currency);
}

final class ProfileRepositoryImpl implements ProfileRepository {
  ProfileRepositoryImpl({required SharedPreferences prefs}) : _prefs = prefs;

  final SharedPreferences _prefs;

  @override
  String getCurrency() {
    return _prefs.getString(Keys.currency) ?? '\$';
  }

  @override
  Future<void> setCurrency(String currency) async {
    await _prefs.setString(Keys.currency, currency);
  }
}
