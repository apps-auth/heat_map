import 'dart:async';
import 'dart:ui';

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart' hide Image;

/// Creates backgrounds for sessions
class ImageHelper {
  static Future<Image> imageProviderToUiImage(ImageProvider image) async {
    final Completer<ImageInfo> completer = Completer<ImageInfo>();

    image
        .resolve(const ImageConfiguration())
        .addListener(ImageStreamListener((ImageInfo info, bool _) {
      completer.complete(info);
    }));

    Image imageResponse = (await completer.future).image;

    return imageResponse;
  }
}
