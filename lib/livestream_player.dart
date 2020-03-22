import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class LiveStreamPlayer extends StatefulWidget {
  final String videoUrl;

  const LiveStreamPlayer({Key key, @required this.videoUrl}) : super(key: key);

  @override
  _LiveStreamPlayerState createState() => _LiveStreamPlayerState();
}

class _LiveStreamPlayerState extends State<LiveStreamPlayer> {

  @override
  Widget build(BuildContext context) {
    final videoPlayerController = VideoPlayerController.network(widget.videoUrl);

    final chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      aspectRatio: 3 / 2,
      autoPlay: true,
      looping: true,
    );

    final playerWidget = Chewie(
      controller: chewieController,
    );

    return playerWidget;
  }
}
