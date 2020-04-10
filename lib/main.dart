import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

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
      ),
      body: ActivityMap(category: categories[_selectedIndex]),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        items: categories
            .map((category) => BottomNavigationBarItem(
                  icon: category.icon != null ? Icon(MdiIcons.fromString(category.icon)) : MdiIcons.helpBox,
                  title: Text(category.name),
                  backgroundColor: category.color != null ? HexColor(category.color) : Colors.blueGrey,
                ))
            .toList(),
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
