import 'package:flutter/painting.dart';

import 'package:equatable/equatable.dart';

import 'heat_map_style.dart';

/// Holds the configuration relating to the
/// specifics of data gathering and processing.
///
/// All properties can be changed at any moment.
// ignore: must_be_immutable
class HeatMapConfig extends Equatable {
  /// Specifies whether the library is currently active and collecting data.
  ///

  /// Allows to adjust for the general UI size.
  ///
  /// This parameter controls the range inside which input event
  /// are clustered together as well as the size of rendered heat map elements.
  ///
  /// Permitted values range from above 0 for large screens and very small
  /// UI elements to around 30 for tiny screens with few large elements.
  /// Suggested range for mobile phones is between 5 and 20.
  /// The default value is 12.
  double uiElementSize;

  // Visuals
  /// Determines the style of the generated heat maps.
  ///
  /// The default value is [HeatMapStyle.smooth].
  HeatMapStyle heatMapStyle;

  /// Sets the transparency of the heat map overlay.
  ///
  /// Takes values between 0 and 1, it's set to 0.75 by default.
  double heatMapTransparency;

  /// If true it will plot the quantity of events
  bool drawQuantityOfEvent;

  /// Text style of quantity of events
  TextStyle styleQuantityOfEvent;

  /// Initializes the configuration.
  HeatMapConfig({
    double? uiElementSize,
    HeatMapStyle? heatMapStyle,
    double? heatMapTransparency,
    bool? drawQuantityOfEvent,
    TextStyle? styleQuantityOfEvent,
  })  : assert(heatMapTransparency == null ||
            heatMapTransparency >= 0 && heatMapTransparency <= 255),
        uiElementSize = uiElementSize ?? 12,
        heatMapStyle = heatMapStyle ?? HeatMapStyle.smooth,
        heatMapTransparency =
            (heatMapTransparency ?? 0.75).clamp(0, 1).toDouble(),
        drawQuantityOfEvent =
            drawQuantityOfEvent ?? styleQuantityOfEvent == null,
        styleQuantityOfEvent = styleQuantityOfEvent ??
            const TextStyle(color: Color(0xff000000), fontSize: 35);

  @override
  List<Object?> get props => [
        uiElementSize,
        heatMapStyle,
        heatMapTransparency,
        drawQuantityOfEvent,
        styleQuantityOfEvent,
      ];
}
