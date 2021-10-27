import 'package:example/utils/consts.dart';
import 'package:flutter/widgets.dart';
import 'package:heat_map/heat_map.dart';

import '../interfaces/interface.dart';

class HeatMapLocalDataSource implements IHeatMapDataSource {
  @override
  Future<List<Event>> getEventsPerPage(String page) async => [
        ..._generateEvents(1, const Offset(510, 340)),
        ..._generateEvents(5, const Offset(820, 560)),
        ..._generateEvents(100, const Offset(250, 1250)),
        ..._generateEvents(1000, const Offset(760, 1250)),
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
