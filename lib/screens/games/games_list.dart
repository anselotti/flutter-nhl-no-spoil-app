import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GamesList extends StatelessWidget {
  final List<dynamic> games;
  final Map<String, bool> showScoresMap;
  final Function(String gameId) toggleScoreVisibility;
  final Function(String gameId) playShortVideo;
  final Function(String gameId) playLongVideo;

  const GamesList({
    Key? key,
    required this.games,
    required this.showScoresMap,
    required this.toggleScoreVisibility,
    required this.playShortVideo,
    required this.playLongVideo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (games.isEmpty) {
      return const Center(
        child: Text('No games found'),
      );
    } else {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          for (var game in games)
            if (game['gameScheduleState'] != 'PPD')
              Card(
                color: const Color.fromRGBO(236, 241, 242, 1.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        TextButton(
                          onPressed: () => toggleScoreVisibility(game['id'].toString()),
                          child: Text(showScoresMap[game['id'].toString()]!
                              ? 'Hide scores'
                              : 'Show scores'),
                        ),
                      ],
                    ),
                    ListTile(
                      leading: SvgPicture.network(
                        game['homeTeam']['logo'],
                        placeholderBuilder: (BuildContext context) => const CircularProgressIndicator(),
                        height: 20.0,
                      ),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(game['homeTeam']['placeName']['default'].toString()),
                          Text(
                            showScoresMap[game['id'].toString()]!
                                ? game['homeTeam']['score'].toString()
                                : '-',
                          ),
                        ],
                      ),
                    ),
                    ListTile(
                      leading: SvgPicture.network(
                        game['awayTeam']['logo'],
                        placeholderBuilder: (BuildContext context) => const CircularProgressIndicator(),
                        height: 20.0,
                      ),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(game['awayTeam']['placeName']['default'].toString()),
                          Text(
                            showScoresMap[game['id'].toString()]!
                                ? game['awayTeam']['score'].toString()
                                : '-',
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        TextButton(
                          onPressed: () => playShortVideo(game['id'].toString()),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.play_circle_outline_sharp),
                              SizedBox(width: 4),
                              Text('Short'),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        TextButton(
                          onPressed: () => playLongVideo(game['id'].toString()),
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
                    ),
                  ],
                ),
              ),
        ],
      );
    }
  }
}