import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

import 'models/category.dart';
import 'utils/hex_color.dart';
import 'youtube_livestream_player.dart';

class ActivityMap extends StatefulWidget {
  final Category category;
  const ActivityMap({@required this.category, Key key}) : super(key: key);
  @override
  _ActivityMapState createState() => _ActivityMapState();
}

class _ActivityMapState extends State<ActivityMap> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => _buildMap(context, constraints, widget.category),
    );
  }

  Widget _buildMap(BuildContext context, BoxConstraints constraints, Category category) {
    final kinds = category.kinds.values.where((kind) => kind.videos.values.any((video) => video.display)).toList();

    const columnCount = 3;
    final lastItemExtraLength = kinds.length % columnCount == 0 ? 0 : columnCount - kinds.length % columnCount;

    final itemHeight = constraints.biggest.height / (kinds.length / columnCount).ceil();

    return StaggeredGridView.countBuilder(
      shrinkWrap: true,
      crossAxisCount: columnCount,
      itemCount: kinds.length,
      itemBuilder: (context, index) => Card(
        child: Material(
          color: HexColor.fromHex(kinds[index].color),
          child: InkWell(
            onTap: () {
              playVideo(context, kinds[index]);
            },
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    flex: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Image.network(
                        'https://firebasestorage.googleapis.com/v0/b/streamap.appspot.com/o/${category.id}%2F${kinds[index].id}.png?alt=media',
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: AutoSizeText(
                      kinds[index].name,
                      maxLines: 1,
                      minFontSize: 8,
                      stepGranularity: 0.1,
                      maxFontSize: 30,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      staggeredTileBuilder: (index) =>
          StaggeredTile.extent(index == kinds.length - 1 ? lastItemExtraLength + 1 : 1, itemHeight),
      mainAxisSpacing: 0,
      crossAxisSpacing: 0,
    );
  }
}

void playVideo(BuildContext context, Kind kind) {
  if (kind == null) {
    return;
  }

  final video = kind.videos.values.firstWhere((video) => video.display);
  context.read<FirebaseAnalytics>().logEvent(name: 'select_video', parameters: {'name': kind.name});

  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => YouTubeLiveStreamPlayer(videoUrl: video.link, activityName: kind.name)),
  );
}

// void _launchLiveStreamUrl(String url) async {
//   if (await canLaunch(url)) {
//     await launch(url);
//   } else {
//     print('Could not launch $url');
//   }
// }
