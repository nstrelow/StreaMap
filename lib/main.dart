import 'package:StreaMap/map.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'LiveStreamData.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp();
  MyApp.forDesignTime();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '🦓 StreaMap',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: '🦓 StreaMap'),
    );
  }
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

  static const List<Widget> _widgetOptions = <Widget>[
    ActivityMap(
      streams: zooLiveStreams,
      image: 'assets/zoo.png',
    ),
    ActivityMap(
      streams: parkLiveStreams,
      image: 'assets/park.png',
    ),
    ActivityMap(
      streams: zooLiveStreams,
      image: 'assets/zoo.png',
    ),
    ActivityMap(
      streams: parkLiveStreams,
      image: 'assets/park.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: _widgetOptions.elementAt(_selectedIndex),
      )),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(MdiIcons.penguin),
            title: Text('Zoo'),
            backgroundColor: Colors.orange,
          ),
          BottomNavigationBarItem(
            icon: Icon(MdiIcons.ferrisWheel),
            title: Text('Holiday Park'),
            backgroundColor: Colors.lightGreen,
          ),
          BottomNavigationBarItem(
            icon: Icon(MdiIcons.fish),
            title: Text('Aquarium'),
            backgroundColor: Colors.indigo,
          ),
          BottomNavigationBarItem(
            icon: Icon(MdiIcons.bank),
            title: Text('Museum'),
            backgroundColor: Colors.purple,
          ),
        ],
        currentIndex: _selectedIndex,
        //selectedItemColor: Theme.of(context).accentColor,
        onTap: _onItemTapped,
      ),
    );
  }
}

