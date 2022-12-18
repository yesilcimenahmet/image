import 'dart:math';

import '../color/color.dart';
import '../image/image.dart';

/// Fill a rectangle in the image [src] with the given [color] with the corners
/// [x1],[y1] and [x2],[y2].
Image fillRect(Image src, int x1, int y1, int x2, int y2, Color c) {
  if (c.a == 0) {
    return src;
  }

  final _x0 = min(x1, x2).clamp(0, src.width - 1);
  final _y0 = min(y1, y2).clamp(0, src.height - 1);
  final _x1 = max(x1, x2).clamp(0, src.width - 1);
  final _y1 = max(y1, y2).clamp(0, src.height - 1);
  final _w = (_x1 - _x0) + 1;
  final _h = (_y1 - _y0) + 1;

  // If no blending is necessary, use a faster fill method.
  if (c.a == c.maxChannelValue) {
    var iter = src.getRange(_x0, _y0, _w, _h);
    while (iter.moveNext()) {
      iter.current.set(c);
    }
  } else {
    final a = c.a / c.maxChannelValue;
    final invA = 1.0 - a;
    var iter = src.getRange(_x0, _y0, _w, _h);
    while (iter.moveNext()) {
      final p = iter.current;
      p.r = (c.r * a) + (p.r * invA);
      p.g = (c.g * a) + (p.g * invA);
      p.b = (c.b * a) + (p.b * invA);
      p.a = c.a;
    }
  }

  return src;
}
