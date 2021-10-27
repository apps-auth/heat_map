# <div align="center"><img src="https://raw.githubusercontent.com/apps-auth/heat_map/master/assets/logo.png" alt="icon" width="100"><br> Heat Map</div>

### <div align="center"> Customizable heat map interface library </div>
<div align="center">
<img src="https://raw.githubusercontent.com/apps-auth/heat_map/master/assets/screens/page.png" style="width: 100%" alt="Banner"><br>
</div>

- The **flutter_heat_map** simplifies the generation of heat maps.
- From a base image, it is necessary to pass the coordinates of the events and the library returns the image with the heat map
- This package is inspired by **[round_spot](https://pub.dev/packages/round_spot)**


## Usage
Import the package:
```dart
import 'package:flutter_heat_map/flutter_heat_map.dart';
```

Create a `HeatMapPage`:
```dart
HeatMapPage data = await getHeatMapPage();
```

Process the data using `HeatMap.process(data)`:
```dart
Uint8List? bytes = await HeatMap.process(data);
```

Display the data on screen using `Image.memory(bytes)`:
```dart
Image.memory(bytes)
```

## Example
See [sample application](https://github.com/apps-auth/heat_map/tree/master/example)
Example of how to create `HeatMapPage`:
```dart
 Future<HeatMapPage?> getHeatMapPage(String page) async {
    ImageProvider? provider = await dataSource.getImageProviderPerPage(page);
    if (provider == null) return null;
    ui.Image? image = await HeatMap.imageProviderToUiImage(provider);

    List<Event> events = await dataSource.getEventsPerPage(page);

    return HeatMapPage(image: image, events: events);
  }

  Future<ImageProvider?> getImageProviderPerPage(String page) async {
    switch (page) {
      case "first_page":
        return const AssetImage(first_page);
      case "second_page":
        return const AssetImage(second_page);
      case "generate_heatmap_page":
        return const AssetImage(generate_heatmap_page);
      default:
        return null;
    }
  }

  Future<List<Event>> getEventsPerPage(String page) async {
    switch (page) {
      case "first_page":
        return [
          ..._generateEvents(1, const Offset(510, 340)),
          ..._generateEvents(5, const Offset(820, 560)),
          ..._generateEvents(100, const Offset(250, 1250)),
          ..._generateEvents(1000, const Offset(760, 1250)),
        ];
      case "second_page":
        return [
          ..._generateEvents(1000, const Offset(510, 340)),
          ..._generateEvents(500, const Offset(820, 560)),
          ..._generateEvents(100, const Offset(250, 1250)),
          ..._generateEvents(10, const Offset(760, 1250)),
        ];
      case "generate_heatmap_page":
        return [
          ..._generateEvents(10, const Offset(510, 340)),
          ..._generateEvents(500, const Offset(820, 560)),
          ..._generateEvents(1500, const Offset(250, 1250)),
          ..._generateEvents(5000, const Offset(760, 1250)),
        ];
      default:
        return [];
    }
  }

  List<Event> _generateEvents(int length, Offset location) =>
      List<Event>.filled(length, Event(location: location));
```

## License
This tool is licenced under [`MIT License`](https://github.com/apps-auth/heat_map/blob/master/LICENSE)