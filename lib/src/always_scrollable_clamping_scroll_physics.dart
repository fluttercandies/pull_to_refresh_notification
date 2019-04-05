import 'package:flutter/material.dart';

///in case list is not full screen and remove ios Bouncing
class AlwaysScrollableClampingScrollPhysics extends ClampingScrollPhysics {
  @override
  bool shouldAcceptUserOffset(ScrollMetrics position) {
    // TODO: implement shouldAcceptUserOffset
    return true;
  }
}
