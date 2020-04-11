import 'package:StreaMap/web_player.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:url_launcher/url_launcher.dart';

import 'models/Category.dart';
import 'utils/hex_color.dart';
import 'youtube_livestream_player.dart';

class ActivityMap extends StatefulWidget {
  final Category category;
  const ActivityMap({Key key, @required this.category}) : super(key: key);
  @override
  _ActivityMapState createState() => _ActivityMapState();
}

class _ActivityMapState extends State<ActivityMap> {
  @override
  Widget build(BuildContext context) {
    return _buildMap(context, widget.category);
  }

  Widget _buildMap(BuildContext context, Category category) {
    final kinds = category.kinds.values.where((kind) => kind.videos.values.any((video) => video.display)).toList();

    final columnCount = 3;
    final lastItemExtraLength = kinds.length % columnCount == 0 ? 0 : columnCount - kinds.length % columnCount;
    final height = MediaQuery.of(context).size.height -
        kToolbarHeight -
        kBottomNavigationBarHeight -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;
    final itemHeight = height / (kinds.length / columnCount).ceil();

    return StaggeredGridView.countBuilder(
      shrinkWrap: true,
      crossAxisCount: columnCount,
      itemCount: kinds.length,
      itemBuilder: (BuildContext context, int index) => Card(
        child: Material(
          color: HexColor(kinds[index].color),
          child: InkWell(
            onTap: () {
              playVideo(context, kinds[index]);
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Image.network(
                        'https://firebasestorage.googleapis.com/v0/b/streamap.appspot.com/o/${category.id}%2F${kinds[index].id}.png?alt=media',
                      ),
                    ),
                  ),
                  Text(
                    kinds[index].name,
                    style: Theme.of(context).textTheme.bodyText1.copyWith(color: Colors.white),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      staggeredTileBuilder: (int index) =>
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

  if (foundation.kIsWeb) {
    //_launchLiveStreamUrl(video.link);
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => WebPlayer(
                url: video.link,
                activityName: kind.name,
              )),
    );
  } else {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => YouTubeLiveStreamPlayer(videoUrl: video.link, activityName: kind.name)),
    );
    //}
  }
}

void _launchLiveStreamUrl(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
