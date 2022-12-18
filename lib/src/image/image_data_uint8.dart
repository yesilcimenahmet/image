import 'dart:typed_data';

import '../color/color.dart';
import '../color/color_uint8.dart';
import '../color/format.dart';
import 'image_data.dart';
import 'palette.dart';
import 'pixel.dart';
import 'pixel_range_iterator.dart';
import 'pixel_uint8.dart';

class ImageDataUint8 extends ImageData {
  final Uint8List data;
  final Palette? palette;

  ImageDataUint8(int width, int height, int numChannels)
      : data = Uint8List(width * height * numChannels)
      , palette = null
      , super(width, height, numChannels);

  ImageDataUint8.palette(int width, int height, this.palette)
      : data = Uint8List(width * height)
      , super(width, height, 1);

  ImageDataUint8.from(ImageDataUint8 other)
      : data = Uint8List.fromList(other.data)
      , palette = other.palette?.clone()
      , super(other.width, other.height, other.numChannels);

  ImageDataUint8 clone() => ImageDataUint8.from(this);

  Format get format => Format.uint8;

  FormatType get formatType => FormatType.uint;

  ByteBuffer get buffer => data.buffer;

  int get rowStride => width * numChannels;

  int get bitsPerChannel => 8;

  PixelUint8 get iterator => PixelUint8.imageData(this);

  Iterator<Pixel> getRange(int x, int y, int width, int height) =>
      PixelRangeIterator(PixelUint8.imageData(this), x, y, width, height);

  int get lengthInBytes => data.lengthInBytes;

  int get length => data.lengthInBytes;

  num get maxChannelValue => 255;

  bool get isHdrFormat => false;

  Color getColor(num r, num g, num b, [num? a]) =>
      a == null ? ColorRgb8(r.clamp(0, 255).toInt(), g.clamp(0, 255).toInt(),
              b.clamp(0, 255).toInt())
          : ColorRgba8(r.clamp(0, 255).toInt(), g.clamp(0, 255).toInt(),
              b.clamp(0, 255).toInt(), a.clamp(0, 255).toInt());

  Pixel getPixel(int x, int y, [Pixel? pixel]) {
    if (pixel == null || pixel is! PixelUint8 || pixel.data != this) {
      pixel = PixelUint8.imageData(this);
    }
    pixel.setPosition(x, y);
    return pixel;
  }

  void setPixelColor(int x, int y, num r, [num g = 0, num b = 0, num a = 255]) {
    int index = y * rowStride + (x * numChannels);
    data[index] = r.toInt();
    if (numChannels > 1) {
      data[index + 1] = g.toInt();
      if (numChannels > 2) {
        data[index + 2] = b.toInt();
        if (numChannels > 3) {
          data[index + 3] = a.toInt();
        }
      }
    }
  }

  String toString() => 'ImageDataUint8($width, $height, $numChannels)';

  void clear([Color? c]) {
    final c8 = c?.convert(format: Format.uint8);
    if (numChannels == 1) {
      final ri = c8 == null ? 0 : (c8.r as int).clamp(0,255);
      data.fillRange(0, data.length, ri);
    } else if (numChannels == 2) {
      final ri = c8 == null ? 0 : (c8.r as int).clamp(0,255);
      final gi = c8 == null ? 0 : (c8.g as int).clamp(0,255);
      final rg = (gi << 8) | ri;
      final u16 = Uint16List.view(data.buffer);
      u16.fillRange(0, u16.length, rg);
    } else if (numChannels == 4) {
      final ri = c8 == null ? 0 : (c8.r as int).clamp(0,255);
      final gi = c8 == null ? 0 : (c8.g as int).clamp(0,255);
      final bi = c8 == null ? 0 : (c8.b as int).clamp(0,255);
      final ai = c8 == null ? 0 : (c8.a as int).clamp(0,255);
      final rgba = (ai << 24) | (bi << 16) | (gi << 8) | ri;
      final u32 = Uint32List.view(data.buffer);
      u32.fillRange(0, u32.length, rgba);
    } else {
      final ri = c8 == null ? 0 : (c8.r as int).clamp(0,255);
      final gi = c8 == null ? 0 : (c8.g as int).clamp(0,255);
      final bi = c8 == null ? 0 : (c8.b as int).clamp(0,255);
      // rgb is the slow case since we can't pack the channels
      for (var p in this) {
        p.r = ri;
        p.g = gi;
        p.b = bi;
      }
    }
  }
}
