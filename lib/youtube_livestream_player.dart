import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class YouTubeLiveStreamPlayer extends StatefulWidget {
  final String videoUrl;
  final String activityName;
  const YouTubeLiveStreamPlayer({@required this.videoUrl, this.activityName, Key key}) : super(key: key);

  @override
  _YouTubeLiveStreamPlayerState createState() => _YouTubeLiveStreamPlayerState();
}

class _YouTubeLiveStreamPlayerState extends State<YouTubeLiveStreamPlayer> {
  YoutubePlayerController _controller;
  FirebaseAnalytics analytics;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
        initialVideoId: YoutubePlayerController.convertUrlToId(widget.videoUrl),
        params: YoutubePlayerParams(
          showFullscreenButton: true,
        ));
    analytics = context.read<FirebaseAnalytics>()..setCurrentScreen(screenName: 'video');
  }

  @override
  void deactivate() {
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.reset();
    // Closing the controller throws error on opening new video
    if (!kIsWeb) {
      _controller.close();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.activityName),
        leading: IconButton(
          icon: const BackButtonIcon(),
          onPressed: () {
            analytics.logEvent(name: 'navigate_back', parameters: {'from': widget.activityName});
            Navigator.maybePop(context);
          },
        ),
      ),
      body: Center(
        child: YoutubePlayerIFrame(
          controller: _controller,
        ),
      ),
    );
  }
}
