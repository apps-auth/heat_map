import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/widgets.dart' show ImageProvider;

import '../flutter_heat_map.dart';
import 'components/image_helper.dart';
import 'components/processors/image_processor.dart';
import 'models/page.dart';

class HeatMap {
  static Future<Uint8List?> process(HeatMapPage page,
          [HeatMapConfig? config]) =>
      ImageProcessor.process(page, config ?? HeatMapConfig());

  static Future<ui.Image> imageProviderToUiImage(ImageProvider imageProvider) =>
      ImageHelper.imageProviderToUiImage(imageProvider);
}
