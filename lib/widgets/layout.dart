import 'package:flutter/material.dart';
import 'package:nhl_results_app/screens/results.dart';
import '/screens/home.dart';

class Layout extends StatefulWidget {
  const Layout({super.key});

  @override
  State<Layout> createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          <String>[
            'No Spoil NHL - Games',
            'No Spoil NHL - Results',
          ][currentPageIndex],
        ),
        titleTextStyle: const TextStyle(
          color: Color.fromRGBO(255, 255, 255, 1),
          fontSize: 20.0,
        ),
        backgroundColor: const Color.fromRGBO(0, 31, 63, 1.0),
      ),
      bottomNavigationBar: NavigationBar(
        backgroundColor: const Color.fromRGBO(106, 154, 176, 1.0),
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: const Color.fromRGBO(234, 216, 177, 1.0),
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.sports_hockey_sharp),
            icon: Icon(Icons.sports_hockey_sharp),
            label: 'Games',
          ),
          NavigationDestination(
            icon: Badge(
              child: Icon(Icons.calendar_today_sharp),
              ),
            label: 'Results',
          ),
          // NavigationDestination(
          //   icon: Badge(
          //     label: Text('2'),
          //     child: Icon(Icons.messenger_sharp),
          //   ),
          //   label: 'Messages',
          // ),
        ],
      ),
      body: <Widget>[
        /// Home page
        const MyHomePage(title: 'Recapp'),

        /// Notifications page
        const Results(),
      ][currentPageIndex],
    );
  }
}
