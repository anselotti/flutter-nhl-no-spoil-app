import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'game_page.dart';
import 'package:intl/intl.dart';

class GamesList extends StatefulWidget {
  final List<dynamic> games;
  final Map<String, bool> showScoresMap;
  final Function(String gameId) toggleScoreVisibility;
  final Function(String gameId) playShortVideo;
  final Function(String gameId) playLongVideo;
  final Map<String, Map<String, bool>> videoAvailabilityMap;

  const GamesList({
    Key? key,
    required this.games,
    required this.showScoresMap,
    required this.toggleScoreVisibility,
    required this.playShortVideo,
    required this.playLongVideo,
    required this.videoAvailabilityMap,
  }) : super(key: key);

  @override
  _GamesListState createState() => _GamesListState();
}

class _GamesListState extends State<GamesList> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkVideoAvailability();
  }

  Future<void> _checkVideoAvailability() async {
    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 2)); // Simuloi latausta

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // if (_isLoading) {
    //   return const Center(child: CircularProgressIndicator());
    // }

    if (widget.games.isEmpty) {
      return const Center(
        child: Text('No games found'),
      );
    } else {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          for (var game in widget.games)
            if (game['gameScheduleState'] != 'PPD')
            InkWell(
              onTap: () {
                  // Navigate to GamesPage on card tap
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GamesPage(
                        title: game['homeTeam']['name']['default'] + ' vs. ' +  game['awayTeam']['name']['default'].toString() + ' - ' + DateFormat('dd.MM.yyyy').format(DateTime.parse(game['gameDate'])),
                        ), // Pass the game name or ID
                    ),
                  );
                },
              child: Card(
                color: const Color.fromARGB(255, 68, 68, 68),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(''),
                        TextButton(
                          onPressed: () => widget.toggleScoreVisibility(game['id'].toString()),
                          child: Text(widget.showScoresMap[game['id'].toString()]!
                              ? 'Hide scores'
                              : 'Show scores'),
                        ),
                      ],
                    ),
                    ListTile(
                      leading: SvgPicture.network(
                        game['homeTeam']['logo'],
                        placeholderBuilder: (BuildContext context) => const CircularProgressIndicator(
                          color: Color.fromRGBO(38, 173, 190, 0),
                        ),
                        height: 20.0,
                      ),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(game['homeTeam']['name']['default'].toString()),
                          Text(
                            widget.showScoresMap[game['id'].toString()]!
                                ? game['homeTeam']['score'].toString()
                                : '-',
                          ),
                        ],
                      ),
                    ),
                    ListTile(
                      leading: SvgPicture.network(
                        game['awayTeam']['logo'],
                        placeholderBuilder: (BuildContext context) => const CircularProgressIndicator(
                          color: Color.fromRGBO(38, 173, 190, 0),
                        ),
                        height: 20.0,
                      ),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(game['awayTeam']['name']['default'].toString()),
                          Text(
                            widget.showScoresMap[game['id'].toString()]!
                                ? game['awayTeam']['score'].toString()
                                : '-',
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        if (widget.videoAvailabilityMap[game['id'].toString()]?['shortVideo'] == false && 
                            widget.videoAvailabilityMap[game['id'].toString()]?['longVideo'] == false) ...[
                            const Text('No videos available'),
                        ] else ...[
                          if (widget.videoAvailabilityMap[game['id'].toString()]?['shortVideo'] == true) ...[
                            TextButton(
                              onPressed: () => widget.playShortVideo(game['id'].toString()),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.play_circle_outline_sharp),
                                  SizedBox(width: 4),
                                  Text('Short'),
                                ],
                              ),
                            ),
                          ],
                          const SizedBox(width: 8),
                          if (widget.videoAvailabilityMap[game['id'].toString()]?['longVideo'] == true) ...[
                            TextButton(
                              onPressed: () => widget.playLongVideo(game['id'].toString()),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.movie_creation_sharp),
                                  SizedBox(width: 4),
                                  Text('Long'),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
              
        ],
      );
    }
  }
}