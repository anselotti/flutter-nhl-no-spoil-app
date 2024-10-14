import 'package:flutter/material.dart';

class ScoreCoverAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ScoreCoverAppBar({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
     return AppBar(
      backgroundColor: const Color.fromRGBO(7, 7, 7, 1.0),
      title: Text(title, style: const TextStyle(color: Colors.white)),
    );
      
  }

  @override
  Size get preferredSize => const Size.fromHeight(56.0);
}