import 'dart:convert';

import 'package:lively_studio/model/model_company_details.dart';
import 'package:lively_studio/model/model_user_detail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/const.dart';
import '../config/getter.dart';

class SharedPreferenceUtility {
  static storeUser(String user) async {
    Map<String, dynamic> jsonMap = jsonDecode(user);
    ConfigGetter.USERDETAILS = UserDetail.fromJson(jsonMap);
    ConfigGetter.JWT_TOKEN = ConfigGetter.USERDETAILS.token;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(PREF_USER, user);
  }

  static storeCompanyDetails(String companyDetails) async {
    Map<String, dynamic> jsonMap = jsonDecode(companyDetails);
    ConfigGetter.COMPANY_DETAILS = CompanyDetail.fromJson(jsonMap);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(PREF_COMPANY, companyDetails);
  }


  static Future<bool> getStoredAccountDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String user = prefs.getString(PREF_USER) ?? "";
    String company = prefs.getString(PREF_COMPANY) ?? "";
    if (user.isEmpty || company.isEmpty) {
      return false;
    } else {
      Map<String, dynamic> jsonMapUser = jsonDecode(user);
      Map<String, dynamic> jsonMapCompany = jsonDecode(company);
      ConfigGetter.COMPANY_DETAILS = CompanyDetail.fromJson(jsonMapCompany);
      ConfigGetter.USERDETAILS = UserDetail.fromJson(jsonMapUser);
      ConfigGetter.JWT_TOKEN = ConfigGetter.USERDETAILS.token;

      return true;
    }
  }

  static clearAllStorage() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
  }
}
