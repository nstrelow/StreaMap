import 'dart:math';

import 'package:flutter/material.dart';

class LiveStreamData {
  String name;
  String videoCode;
  Rectangle boundingBox;

  LiveStreamData(this.name, this.videoCode, this.boundingBox);
}

final snowLeopard = LiveStreamData('Snow Leopard', 'mv_08X3axHI', Rectangle(0, 0, 0.288, 0.28103));
final lion = LiveStreamData('Lion', 'PA3niQ9ECFs', Rectangle(0.31466, 0, 0.376, 0.28103));
final panda = LiveStreamData('Panda', 'Gm3bQVANtVo', Rectangle(0.71733, 0, 0.28266, 0.34894));
final giraffe = LiveStreamData('Giraffe', 'MNJsIXP8GgE', Rectangle(0, 0.311475, 0.42933, 0.283372));
final penguin = LiveStreamData('Penguin', 'mSI7phzCec8', Rectangle(0.456, 0.311475, 0.232, 0.283372));
final elephant = LiveStreamData('Elephant', 'z5F1a7_dsrs', Rectangle(0.71733, 0.374707, 0.28266, 0.398));
final redPanda = LiveStreamData('Red Panda', '_5_oHPJDDOM', Rectangle(0, 0.62295, 0.352, 0.149882));
final coati = LiveStreamData('Coati', 'eZA77byLhGk', Rectangle(0.376, 0.62295, 0.312, 0.149882));
final zebra = LiveStreamData('Zebra', 'ZdWsNl20lf8', Rectangle(0, 0.8032, 0.45066, 0.194379));
final tiger = LiveStreamData('Tiger', 'NVCi9yYwRCY', Rectangle(0.47733, 0.803278, 0.52266, 0.194379));

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

LiveStreamData getLiveStream(Size imgSize, Point localPoint) {
  for (final streamData in zooLiveStreams) {
    Rectangle touchArea = Rectangle(
        streamData.boundingBox.left * imgSize.width,
        streamData.boundingBox.top * imgSize.height,
        streamData.boundingBox.width * imgSize.width,
        streamData.boundingBox.height * imgSize.height);

    if (touchArea.containsPoint(localPoint)) {
      return streamData;
    }
  }
  return null;
}
