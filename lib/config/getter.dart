import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import './const.dart';

class ConfigGetter {
  static const JWT_TOKEN ='0';
  static Future<Map<String, dynamic>> getStoredAccountDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String json = prefs.getString(PREF_USER) ?? "";
    print(json);
    if (json.isNotEmpty) {
      return  jsonDecode(json);
    }
    return {};
  }
}
