import 'package:flutter/material.dart';
import 'package:nhl_results_app/screens/results/results.dart';
import 'package:nhl_results_app/widgets/app_bar.dart';
import '/screens/games/games.dart';

class Layout extends StatefulWidget {
  const Layout({super.key});

  @override
  State<Layout> createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ScoreCoverAppBar(
        title: ['ScoreCover - Games', 'ScoreCover - Results'][currentPageIndex],
      ),
      bottomNavigationBar: NavigationBar(
        backgroundColor: const Color.fromRGBO(127, 127, 127, 1.0),
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: const Color.fromRGBO(244, 216, 0, 1.0),
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
        const GamesPage(title: 'Recapp'),

        /// Notifications page
        const Results(),
      ][currentPageIndex],
    );
  }
}
