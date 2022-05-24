import 'dart:developer';

import 'package:dertos_inferno_app/styles.dart';
import 'package:flutter/material.dart';

class AppHomePage extends StatelessWidget {
  const AppHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Column(children: [
        const Text('Dertos\'    \n   Inferno',
            textAlign: TextAlign.left, style: TextStyles.mainTitle),
        // const Text('   Inferno',
        //     textAlign: TextAlign.right, style: TextStyles.mainTitle),
        Expanded(
          child: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              ElevatedButton(
                  child: const Text('Online'),
                  onPressed: () {
                    log('Play Online pressed');
                  }),
              ElevatedButton(
                  child: const Text('Locally'),
                  onPressed: () {
                    log('Play Locally pressed');
                  }),
            ]),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
                icon: const Icon(Icons.info),
                onPressed: () {
                  log("Info pressed");
                }),
            IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () {
                  Navigator.pushNamed(context, "/settings");
                }),
          ],
        )
      ]),
    ));
  }
}
