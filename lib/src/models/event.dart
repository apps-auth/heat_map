import 'dart:convert';
import 'dart:ui';

import 'package:flutter/gestures.dart';

/// Holds information about a single user interaction
class Event {
  /// Equals [PointerEvent.localPosition]
  final Offset location;

  /// Creates an [Event] with a given [location] and [id]
  Event({this.location = Offset.zero});

  Event copyWith({
    Offset? location,
  }) {
    return Event(
      location: location ?? this.location,
    );
  }

  /// Creates an [Event] from Flutters [PointerEvent]
  Event.fromPointer(PointerEvent event, Offset offset)
      : this(location: event.localPosition + offset);

  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      location: OffsetExtensions.fromMap(map['location']),
    );
  }

  /// Converts this [Event] to a json map
  Map<String, dynamic> toMap() => {
        'location': location.toMap(),
      };

  factory Event.fromJson(String source) => Event.fromMap(json.decode(source));

  String toJson() => json.encode(toMap());

  @override
  String toString() => 'Event(location: $location)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Event && other.location == location;
  }

  @override
  int get hashCode => location.hashCode;
}

extension OffsetExtensions on Offset {
  static fromMap(Map<String, dynamic> map) =>
      Offset(map['x'].toDouble(), map['y'].toDouble());

  Map<String, dynamic> toMap() => {'x': dx, 'y': dy};
}
