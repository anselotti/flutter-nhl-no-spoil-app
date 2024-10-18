import 'package:flutter/material.dart';

class GamesPage extends StatefulWidget {
  const GamesPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _GamesPageState createState() => _GamesPageState();
}

class _GamesPageState extends State<GamesPage> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: const Center(
        child: Text('Games Page'),
      ),
    );
  }
}
