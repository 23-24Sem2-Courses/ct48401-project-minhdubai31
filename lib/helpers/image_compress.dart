import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_image_compress/flutter_image_compress.dart';

Future<Uint8List> compressFile({
  required File file,
  required int minWidth,
  required int minHeight,
}) async {
  var result = await FlutterImageCompress.compressWithFile(
    file.absolute.path,
    minWidth: minWidth,
    minHeight: minHeight,
    quality: 95,
  );
  return result!;
}
