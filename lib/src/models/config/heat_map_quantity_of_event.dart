import 'package:flutter/painting.dart';

import '../../../flutter_heat_map.dart';

class HeatMapQuantityOfEvent {
  bool enabled;
  TextStyle textStyle;
  double? paddingTop;
  double? paddingBottom;
  double? paddingRight;
  double? paddingLeft;

  HeatMapQuantityOfEvent({
    this.enabled = false,
    this.paddingTop,
    this.paddingBottom,
    this.paddingRight,
    this.paddingLeft,
    TextStyle? textStyle,
  }) : textStyle = textStyle ??
            const TextStyle(color: Color(0xff000000), fontSize: 35);

  Offset applyPaddingInOffset(Offset offset) {
    Offset newOffset = offset.copyWith();
    if (paddingTop != null) {
      newOffset = newOffset.copyWith(dy: newOffset.dy + paddingTop!);
    }
    if (paddingBottom != null) {
      newOffset = newOffset.copyWith(dy: newOffset.dy - paddingBottom!);
    }
    if (paddingLeft != null) {
      newOffset = newOffset.copyWith(dx: newOffset.dx + paddingLeft!);
    }
    if (paddingRight != null) {
      newOffset = newOffset.copyWith(dx: newOffset.dx - paddingRight!);
    }

    return newOffset;
  }
}
