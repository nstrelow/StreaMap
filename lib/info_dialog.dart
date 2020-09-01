import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';

import 'version.dart';

class InfoDialog extends StatefulWidget {
  final List<String> iconAuthors;

  const InfoDialog({@required this.iconAuthors, Key key}) : super(key: key);

  @override
  _InfoDialogState createState() => _InfoDialogState();
}

class _InfoDialogState extends State<InfoDialog> {
  String appName;
  String version;
  String buildNumber;

  Future<void> getVersion() async {
    appName = 'StreaMap';
    version = versionName;
    buildNumber = 'web';

    if (!kIsWeb) {
      final packageInfo = await PackageInfo.fromPlatform();
      setState(() {
        appName = packageInfo.appName;
        version = packageInfo.version;
        buildNumber = packageInfo.buildNumber;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getVersion();
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      titlePadding: EdgeInsets.fromLTRB(24, 16, 24, 0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
      title: Column(
        children: <Widget>[
          Text(
            '🦓 $appName',
            style: Theme.of(context).textTheme.headline4.copyWith(color: Theme.of(context).primaryColor),
          ),
          SizedBox(height: 8),
          Text(
            'Adventure at home',
            style: Theme.of(context).textTheme.headline6.copyWith(color: Colors.blueGrey),
          ),
          SizedBox(height: 8),
          Text(
            'Brought to you by Ulla and Nils',
            style: TextStyle(fontSize: 14),
          ),
          SizedBox(height: 8),
          Text('Version: $version-$buildNumber', style: TextStyle(fontSize: 14)),
        ],
      ),
      contentPadding: EdgeInsets.all(24),
      children: <Widget>[
        Column(children: <Widget>[
          RichText(
            text: TextSpan(style: Theme.of(context).textTheme.headline6, children: [
              TextSpan(text: 'Icons from '),
              TextSpan(
                  style: TextStyle(color: Colors.blue),
                  text: 'www.flaticon.com',
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      launch('https://www.flaticon.com/');
                    }),
              TextSpan(text: ' made by'),
            ]),
          ),
          Column(
            children: widget.iconAuthors
                .map((author) => Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 4),
                      child: InkWell(
                        onTap: () {
                          launch('https://www.flaticon.com/authors/${author.replaceAll(RegExp(r'\s|_'), '-')}');
                        },
                        child: Text(
                          author,
                          style: TextStyle(fontSize: 18, color: Colors.blue),
                        ),
                      ),
                    ))
                .toList(),
          )
        ])
      ],
    );
  }
}
