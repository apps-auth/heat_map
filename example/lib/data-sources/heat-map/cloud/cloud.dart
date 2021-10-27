import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
// import 'package:example/utils/consts.dart';
// import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/widgets.dart';
import 'package:flutter_heat_map/flutter_heat_map.dart';
import 'package:example/helpers/download/download_helper.dart';
import '../interfaces/interface.dart';

class HeatMapCloudDataSource implements IHeatMapDataSource {
  @override
  Future<List<HeatMapEvent>> getEventsPerPage(String page) async {
    Map<String, dynamic> map = await _getMap();

    List<HeatMapEvent> events = List<HeatMapEvent>.from(
        ((map[page]?['events']) ?? [])?.map((x) => HeatMapEvent.fromMap(x)));

    return events;
  }

  @override
  Future<ImageProvider?> getImageProviderPerPage(String page) async {
    Map<String, dynamic> map = await _getMap();
    String? imageUrl = map[page]?['image_url'];

    if (imageUrl != null) {
      Uint8List? bytes = await DownloadHelper.download(imageUrl);

      if (bytes != null) {
        return MemoryImage(bytes);
      }
    }
  }

  Future<Map<String, dynamic>> _getMap() async {
    String json;

    // json = await _getJsonFromAsset();
    json = await _getJsonFromGitHub();

    Map<String, dynamic> map = jsonDecode(json);

    return map;
  }

  Future<String> _getJsonFromGitHub() async {
    String url =
        "https://raw.githubusercontent.com/apps-auth/flutter_heat_map/master/example/src/data_mock/heat_map_data_mock.json";
    http.Response response = await http.get(Uri.parse(url));
    return response.body;
  }

  // Future<String> _getJsonFromAsset() =>
  // rootBundle.loadString(heat_map_data_mock);
}
