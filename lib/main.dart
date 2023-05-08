import 'package:dertos_inferno_app/game/play.dart';
import 'package:dertos_inferno_app/home.dart';
import 'package:dertos_inferno_app/settings/settings.dart';
import 'package:dertos_inferno_app/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';

void main() async {
  await Settings.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dertos\' Inferno',
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
        primarySwatch: Colors.deepOrange,
        brightness: Brightness.dark,
        primaryColor: Colors.grey,
        scaffoldBackgroundColor: Colors.grey[900],
        textTheme: const TextTheme(
          headline1: TextStyles.mainTitle,
        ),
      ),
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        textButtonTheme: TextButtonThemeData(style: ButtonStyles.simpleText),
        elevatedButtonTheme:
            ElevatedButtonThemeData(style: ButtonStyles.mainElevated),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: {
        '/': (ctx) => const AppHomePage(),
        '/settings': (ctx) => const SettingsPage(),
        '/play': (ctx) => const PlayPage(),
      },
    );
  }
}
