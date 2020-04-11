import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'map.dart';
import 'models/Category.dart';
import 'utils/hex_color.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<List<Category>>(create: (_) => streamOfCategories(), initialData: []),
      ],
      child: MaterialApp(
        title: '🦓 StreaMap',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(title: '🦓 StreaMap'),
      ),
    );
  }
}

// filter all categories without videos to be displayed
bool hasDisplayVideos(Category category) {
  return category.kinds.values.any((kind) => kind.videos.values.any((video) => video.display));
}

Stream<List<Category>> streamOfCategories() {
  var ref = Firestore.instance.collection('import');
  return ref
      .snapshots()
      .map((snap) => snap.documents.map((doc) => Category.fromMap(doc.data)).where(hasDisplayVideos).toList());
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

//  void printRemoteConifg() async {
//    final remoteConfig = await RemoteConfig.instance;
//    await remoteConfig.fetch(expiration: const Duration(hours: 5));
//    await remoteConfig.activateFetched();
//    print('welcome message: ' + remoteConfig.getString('database'));
//
//    await Firestore.instance.collection(remoteConfig.getString('database')).getDocuments().then((docs) => {
//          docs.documents.forEach((element) {
//            print(element.data.values);
//          })
//        });
//  }

  @override
  Widget build(BuildContext context) {
    final categories = Provider.of<List<Category>>(context);
    if (categories.isEmpty) {
      return Center(child: CircularProgressIndicator());
    }

    final category = categories[_selectedIndex];
    final icon = category.icon != null ? MdiIcons.fromString(category.icon) : MdiIcons.helpBox;

    return Scaffold(
      appBar: AppBar(
        title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[Icon(icon), SizedBox(width: 8), Text(category.name)]),
        backgroundColor: category.color != null ? HexColor(category.color) : Colors.blueGrey,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.info),
            onPressed: () {
              showInfoDialog(context, categories);
            },
          )
        ],
      ),
      body: ActivityMap(category: categories[_selectedIndex]),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        items: categories
            .map((category) => BottomNavigationBarItem(
                  icon: Icon(category.icon != null ? MdiIcons.fromString(category.icon) : MdiIcons.helpBox),
                  title: Text(category.name),
                  backgroundColor: category.color != null ? HexColor(category.color) : Colors.blueGrey,
                ))
            .toList(),
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  void showInfoDialog(BuildContext context, List<Category> categories) {
    final iconAuthors = categories
        .expand((c) => c.kinds.values.expand((k) => k.videos.values.map((v) => v.display ? v.image.author : '')))
        .toSet()
        .toList();
    iconAuthors.remove('');
    iconAuthors.sort();

    showDialog(
        context: context,
        child: SimpleDialog(
          titlePadding: EdgeInsets.fromLTRB(24, 16, 24, 0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
          title: Column(
            children: <Widget>[
              Text(
                '🦓 StreaMap',
                style: Theme.of(context).textTheme.headline5.copyWith(color: Theme.of(context).primaryColor),
              ),
              SizedBox(height: 8),
              Text(
                'Adventure at home',
                style: Theme.of(context).textTheme.headline6.copyWith(color: Colors.blueGrey),
              ),
              SizedBox(height: 16),
              Text(
                'Brought to you by Ulla and Nils',
                style: TextStyle(fontSize: 14),
              )
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
                          print('You clicked on me!');
                        }),
                  TextSpan(text: ' made by'),
                ]),
              ),
              Column(
                children: iconAuthors
                    .map((author) => Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 4),
                          child: InkWell(
                            onTap: () {
                              launch('https://www.flaticon.com/authors/' + author.replaceAll(RegExp(r'\s|_'), '-'));
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
        ));
  }
}
