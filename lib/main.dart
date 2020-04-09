import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

import 'map.dart';
import 'models/Category.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp();

  MyApp.forDesignTime();

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

  BottomNavigationBarItem _bottomNavigationItem(String categoryName) {
    switch (categoryName) {
      case 'Amusement':
        return BottomNavigationBarItem(
          icon: Icon(MdiIcons.ferrisWheel),
          title: Text(categoryName),
          backgroundColor: Colors.lightGreen,
        );
      case 'Aquarium':
        return BottomNavigationBarItem(
          icon: Icon(MdiIcons.fish),
          title: Text(categoryName),
          backgroundColor: Colors.indigo,
        );
      case 'Birds':
        return BottomNavigationBarItem(
          icon: Icon(MdiIcons.owl),
          title: Text(categoryName),
          backgroundColor: Colors.lightBlue,
        );
      case 'City':
        return BottomNavigationBarItem(
          icon: Icon(MdiIcons.city),
          title: Text(categoryName),
          backgroundColor: Colors.grey,
        );
      case 'Farm':
        return BottomNavigationBarItem(
          icon: Icon(MdiIcons.cow),
          title: Text(categoryName),
          backgroundColor: Colors.amber,
        );
      case 'Forest':
        return BottomNavigationBarItem(
          icon: Icon(MdiIcons.pineTree),
          title: Text(categoryName),
          backgroundColor: Colors.green,
        );
      case 'Museum':
        return BottomNavigationBarItem(
          icon: Icon(MdiIcons.bank),
          title: Text(categoryName),
          backgroundColor: Colors.purple,
        );
      case 'Zoo':
        return BottomNavigationBarItem(
          icon: Icon(MdiIcons.penguin),
          title: Text(categoryName),
          backgroundColor: Colors.orange,
        );
      case 'On the Way':
        return BottomNavigationBarItem(
          icon: Icon(MdiIcons.train),
          title: Text(categoryName),
          backgroundColor: Colors.blueGrey,
        );
      default:
        return BottomNavigationBarItem(
          icon: Icon(MdiIcons.helpBox),
          title: Text(categoryName),
          backgroundColor: Colors.black38,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final categories = Provider.of<List<Category>>(context);
    if (categories.isEmpty) {
      return Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ActivityMap(category: categories[_selectedIndex]),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        items: categories.map((category) => _bottomNavigationItem(category.name)).toList(),
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
