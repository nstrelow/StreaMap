import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'LiveStreamData.dart';
import 'YoutubeLivestreamPlayer.dart';

class ActivityMap extends StatefulWidget {
  @override
  _ActivityMapState createState() => _ActivityMapState();
}

_onTapUp(BuildContext context, TapUpDetails details) {
  RenderBox box = context.findRenderObject();
  Offset localPos = box.globalToLocal(details.globalPosition);

  final x = localPos.dx;
  final y = localPos.dy;
  print("Local Pos " + x.toString() + ", " + y.toString());

  final code = getLiveStreamCode(context.size, Point(x, y));

  playVideo(context, code);
}

playVideo(BuildContext context, String videoCode) {
  if (videoCode.isEmpty) {
    return;
  }

  if (kIsWeb) {
    _launchLiveStreamUrl(videoCode);
  } else {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => YouTubeLiveStreamPlayer(
                videoCode: videoCode,
              )),
    );
  }
}

_launchLiveStreamUrl(String url) async {
  final ytUrl = 'https://www.youtube.com/watch?v=' + url;
  if (await canLaunch(ytUrl)) {
    await launch(ytUrl);
  } else {
    throw 'Could not launch $ytUrl';
  }
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
