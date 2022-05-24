import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SettingsContainer(
      children: [
        Row(children: [
          TextButton(
            child: Row(
              children: const [
                Icon(Icons.chevron_left),
                Text("Back"),
              ],
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ]),
        SettingsGroup(title: 'General', children: [
          DropDownSettingsTile(
              title: 'Language', settingKey: "key-language", selected: 1,
              // !Note: the stored setting is the key of the selected item.
              values: const <int, String>{1: 'English', 2: 'Greek'})
        ]),
        SettingsGroup(
          title: 'Others',
          children: [
            SwitchSettingsTile(
              title: 'Are you a Kostas',
              settingKey: "key-is-kostas",
              defaultValue: true,
            )
          ],
        )
      ],
    ));
  }
}
