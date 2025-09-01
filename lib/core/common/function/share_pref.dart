import 'dart:convert';

import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  // static SharedPreferences _preferences;
  static SharedPreferences _preferences = Get.find<SharedPreferences>();

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  static getInt(String key) {
    return _preferences.getInt(key) ?? 0;
  }
  static setInt(String key, int value) async {
    return _preferences.setInt(key, value);
  }

  static getList(String key)  {
    return _preferences.getString(key) != null
        ? json.decode(_preferences.getString(key)!)
        : null;
  }

  static getBool(String key) {
    return _preferences.getBool(key) ?? false;
  }

  static getString(String key) {
    return _preferences.getString(key) != null ? json.decode(_preferences.getString(key)!) : null;
  }

  static setString(String key, value) async {
    await _preferences.setString(key, json.encode(value));
  }

  static setBool(String key, value) async {
    await _preferences.setBool(key, value);
  }

  static setList(String key, value) async {
    await _preferences.setString(key, json.encode(value));
  }

  static remove(String key) async {
    _preferences.remove(key);
  }
}


