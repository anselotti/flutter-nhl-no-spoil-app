import 'package:flutter/material.dart';
import 'widgets/layout.dart';

void main() {
  runApp(const MyApp());
}

const primaryColor = Color.fromRGBO(193, 255, 114, 1.0);

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ScoreCover',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryColor,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const Layout(),
    );
  }
}
