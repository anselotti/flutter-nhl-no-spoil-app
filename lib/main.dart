import 'package:flutter/material.dart';
import 'widgets/layout.dart';

void main() {
  runApp(const MyApp());
}

const primaryColor = Colors.blue;

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NHL koosteet',
      theme: ThemeData(
        colorScheme: ColorScheme.dark(
          primary: Colors.blue,
          secondary: const Color.fromRGBO(244, 216, 0, 1.0),
        )
      ),
      home: const Layout(),
    );
  }
}
