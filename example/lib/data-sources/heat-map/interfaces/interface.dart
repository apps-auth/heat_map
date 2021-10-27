import 'package:flutter/widgets.dart';
import 'package:heat_map/heat_map.dart';

abstract class IHeatMapDataSource {
  Future<List<Event>> getEventsPerPage(String page);
  Future<ImageProvider?> getImageProviderPerPage(String page);
}
