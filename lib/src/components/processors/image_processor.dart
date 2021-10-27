import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_heat_map/src/models/config/config.dart';
import 'package:flutter_heat_map/src/models/config/heat_map_style.dart';
import 'package:flutter_heat_map/src/models/page.dart';
import 'package:flutter_heat_map/src/utils/utils.dart';

import '../../../flutter_heat_map.dart';
import '../event_processor.dart';

/// Processes pages into heat maps
class ImageProcessor {
  /// Processes page locally into a heat map
  static Future<Uint8List?> process(
      HeatMapPage page, HeatMapConfig config) async {
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
    await _drawHeatMap(canvas, page, config);
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

  static Future<void> _drawHeatMap(
      Canvas canvas, HeatMapPage page, HeatMapConfig config) async {
    var clusterScale = config.uiElementSize * page.pixelRatio;

    Map<Offset, int> quantityOfEvent = {};

    transform(Offset o) => o * page.pixelRatio;
    List<Offset> events;

    if (config.drawQuantityOfEvent) {
      events = page.events.map((e) {
        Offset offset = transform(e.location);
        quantityOfEvent[offset] = (quantityOfEvent[offset] ?? 0) + 1;
        return offset;
      }).toList();
    } else {
      events = page.events.map((e) => transform(e.location)).toList();
    }

    var heatMap = EventProcessor(events: events, pointProximity: clusterScale);
    await heatMap.init();

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

    if (config.drawQuantityOfEvent) {
      quantityOfEvent.forEach((key, value) => _drawQuantityOfEvent(
            canvas,
            value,
            key,
            config.styleQuantityOfEvent,
          ));
    }
  }

  static const double textWidth = 30;
  static const double textHeight = 20;

  static void _drawQuantityOfEvent(
    Canvas canvas,
    int quantity,
    Offset offset,
    TextStyle style,
  ) {
    TextSpan span = TextSpan(
      style: style,
      text: quantity.toString(),
    );

    TextPainter tp = TextPainter(
      text: span,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    tp.layout();
    tp.paint(
      canvas,
      offset.copyWith(
        dx: offset.dx - textWidth,
        dy: offset.dy - textHeight,
      ),
    );
  }

  static Color _getSpectrumColor(double value, {double alpha = 1}) =>
      HSVColor.fromAHSV(alpha, (1 - value) * 225, 1, 1).toColor();
}
