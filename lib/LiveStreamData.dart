import 'dart:math';

import 'package:flutter/material.dart';

class LiveStreamData {
  final String name;
  final String videoCode;
  final Rectangle boundingBox;

  const LiveStreamData(this.name, this.videoCode, this.boundingBox);
}

const snowLeopard = LiveStreamData('Snow Leopard', 'mv_08X3axHI', Rectangle(0, 0, 0.288, 0.28103));
const lion = LiveStreamData('Lion', 'PA3niQ9ECFs', Rectangle(0.31466, 0, 0.376, 0.28103));
const panda = LiveStreamData('Panda', 'Gm3bQVANtVo', Rectangle(0.71733, 0, 0.28266, 0.34894));
const giraffe = LiveStreamData('Giraffe', 'MNJsIXP8GgE', Rectangle(0, 0.311475, 0.42933, 0.283372));
const penguin = LiveStreamData('Penguin', 'mSI7phzCec8', Rectangle(0.456, 0.311475, 0.232, 0.283372));
const elephant = LiveStreamData('Elephant', 'z5F1a7_dsrs', Rectangle(0.71733, 0.374707, 0.28266, 0.398));
const redPanda = LiveStreamData('Red Panda', '_5_oHPJDDOM', Rectangle(0, 0.62295, 0.352, 0.149882));
const coati = LiveStreamData('Coati', 'eZA77byLhGk', Rectangle(0.376, 0.62295, 0.312, 0.149882));
const zebra = LiveStreamData('Zebra', 'ZdWsNl20lf8', Rectangle(0, 0.8032, 0.45066, 0.194379));
const tiger = LiveStreamData('Tiger', 'NVCi9yYwRCY', Rectangle(0.47733, 0.803278, 0.52266, 0.194379));

const funhouse = LiveStreamData('Funhouse', 'hbkIrx4PKVE', Rectangle(0, 0, 0.288, 0.28103));
const rapidsRiver = LiveStreamData('Rapids River', '8iFVmtKraNg', Rectangle(0.31466, 0, 0.376, 0.28103));
const hauntedHouse = LiveStreamData('Haunted House', 'ION9Yg9rEaQ', Rectangle(0.71733, 0, 0.28266, 0.34894));
const twisterRollerCoaster =
    LiveStreamData('Twister Roller Coaster', 'oAJLKDMihnU', Rectangle(0, 0.311475, 0.42933, 0.283372));
const freefallTower =
    LiveStreamData('Freefall Tower', '8ltGKpxsI5A', Rectangle(0.456, 0.311475, 0.232, 0.283372));
const waterExpress =
    LiveStreamData('Water Express', 'LqX05v0tpcI', Rectangle(0.71733, 0.374707, 0.28266, 0.398));
const pirateShip = LiveStreamData('Pirate Ship', 'v5doC68TnHM', Rectangle(0, 0.62295, 0.352, 0.149882));
const chainCarousel =
    LiveStreamData('Chain Carousel', 'umImE3QDeho', Rectangle(0.376, 0.62295, 0.312, 0.149882));
const skyWheel = LiveStreamData('Sky Wheel', 'qFThJucTa50', Rectangle(0, 0.8032, 0.45066, 0.194379));
const shambhalaRollerCoaster = LiveStreamData(
    'Shambhala Roller Coaster', 'x8LA19HfeO0', Rectangle(0.47733, 0.803278, 0.52266, 0.194379));

const parkLiveStreams = [
  funhouse,
  rapidsRiver,
  hauntedHouse,
  twisterRollerCoaster,
  freefallTower,
  waterExpress,
  pirateShip,
  chainCarousel,
  skyWheel,
  shambhalaRollerCoaster,
];

const zooLiveStreams = [
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

LiveStreamData getLiveStream(Size imgSize, Point localPoint, List<LiveStreamData> streams) {
  for (final streamData in streams) {
    final touchArea = Rectangle(
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
