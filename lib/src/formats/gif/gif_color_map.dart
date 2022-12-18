import '../../color/color_uint8.dart';
import '../../image/palette_uint8.dart';

class GifColorMap {
  int bitsPerPixel;
  int numColors;
  int? transparent;
  final PaletteUint8 _palette;

  GifColorMap(this.numColors)
      : _palette = PaletteUint8(numColors, 3),
        bitsPerPixel = _bitSize(numColors);

  GifColorMap.from(GifColorMap other)
    : bitsPerPixel = other.bitsPerPixel
    , numColors = other.numColors
    , transparent = other.transparent
    , _palette = PaletteUint8.from(other._palette);

  ColorUint8 color(int index) {
    final r = red(index);
    final g = green(index);
    final b = blue(index);
    final a = alpha(index);
    return ColorUint8.rgba(r, g, b, a);
  }

  void setColor(int index, int r, int g, int b) {
    _palette.setColor(index, r, g, b);
  }

  int red(int color) => _palette.getRed(color) as int;

  int green(int color) => _palette.getGreen(color) as int;

  int blue(int color) => _palette.getBlue(color) as int;

  int alpha(int color) => (color == transparent) ? 0 : 255;

  PaletteUint8 getPalette() {
    if (transparent == null) {
      return _palette;
    }
    final p = PaletteUint8(_palette.numColors, 4);
    for (var i = 0, l = _palette.numColors; i < l; ++i) {
      p.setColor(i, red(i), green(i), blue(i), alpha(i));
    }
    return p;
  }

  static int _bitSize(int n) {
    for (var i = 1; i <= 8; i++) {
      if ((1 << i) >= n) {
        return i;
      }
    }
    return 0;
  }
}
