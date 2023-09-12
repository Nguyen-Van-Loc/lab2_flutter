import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lab2a/Theme/AppTheme.dart';
import 'package:lab2a/Theme/provider_theme.dart';
import 'View.dart';

void main() {
  runApp(ProviderScope(child: Home()));
}
class Home extends HookConsumerWidget{
  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final appThemeState =ref.watch(appThemeStore);
    return MaterialApp(
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

class MyApp extends StatefulWidget {
  MyView createState() => MyView();
}
