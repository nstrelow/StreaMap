import 'dart:math';

import 'package:flutter/material.dart';

import 'LiveStreamData.dart';

class ActivityMap extends StatefulWidget {
  @override
  _ActivityMapState createState() => _ActivityMapState();
}

_onTapUp(BuildContext context, TapUpDetails details) {
  RenderBox box = context.findRenderObject();
  Offset localPos = box.globalToLocal(details.globalPosition);

  final x = localPos.dx;
  final y = localPos.dy;

  print("Size: " + context.size.toString());

  LiveStreamMap.openLiveStream(context.size, Point(x, y));

  print("Local Pos " + x.toString() + ", " + y.toString());
}

class _ActivityMapState extends State<ActivityMap> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapUp: (TapUpDetails details) => _onTapUp(context, details),
      child: Image(
        image: AssetImage('assets/Livestreammap.png'),
        fit: BoxFit.contain,
      ),
    );
  }
}
