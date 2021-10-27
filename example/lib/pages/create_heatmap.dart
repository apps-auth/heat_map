import 'dart:async';
import 'dart:typed_data';
import 'package:example/data-sources/heat-map/cloud/cloud.dart';
import 'package:example/data-sources/heat-map/local/local.dart';
import 'package:example/pages/view_results.dart';
import 'package:example/repositories/heat-map/repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_heat_map/flutter_heat_map.dart';

class CreateHeatMapPage extends StatefulWidget {
  const CreateHeatMapPage({Key? key}) : super(key: key);

  @override
  _CreateHeatMapPageState createState() => _CreateHeatMapPageState();
}

class _CreateHeatMapPageState extends State<CreateHeatMapPage> {
  bool isGenerating = false;

  HeatMapRepository localRepository =
      HeatMapRepository(HeatMapLocalDataSource());
  HeatMapRepository cloudRepository =
      HeatMapRepository(HeatMapCloudDataSource());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Generate HeatMap')),
      body: Center(
        child: isGenerating
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  generateButtons("FirstPage", "first_page"),
                  generateButtons("SecondPage", "second_page", true),
                  generateButtons(
                      "GenerateHeatMapPage", "generate_heatmap_page", true),
                ],
              ),
      ),
    );
  }

  Widget generateButtons(String pageName, String page, [bool? addPaddingTop]) {
    Widget widget = Wrap(
      alignment: WrapAlignment.spaceEvenly,
      spacing: 20,
      children: [
        ElevatedButton(
          child: Text(
            "$pageName local",
            style: const TextStyle(color: Colors.white),
          ),
          onPressed: () async {
            await onPressedLocal(page);
          },
        ),
        ElevatedButton(
          child: Text(
            "$pageName cloud",
            style: const TextStyle(color: Colors.white),
          ),
          style: ElevatedButton.styleFrom(primary: Colors.green),
          onPressed: () async {
            await onPressedCloud(page);
          },
        ),
      ],
    );

    if (addPaddingTop == true) {
      widget = Padding(
        padding: const EdgeInsets.only(top: 25),
        child: widget,
      );
    }

    return widget;
  }

  Future<void> onPressedLocal(String page) =>
      onPressed(page, getHeatMapPageLocal);
  Future<void> onPressedCloud(String page) =>
      onPressed(page, getHeatMapPageCloud);

  Future<void> onPressed(
      String page, Future<HeatMapPage?> Function(String) getHeatMapPage) async {
    debugPrint("---- Start ----");
    setState(() {
      isGenerating = true;
    });

    HeatMapPage? data = await getHeatMapPage(page);
    if (data != null) {
      Uint8List? bytes = await HeatMap.process(
        data,
        HeatMapConfig(drawQuantityOfEvent: true),
      );
      if (bytes != null) {
        showViewResult(context, bytes);
      }
    }

    setState(() {
      isGenerating = false;
    });
    debugPrint("---- End ----");
  }

  Future<HeatMapPage?> getHeatMapPageLocal(String page) =>
      localRepository.getData(page);
  Future<HeatMapPage?> getHeatMapPageCloud(String page) =>
      cloudRepository.getData(page);
}
