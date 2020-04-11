import 'dart:html';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class WebPlayer extends StatefulWidget {
  final String url;
  final String activityName;
  const WebPlayer({Key key, this.url, this.activityName}) : super(key: key);

  @override
  _WebPlayerState createState() => _WebPlayerState();
}

class _WebPlayerState extends State<WebPlayer> {
  @override
  Widget build(BuildContext context) {
    final _iframeElement = IFrameElement();
    _iframeElement.src = widget.url.replaceFirst('watch?v=', 'embed/');
    _iframeElement.style.border = 'none';

    print(widget.url);

    final k = UniqueKey().toString();

    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(
      k,
      (int viewId) => _iframeElement,
    );

    final _iframeWidget = HtmlElementView(
      key: UniqueKey(),
      viewType: k,
    );
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const BackButtonIcon(),
          onPressed: () {
            Navigator.maybePop(context);
          },
        ),
        title: Text(widget.activityName),
      ),
      body: Center(
        child: _iframeWidget,
      ),
    );
  }
}
