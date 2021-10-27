import 'dart:convert';
import 'dart:ui';

import 'package:flutter/gestures.dart';

/// Holds information about a single user interaction
class HeatMapEvent {
  /// Equals [PointerEvent.localPosition]
  final Offset location;

  /// Creates an [HeatMapEvent] with a given [location] and [id]
  HeatMapEvent({this.location = Offset.zero});

  HeatMapEvent copyWith({
    Offset? location,
  }) {
    return HeatMapEvent(
      location: location ?? this.location,
    );
  }

  /// Creates an [HeatMapEvent] from Flutters [PointerEvent]
  HeatMapEvent.fromPointer(PointerEvent event, Offset offset)
      : this(location: event.localPosition + offset);

  factory HeatMapEvent.fromMap(Map<String, dynamic> map) {
    return HeatMapEvent(
      location: OffsetExtensions.fromMap(map['location']),
    );
  }

  /// Converts this [HeatMapEvent] to a json map
  Map<String, dynamic> toMap() => {
        'location': location.toMap(),
      };

  factory HeatMapEvent.fromJson(String source) =>
      HeatMapEvent.fromMap(json.decode(source));

  String toJson() => json.encode(toMap());

  @override
  String toString() => 'Event(location: $location)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is HeatMapEvent && other.location == location;
  }

  @override
  int get hashCode => location.hashCode;
}

extension OffsetExtensions on Offset {
  static fromMap(Map<String, dynamic> map) =>
      Offset(map['x'].toDouble(), map['y'].toDouble());

  Map<String, dynamic> toMap() => {'x': dx, 'y': dy};
}
