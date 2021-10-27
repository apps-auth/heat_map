import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/painting.dart';
import 'package:heat_map/src/models/config/config.dart';
import 'package:heat_map/src/models/config/heat_map_style.dart';
import 'package:heat_map/src/models/page.dart';
import 'package:heat_map/src/utils/utils.dart';

import '../event_processor.dart';

/// Processes pages into heat maps
class ImageProcessor {
  /// Processes page locally into a heat map
  static Future<Uint8List?> process(HeatMapPage page, Config config) async {
    if (page.image == null) {
      debugPrint('Got page with no image attached, skipping.');
      return null;
    }
    var image = page.image!;
    final pictureRecorder = PictureRecorder();
    final canvas = Canvas(pictureRecorder);
    var rect = _getClippedImageRect(page);
    canvas.drawImageRect(image, rect, Offset.zero & rect.size, Paint());

    var alpha = (config.heatMapTransparency * 255).toInt();
    canvas.saveLayer(null, Paint()..color = Color.fromARGB(alpha, 0, 0, 0));
    _drawHeatMap(canvas, page, config);
    canvas.restore();

    var canvasPicture = pictureRecorder.endRecording();
    var pageImage = await canvasPicture.toImage(
      rect.size.width.toInt(),
      rect.size.height.toInt(),
    );
    return imageToBytes(pageImage);
  }

  static Rect _getClippedImageRect(HeatMapPage page) {
    var offset = Offset.zero;
    var size = page.bgSize!;

    return offset & (size * page.pixelRatio);
  }

  static void _drawHeatMap(Canvas canvas, HeatMapPage page, Config config) {
    var clusterScale = config.uiElementSize * page.pixelRatio;
    transform(Offset o) => o * page.pixelRatio;
    var events = page.events.map((e) => transform(e.location)).toList();
    var heatMap = EventProcessor(events: events, pointProximity: clusterScale);

    int layerCount() {
      if (heatMap.largestCluster == 1) return 1;
      return heatMap.largestCluster * config.heatMapStyle.multiplier;
    }

    double calcFraction(int i) => (i - 1) / max((layerCount() - 1), 1);
    double calcBlur(double val) => (4 * val * val + 2) * clusterScale / 10;
    for (var i = 1; i <= layerCount(); i++) {
      var fraction = calcFraction(i);
      var paint = Paint()..color = _getSpectrumColor(fraction);
      if (config.heatMapStyle == HeatMapStyle.smooth) {
        paint.maskFilter =
            MaskFilter.blur(BlurStyle.normal, calcBlur(1 - fraction));
      }
      canvas.drawPath(heatMap.getPathLayer(fraction), paint);
    }
  }

  static Color _getSpectrumColor(double value, {double alpha = 1}) =>
      HSVColor.fromAHSV(alpha, (1 - value) * 225, 1, 1).toColor();
}
