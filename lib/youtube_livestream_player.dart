import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

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
    _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(widget.videoUrl),
      flags: YoutubePlayerFlags(
        isLive: true,
        autoPlay: true,
      ),
    );
    super.initState();
  }

  @override
  void deactivate() {
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.activityName),
      ),
      body: Center(
        child: YoutubePlayer(
          controller: _controller,
          liveUIColor: Colors.deepPurpleAccent,
        ),
      ),
    );
  }
}
