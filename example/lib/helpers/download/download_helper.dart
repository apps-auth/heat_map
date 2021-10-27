import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class DownloadHelper {
  static Future<Uint8List?> download(String url) async {
    try {
      http.Response response = await http.get(Uri.parse(url));
      Uint8List? bytes = response.bodyBytes;

      return bytes;
    } catch (e) {
      debugPrint("ERROR DownloadHelper.download() --> $e");
      return null;
    }
  }
}
