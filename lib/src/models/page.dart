// ignore_for_file: lines_longer_than_80_chars

import 'dart:ui';

import '../utils/utils.dart';
import 'event.dart';

/// Holds information about user interactions with a particular
/// [area] on some [page] during some period of time.
class HeatMapPage {
  /// Events registered in this [HeatMapPage]
  List<Event> events = [];

  int get eventCount => events.length;

  /// Page screenshot
  Image? image;

  /// Returns the background size corrected for the image scaling
  Size? get bgSize => image != null ? image!.size / pixelRatio : null;

  /// Determines this page output resolution
  final double pixelRatio;

  HeatMapPage({
    this.pixelRatio = 1,
    required this.image,
    this.events = const [],
  });

  @override
  String toString() {
    return 'Session(pixelRatio: $pixelRatio, image: $image, eventCount: $eventCount)';
  }
}
