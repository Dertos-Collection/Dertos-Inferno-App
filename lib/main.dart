import 'package:dertos_inferno_app/home.dart';
import 'package:dertos_inferno_app/play/play.dart';
import 'package:dertos_inferno_app/settings/settings.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dertos\' Inferno',
      routes: {
        '/': (ctx) => const AppHomePage(),
        '/settings': (ctx) => const SettingsPage(),
        '/play': (ctx) => const PlayPage(),
      },
    );
  }
}
