import 'package:flutter/material.dart';

class Fixtures extends StatelessWidget {
  const Fixtures({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          Card(
            child: ListTile(
              leading: Icon(Icons.calendar_month_sharp),
              title: Text('Result 1'),
              subtitle: Text('This is a notification'),
            ),
          ),
        ],
      ),
    );
  }
}