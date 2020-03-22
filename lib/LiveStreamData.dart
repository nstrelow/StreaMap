import 'dart:math';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class LiveStreamData {
  String name;
  String videoUrl;
  Rectangle boundingBox;

  LiveStreamData(this.name, this.videoUrl, this.boundingBox);
}

// 2.75 actual emulator, but web is hardcoded to 1.0
// physicalSize Size(1920.0, 969.0)
// Size(392.7, 759.3)
// 375.3, 426.5

final width = 375;
final height = 427.5;

final snowLeopard =
    LiveStreamData('Snow Leopard', 'https://www.youtube.com/watch?v=mv_08X3axHI', Rectangle(0, 0, 0.288, 0.28103));
final lion = LiveStreamData('Lion', 'https://www.youtube.com/watch?v=PA3niQ9ECFs', Rectangle(0.31466, 0, 0.376, 0.28103));
final panda = LiveStreamData('Panda', 'https://www.youtube.com/watch?v=Gm3bQVANtVo', Rectangle(0.71733, 0, 0.28266, 0.34894));
final giraffe =
    LiveStreamData('Giraffe', 'https://www.youtube.com/watch?v=MNJsIXP8GgE', Rectangle(0, 0.311475, 0.42933, 0.283372));
final penguin =
    LiveStreamData('Penguin', 'https://www.youtube.com/watch?v=mSI7phzCec8', Rectangle(0.456, 0.311475, 0.232, 0.283372));
final elephant =
    LiveStreamData('Elephant', 'https://www.youtube.com/watch?v=z5F1a7_dsrs', Rectangle(0.71733, 0.374707, 0.28266, 0.398));
final redPanda =
    LiveStreamData('Red Panda', 'https://www.youtube.com/watch?v=_5_oHPJDDOM', Rectangle(0, 0.62295, 0.352, 0.149882));
final coati = LiveStreamData('Coati', 'https://www.youtube.com/watch?v=eZA77byLhGk', Rectangle(0.376, 0.62295, 0.312, 0.149882));
final zebra = LiveStreamData('Zebra', 'https://www.youtube.com/watch?v=ZdWsNl20lf8', Rectangle(0, 0.8032, 0.45066, 0.194379));
final tiger =
    LiveStreamData('Tiger', 'https://www.youtube.com/watch?v=NVCi9yYwRCY', Rectangle(0.47733, 0.803278, 0.52266, 0.194379));

final zooLiveStreams = [
  snowLeopard,
  lion,
  panda,
  giraffe,
  penguin,
  elephant,
  redPanda,
  coati,
  zebra,
  tiger,
];

class LiveStreamMap {
  static openLiveStream(Size imgSize, Point localPoint) {
    for (final e in zooLiveStreams) {
      Rectangle touchArea = Rectangle(e.boundingBox.left * imgSize.width, e.boundingBox.top * imgSize.height,
          e.boundingBox.width * imgSize.width, e.boundingBox.height * imgSize.height);
      if (touchArea.containsPoint(localPoint)) {
        _launchLiveStreamUrl(e.videoUrl);
        break;
      }
    }
  }

  static _launchLiveStreamUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
