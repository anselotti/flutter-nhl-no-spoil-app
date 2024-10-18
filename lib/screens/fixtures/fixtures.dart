import 'package:flutter/material.dart';

class Fixtures extends StatelessWidget {
  const Fixtures({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          Center(child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.table_chart_sharp, size: 50.0),
              Text('Fixtures', style: TextStyle(fontSize: 24.0)),
              Text('Coming soon', style: TextStyle(fontSize: 16.0)),
            ],
          )),
        ],
      ),
    );
  }
}