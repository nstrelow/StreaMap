import 'package:flutter/material.dart';

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    var hexColorNoHash = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColorNoHash.length == 6) {
      hexColorNoHash = 'FF$hexColorNoHash';
    }
    return int.parse(hexColorNoHash, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}
