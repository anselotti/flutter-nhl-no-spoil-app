import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'game_page.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_svg_image/cached_network_svg_image.dart';

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
  Map<String, bool> _loadingMap = {}; // Track loading state for each game

  @override
  void initState() {
    super.initState();
    _fetchVideoAvailability(); // Fetch video availability for each game
  }

  Future<void> _fetchVideoAvailability() async {
    for (var game in widget.games) {
      final gameId = game['id'].toString();
      setState(() {
        _loadingMap[gameId] = true; // Set loading for this game
      });

      // Simulate fetching video availability (replace this with actual fetch)
      await Future.delayed(const Duration(seconds: 2));

      // Mark loading as complete for this game
      setState(() {
        _loadingMap[gameId] = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
              Card(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    if (game['gameState'] == 'OFF') ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                const Icon(Icons.access_time, size: 16),
                                const SizedBox(width: 4),
                                Text(DateFormat('HH:mm').format(DateTime.parse(game['startTimeUTC']).toLocal())),
                              ],
                            ),
                          ),
                           
                        ],

                      )
                    ] else ...[            
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          TextButton(
                            onPressed: () => widget.toggleScoreVisibility(game['id'].toString()),
                            child: Text(
                              widget.showScoresMap[game['id'].toString()]! ? 'Hide scores' : 'Show scores',
                            ),
                          ),
                        ],
                      ),
                    ],
                    ListTile(
                    leading: CachedNetworkSVGImage(
                      game['homeTeam']['logo'],
                        placeholder: const CircularProgressIndicator(),
                        errorWidget: const Icon(Icons.error),
                        height: 20.0,
                      ),
                    
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            game['homeTeam']['name']['default'].toString(),
                            style: const TextStyle(fontSize: 16),
                          ),
                          Text(
                            widget.showScoresMap[game['id'].toString()]! ? game['homeTeam']['score'].toString() : '',
                          ),
                        ],
                      ),
                    ),
                    ListTile(
                      leading: CachedNetworkSVGImage(
                        game['awayTeam']['logo'],
                        placeholder: const CircularProgressIndicator(),
                        errorWidget: const Icon(Icons.error),
                        height: 20.0,
                      ),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            game['awayTeam']['name']['default'].toString(),
                            style: const TextStyle(fontSize: 16),
                          ),
                          Text(
                            widget.showScoresMap[game['id'].toString()]! ? game['awayTeam']['score'].toString() : '',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Divider(thickness: 0.5),
                    const SizedBox(height: 16),
                    
                    // Check loading state for video availability
                    _loadingMap[game['id'].toString()] == true 
                        ? const CircularProgressIndicator() // Show loading indicator
                        : (widget.videoAvailabilityMap[game['id'].toString()]?['shortVideo'] == false &&
                           widget.videoAvailabilityMap[game['id'].toString()]?['longVideo'] == false)
                            ? const Text('No videos available')
                            : Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: ElevatedButton(
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
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: ElevatedButton(
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
                                    ),
                                  ],
                                ),
                              ),
                    
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GamesPage(
                                title: '${game['homeTeam']['name']['default']} vs. ${game['awayTeam']['name']['default']} - ${DateFormat('dd.MM.yyyy').format(DateTime.parse(game['gameDate']))}',
                              ),
                            ),
                          );
                        },
                        child: const Text('View game details'),
                        style: OutlinedButton.styleFrom(
                          minimumSize: Size(double.infinity, 48),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
        ],
      );
    }
  }
}
