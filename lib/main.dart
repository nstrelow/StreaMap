import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

import 'info_dialog.dart';
import 'map.dart';
import 'models/category.dart';
import 'models/config.dart';
import 'utils/hex_color.dart';

Future<void> main() async {
  await WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(StreaMapApp());
}

class StreaMapApp extends StatelessWidget {
  const StreaMapApp();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<List<Category>>(
            create: (_) => streamOfConfigCategories(),
            initialData: const [],
            catchError: (context, error) {
              print('Error: $error');
              return [];
            }),
        Provider<FirebaseAnalytics>(create: (_) => FirebaseAnalytics())
      ],
      child: MaterialApp(
        title: 'StreaMap',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(title: 'StreaMap'),
      ),
    );
  }
}

// filter all categories without videos to be displayed
bool hasDisplayVideos(Category category) {
  return category.kinds.values.any((kind) => kind.videos.values.any((video) => video.display));
}

Stream<List<Category>> streamOfConfigCategories() {
  return streamOfConfig().flatMap(streamOfCategories);
}

Stream<Config> streamOfConfig() {
  final ref = FirebaseFirestore.instance.collection('config').doc('prod');
  return ref.snapshots().map((snap) => Config.fromMap(snap.data()));
}

Stream<List<Category>> streamOfCategories(Config config) {
  return FirebaseFirestore.instance.collection(config.database).snapshots().map((snap) {
    final categories = snap.docs.map((doc) => Category.fromMap(doc.data())).where(hasDisplayVideos).toList();
    final indexMap = {for (var c in categories) c.id: config.order.contains(c.id) ? config.order.indexOf(c.id) : 1000};
    categories.sort((a, b) => indexMap[a.id] - indexMap[b.id]);
    return categories;
  });
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key, this.title}) : super(key: key);

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

  List<String> _iconAuthors(List<Category> categories) => categories
      .expand((c) => c.kinds.values.expand((k) => k.videos.values.map((v) => v.display ? v.image.author : '')))
      .toSet()
      .toList()
        ..remove('')
        ..sort();

  FirebaseAnalytics analytics;

  @override
  void initState() {
    super.initState();
    analytics = context.read<FirebaseAnalytics>()..setCurrentScreen(screenName: 'categories');
  }

  @override
  Widget build(BuildContext context) {
    final categories = context.watch<List<Category>>();

    if (categories.isEmpty) {
      return Scaffold(
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Image.asset('assets/logo-wide.png'), CircularProgressIndicator()],
        )),
      );
    }

    final category = categories[_selectedIndex];
    final icon = category.icon != null ? MdiIcons.fromString(category.icon) : MdiIcons.helpBox;

    return Scaffold(
      appBar: AppBar(
        title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[Icon(icon), SizedBox(width: 8), Text(category.name)]),
        backgroundColor: category.color != null ? HexColor.fromHex(category.color) : Colors.blueGrey,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.info),
            onPressed: () {
              showDialog(context: context, builder: (context) => InfoDialog(iconAuthors: _iconAuthors(categories)));
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
                  backgroundColor: category.color != null ? HexColor.fromHex(category.color) : Colors.blueGrey,
                ))
            .toList(),
        currentIndex: _selectedIndex,
        onTap: (index) {
          analytics.logEvent(name: 'select_category', parameters: {'name': categories[index].name});
          _onItemTapped(index);
        },
      ),
    );
  }
}
