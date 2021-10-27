import 'package:example/utils/consts.dart';
import 'package:flutter/widgets.dart';
import 'package:heat_map/heat_map.dart';

import '../interfaces/interface.dart';

class HeatMapLocalDataSource implements IHeatMapDataSource {
  @override
  Future<List<Event>> getEventsPerPage(String page) async => [
        ..._generateEvents(1, const Offset(200, 400)),
        ..._generateEvents(5, const Offset(300, 500)),
        ..._generateEvents(10, const Offset(539, 1250)),
        ..._generateEvents(10, const Offset(967, 2120)),
        ..._generateEvents(100, const Offset(967, 2120)),
        ..._generateEvents(1000, const Offset(960, 193)),
      ];

  List<Event> _generateEvents(int length, Offset location) =>
      List<Event>.filled(length, Event(location: location));

  @override
  Future<ImageProvider?> getImageProviderPerPage(String page) async {
    switch (page) {
      case "first_page":
        return const AssetImage(first_page);
      case "second_page":
        return const AssetImage(second_page);
      case "generate_heatmap_page":
        return const AssetImage(generate_heatmap_page);
      default:
        return null;
    }
  }
}
