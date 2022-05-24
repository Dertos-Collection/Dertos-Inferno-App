import 'package:flutter/material.dart';

class Insets {
  static const EdgeInsets mainButton = EdgeInsets.all(15);
}

class BorderRadii {
  static const BorderRadius zero = BorderRadius.zero;
  static BorderRadius buttonCommon = BorderRadius.circular(8);
}

class ButtonStyles {
  static ButtonStyle mainElevated = ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(borderRadius: BorderRadii.buttonCommon),
      padding: Insets.mainButton);
  static ButtonStyle simpleText = TextButton.styleFrom(
      shape: RoundedRectangleBorder(borderRadius: BorderRadii.buttonCommon));
}

class Fonts {}

class TextStyles {
  static const TextStyle mainTitle = TextStyle(fontSize: 60);
}
