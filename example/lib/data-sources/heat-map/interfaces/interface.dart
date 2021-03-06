import 'package:flutter/widgets.dart';
import 'package:flutter_heat_map/flutter_heat_map.dart';

abstract class IHeatMapDataSource {
  Future<List<HeatMapEvent>> getEventsPerPage(String page);
  Future<ImageProvider?> getImageProviderPerPage(String page);
}
