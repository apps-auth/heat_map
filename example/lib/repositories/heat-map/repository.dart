import 'dart:ui' as ui;
import 'package:example/data-sources/heat-map/interfaces/interface.dart';
import 'package:flutter/widgets.dart';
import 'package:heat_map/heat_map.dart';

import 'interfaces/interface.dart';

class HeatMapRepository implements IHeatMapRepository {
  final IHeatMapDataSource dataSource;

  HeatMapRepository(this.dataSource);

  @override
  Future<HeatMapPage?> getData(String page) async {
    ImageProvider? provider = await dataSource.getImageProviderPerPage(page);
    if (provider == null) return null;
    ui.Image? background = await HeatMap.imageProviderToUiImage(provider);

    List<Event> events = await dataSource.getEventsPerPage(page);

    return HeatMapPage(image: background, events: events);
  }
}
