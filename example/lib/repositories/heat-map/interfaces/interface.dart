import 'package:flutter_heat_map/flutter_heat_map.dart';

abstract class IHeatMapRepository {
  Future<HeatMapPage?> getData(String page);
}
