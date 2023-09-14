import 'package:flutter/material.dart';

class LayoutProvider {
  late double topBarHeight;
  late double indentation;
  final LinearGradient linearGradient = const LinearGradient(
    colors: [Color(0xFFC030E6), Color(0xFF8865F7)],
    begin: Alignment(-1.0, -2.0),
    end: Alignment(1.0, 2.0),
  );

  LayoutProvider(BuildContext context) {
    var aspectratio =
        MediaQuery.of(context).size.height / MediaQuery.of(context).size.width;
    if (aspectratio >= 2) {
      topBarHeight = MediaQuery.of(context).size.width * 2.16 * 0.043;
    } else {
      topBarHeight = MediaQuery.of(context).size.width * 1.78 * 0.050;
    }
    indentation = MediaQuery.of(context).size.width * 0.06;
  }
}
