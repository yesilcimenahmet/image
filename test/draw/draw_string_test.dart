import 'dart:io';
import 'package:image/image.dart';
import 'package:test/test.dart';

import '../test_util.dart';

void DrawStringTest() {
  test('drawString', () {
    final i0 = Image(256, 256);

    i0.clear(ColorRgb8(128, 128));
    drawString(i0, arial_24, 50, 50, "Hello", color: ColorRgba8(255));
    drawString(i0, arial_24, 200, 80, "Right Justified", rightJustify: true);
    drawStringCentered(i0, arial_24, "Centered");

    File('$tmpPath/out/draw/draw_string_0.png')
      ..createSync(recursive: true)
      ..writeAsBytesSync(encodePng(i0));
  });
}
