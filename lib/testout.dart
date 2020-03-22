import 'package:flutter/material.dart';

class Testout extends StatelessWidget {
  Widget _buildRect(int flex) {
    return Flexible(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          decoration: new BoxDecoration(
              color: Colors.red,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.all(Radius.circular(8.0))),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
      Flexible(
          flex: 4,
          child: Column(
            children: <Widget>[
              Flexible(
                flex: 3,
                child: Row(
                  children: <Widget>[_buildRect(2), _buildRect(5)],
                ),
              ),
              Flexible(
                flex: 1,
                child: Row(
                  children: <Widget>[_buildRect(1), _buildRect(1)],
                ),
              )
            ],
          )),
      Flexible(
          flex: 1,
          child: Column(
            children: <Widget>[_buildRect(2), _buildRect(3)],
          )),
    ]);
  }
}
