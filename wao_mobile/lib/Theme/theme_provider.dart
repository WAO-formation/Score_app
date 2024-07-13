import 'package:flutter/material.dart';

import 'dark_theme.dart';
import 'light_theme.dart';

class ThemeProvider with ChangeNotifier{

  late ThemeData _themeData = lightTheme;

  ThemeData get themeData => _themeData;

  set themeData(ThemeData themeData){
    _themeData  = themeData;
    notifyListeners();
  }

  void toggleTheme(){
    if(_themeData == lightTheme){
      _themeData = darkTheme;
    }else{
      _themeData = lightTheme;
    }
  }
  notifyListeners();
}