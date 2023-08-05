import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:lively_studio/model/model_company_details.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/model_user_detail.dart';
import './const.dart';

class ConfigGetter {
  static String JWT_TOKEN = "DEFAULT_JWT_TOKEN";
  static String CURRENCY_CODE = "";
  static late UserDetail USERDETAILS;
  static late CompanyDetail COMPANY_DETAILS;

  static late  BuildContext mContext;


  static Future<Map<String, dynamic>> getStoredAccountDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String json = prefs.getString(PREF_USER) ?? "";
    print(json);
    if (json.isNotEmpty) {
      return jsonDecode(json);
    }
    return {};
  }
}
