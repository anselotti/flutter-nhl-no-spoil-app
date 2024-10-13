import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import '/services/nhl_service.dart';
import 'package:intl/intl.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final today = DateFormat('yyyy-MM-dd').format(DateTime.now().toUtc());
  final NHLService _nhlService = NHLService();

  List<dynamic> _games = [];
  Map<String, bool> _showScoresMap = {};
  bool _isLoading = true;
  String _errorMessage = '';
  bool _showScores = false; // Muuttuja, joka hallitsee maalimäärien näkyvyyttä

  @override
  void initState() {
    super.initState();
    _fetchSchedule();
  }

  void _fetchSchedule() async {
    try {
      final scheduleData = await _nhlService.fetchSchedule();
      setState(() {
        if (scheduleData['gameWeek'] != null &&
            scheduleData['gameWeek'][0]['games'] != null) {
          _games = scheduleData['gameWeek'][0]['games'];

          _showScoresMap = {
            for (var game in _games) game['id'].toString(): false
          };
        }
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Virhe tietojen latauksessa: $e';
      });
    }
  }

  Future<void> _playShortVideo(String gameId) async {
    try {
      final gameDetails = await _nhlService.fetchGameDetails(gameId);
      // Hae videoId ja muodosta linkki
      String videoId = gameDetails['gameVideo']['threeMinRecap'].toString();
      String brightcoveLink =
          'https://players.brightcove.net/6415718365001/D3UCGynRWU_default/index.html?videoId=$videoId';

      // Käynnistä video
      _launchUrl(Uri.parse(brightcoveLink));
    } catch (e) {
      setState(() {
        _errorMessage = 'Virhe pelitietojen hakemisessa: $e';
      });
    }
  }

  Future<void> _playLongVideo(String gameId) async {
    try {
      final gameDetails = await _nhlService.fetchGameDetails(gameId);
      // Hae videoId ja muodosta linkki
      String videoId = gameDetails['gameVideo']['condensedGame'].toString();
      String brightcoveLink =
          'https://players.brightcove.net/6415718365001/D3UCGynRWU_default/index.html?videoId=$videoId';

      // Käynnistä video
      _launchUrl(Uri.parse(brightcoveLink));
    } catch (e) {
      setState(() {
        _errorMessage = 'Virhe pelitietojen hakemisessa: $e';
      });
    }
  }

  void _toggleScoreVisibility(String gameId) {
    setState(() {
      _showScoresMap[gameId] =
          !_showScoresMap[gameId]!; // Vaihdetaan yksittäisen pelin näkyvyyttä
    });
  }

  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        // Tarkista, onko pelejä saatavilla
        if (_games.isNotEmpty) ...[
          // Käy läpi kaikki pelit ja luo oma Card jokaiselle
          for (var game in _games) ...[
            if (game['gameScheduleState'] != 'PPD') ...[
            Card(
              color: const Color.fromRGBO(234, 216, 177, 1.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  // Kotijoukkue
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(today), // Näytä päivämäärä
                      TextButton(
                        onPressed: () => _toggleScoreVisibility(
                            game['id'].toString()), // Näytä/piilota maalimäärät
                        child: Text(_showScoresMap[game['id'].toString()]!
                            ? 'Hide scores'
                            : 'Show scores'),
                      ),
                    ],
                  ),
                  ListTile(
                    leading: SvgPicture.network(
                      game['homeTeam']['logo'],
                      placeholderBuilder: (BuildContext context) =>
                          const CircularProgressIndicator(),
                      height: 20.0,
                    ),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(game['homeTeam']['placeName']['default']
                            .toString()),
                        Text(
                          _showScoresMap.containsKey(game['id'].toString()) &&
                                  _showScoresMap[game['id'].toString()]!
                              ? game['homeTeam']['score'].toString()
                              : '',
                        ),
                      ],
                    ),
                  ),
                  // Vieraajoukkue
                  ListTile(
                    leading: SvgPicture.network(
                      game['awayTeam']['logo'],
                      placeholderBuilder: (BuildContext context) =>
                          const CircularProgressIndicator(),
                      height: 20.0,
                    ),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(game['awayTeam']['placeName']['default']
                            .toString()),
                        Text(
                          _showScoresMap.containsKey(game['id'].toString()) &&
                                  _showScoresMap[game['id'].toString()]!
                              ? game['awayTeam']['score'].toString()
                              : '',
                        ),
                      ],
                    ),
                  ),
                  // Toimintopainikkeet
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      TextButton(
                        onPressed: () => _playShortVideo(game['id'].toString()),
                        child: const Row(
                          mainAxisSize: MainAxisSize
                              .min, // Varmistaa, että rivin leveys on minimaalinen
                          children: [
                            Icon(Icons.play_circle_outline_sharp), // Play-ikoni
                            SizedBox(
                                width: 4), // Väliaika ikonin ja tekstin välillä
                            Text('Short'),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      TextButton(
                        onPressed: () => _playLongVideo(game['id'].toString()),
                        child: const Row(
                          mainAxisSize: MainAxisSize
                              .min, // Varmistaa, että rivin leveys on minimaalinen
                          children: [
                            Icon(Icons.movie_creation_sharp), // Play-ikoni
                            SizedBox(
                                width: 4), // Väliaika ikonin ja tekstin välillä
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
            const SizedBox(height: 10), // Väliaika korttien välillä
          ],
        ] else ...[
          if (_isLoading) ...[
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: CircularProgressIndicator(),
            ),
          ] else ...[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(_errorMessage),
            ),
          ],
        ],
      ],
    ));
  }

  Future<void> _launchUrl(Uri url) async {
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }
}
