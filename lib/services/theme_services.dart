import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeServices{
  final _box = GetStorage();
  final _key = 'isDarkMode';
  _saveThemeToBox(bool isDarkMode) => _box.write(_key, isDarkMode);    //화이트모드인지, 다크모드인지 저장

  //_key에 해당하는 값이 없다면), ?? false 부분이 실행되어 false를 반환
  bool _loadThemeFromBox() => _box.read(_key)??false;
  ThemeMode get theme => _loadThemeFromBox()?ThemeMode.dark:ThemeMode.light;
  void switchTheme() {
    Get.changeThemeMode(_loadThemeFromBox()?ThemeMode.light:ThemeMode.dark);
    _saveThemeToBox(!_loadThemeFromBox());
  }
}