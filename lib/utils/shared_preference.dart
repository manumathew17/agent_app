import 'package:shared_preferences/shared_preferences.dart';

import '../config/const.dart';

class SharedPreferenceUtility {
  static Future<bool> storeUser(String user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(PREF_USER, user);
  }
}
