import 'dart:convert';

import 'package:example/utils/consts.dart';
import 'package:flutter/widgets.dart';
import 'package:heat_map/heat_map.dart';
import 'package:flutter/services.dart' show rootBundle;
import '../interfaces/interface.dart';

class HeatMapCloudDataSource implements IHeatMapDataSource {
  @override
  Future<List<Event>> getEventsPerPage(String page) async {
    Map<String, dynamic> map = await _getMap();

    List<Event> events = List<Event>.from(
        ((map[page]?['events']) ?? [])?.map((x) => Event.fromMap(x)));

    return events;
  }

  @override
  Future<ImageProvider?> getImageProviderPerPage(String page) async {
    Map<String, dynamic> map = await _getMap();
    String? imageUrl = map[page]?['image_url'];

    if (imageUrl != null) {
      return NetworkImage(imageUrl);
    }
  }

  Future<Map<String, dynamic>> _getMap() async {
    String json = await rootBundle.loadString(heat_map_data_mock);
    Map<String, dynamic> map = jsonDecode(json);
    return map;
  }
}
