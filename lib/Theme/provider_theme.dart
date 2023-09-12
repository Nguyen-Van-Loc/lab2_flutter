import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final appThemeStore = ChangeNotifierProvider(
    (ref)=>AppThemeStore()
);

class AppThemeStore extends ChangeNotifier {
  var idDark =false;
  void setLightTheme(){
    idDark=false;
    notifyListeners();
  }
  void setDarkTheme(){
    idDark=true;
    notifyListeners();
  }
}
