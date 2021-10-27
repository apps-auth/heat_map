import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'pages/my_app.dart';

String? applicationDocumentsDirectory;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  applicationDocumentsDirectory =
      (await getApplicationDocumentsDirectory()).path;

  runApp(const MyApp());
}
