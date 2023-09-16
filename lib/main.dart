import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lab2a/Theme/AppTheme.dart';
import 'package:lab2a/Theme/provider_theme.dart';
import 'View.dart';

void main() {
  runApp(ProviderScope(child: Home()));
  configLoading();
}
class Home extends HookConsumerWidget{
  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final appThemeState =ref.watch(appThemeStore);
    return MaterialApp(
      builder: EasyLoading.init(),
      home: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            actions: [
              Switch(value: appThemeState.idDark, onChanged: (value){
                {
                  if(value){appThemeState.setDarkTheme();}else{appThemeState.setLightTheme();}
                }
              })
            ],
            title: const Text("Thư viện của tôi"),
          ),
          body: MyApp(),
        ),
      ), debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: appThemeState.idDark ?ThemeMode.dark : ThemeMode.light,
    );
  }
}
void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 4000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false;
}
class MyApp extends StatefulWidget {
  MyView createState() => MyView();
}
