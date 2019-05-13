import 'package:flutter/material.dart';

///in case list is not full screen and remove ios Bouncing
class AlwaysScrollableClampingScrollPhysics extends ClampingScrollPhysics {
  const AlwaysScrollableClampingScrollPhysics({ScrollPhysics parent})
      : super(parent: parent);

  @override
  AlwaysScrollableClampingScrollPhysics applyTo(ScrollPhysics ancestor) {
    // TODO: implement applyTo
    return AlwaysScrollableClampingScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  bool shouldAcceptUserOffset(ScrollMetrics position) {
    // TODO: implement shouldAcceptUserOffset
    return true;
  }
}
