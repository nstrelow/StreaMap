import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class YouTubeLiveStreamPlayer extends StatefulWidget {
  final videoUrl;
  final activityName;
  const YouTubeLiveStreamPlayer({Key key, @required this.videoUrl, this.activityName}) : super(key: key);

  @override
  _YouTubeLiveStreamPlayerState createState() => _YouTubeLiveStreamPlayerState();
}

class _YouTubeLiveStreamPlayerState extends State<YouTubeLiveStreamPlayer> {
  YoutubePlayerController _controller;
  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
        initialVideoId: YoutubePlayerController.convertUrlToId(widget.videoUrl),
        params: YoutubePlayerParams(
          showFullscreenButton: true,
        ));
  }

  @override
  void deactivate() {
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.close();
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
            context
                .read<FirebaseAnalytics>()
                .logEvent(name: 'navigate_back', parameters: {'from': widget.activityName});
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
