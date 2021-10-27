import 'package:heat_map/heat_map.dart';

abstract class IHeatMapRepository {
  Future<HeatMapPage?> getData(String page);
}
