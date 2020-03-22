import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YouTubeLiveStreamPlayer extends StatefulWidget {
  final String videoCode;

  const YouTubeLiveStreamPlayer({Key key, @required this.videoCode}) : super(key: key);

  @override
  _YouTubeLiveStreamPlayerState createState() => _YouTubeLiveStreamPlayerState();
}

class _YouTubeLiveStreamPlayerState extends State<YouTubeLiveStreamPlayer> {
  @override
  Widget build(BuildContext context) {
    YoutubePlayerController _controller = YoutubePlayerController(
      initialVideoId: widget.videoCode,
      flags: YoutubePlayerFlags(
        isLive: true,
      ),
    );

    return YoutubePlayer(
      controller: _controller,
      liveUIColor: Colors.deepPurpleAccent,
    );
  }
}
