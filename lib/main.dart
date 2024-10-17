import 'package:flutter/material.dart';
import 'widgets/layout.dart';

void main() {
  runApp(const MyApp());
}

const primaryColor = Color.fromRGBO(9, 16, 87, 1.0);

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NHL koosteet',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromRGBO(244, 216, 0, 0)),
        useMaterial3: true,
      ),
      home: const Layout(),
    );
  }
}
