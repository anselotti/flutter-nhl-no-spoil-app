import 'package:flutter/material.dart';
import '../../services/games_service.dart';
import '../../widgets/date_picker.dart';
import 'games_list.dart';

class GamesPage extends StatefulWidget {
  const GamesPage({super.key, required this.title});

  final String title;

  @override
  State<GamesPage> createState() => _GamesPageState();
}

class _GamesPageState extends State<GamesPage> {
  DateTime _selectedDate = DateTime.now();
  final GamesService _gamesService = GamesService();

  List<dynamic> _games = [];
  Map<String, bool> _showScoresMap = {};
  Map<String, Map<String, bool>> _videoAvailabilityMap = {};
  bool _isLoading = true; // Lataustilan seurantaan pelien ja videoiden haun aikana
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchScheduleAndVideoAvailability(_selectedDate); // Haetaan pelitiedot ja videoiden saatavuus ensimmäisen kerran
  }

  void _fetchScheduleAndVideoAvailability(DateTime date) async {
    setState(() {
      _isLoading = true; // Aloitetaan lataus
    });

    try {
      final scheduleData = await _gamesService.fetchSchedule(date);
      setState(() {
        _games = scheduleData;
        _showScoresMap = {for (var game in _games) game['id'].toString(): false};
      });

      // Kun pelit on ladattu, haetaan videoiden saatavuus
      await _fetchVideoAvailability();

      setState(() {
        _isLoading = false; // Lataus valmis
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error fetching data: $e';
      });
    }
  }

  Future<void> _fetchVideoAvailability() async {
    try {
      Map<String, Map<String, bool>> videoAvailability = {};
      for (var game in _games) {
        final gameId = game['id'].toString();
        final availability = await _gamesService.fetchVideoAvailability(gameId);
        videoAvailability[gameId] = availability;
      }
      setState(() {
        _videoAvailabilityMap = videoAvailability;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error fetching video availability: $e';
      });
    }
  }

  void _onDateSelected(DateTime selectedDate) {
    setState(() {
      _selectedDate = selectedDate; // Päivitetään valittu päivämäärä
    });
    _fetchScheduleAndVideoAvailability(selectedDate); // Hae pelitiedot ja videoiden saatavuus valitun päivämäärän perusteella
  }

  void _toggleScoreVisibility(String gameId) {
    setState(() {
      _showScoresMap[gameId] = !_showScoresMap[gameId]!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DatePicker(onDateSelected: _onDateSelected),
          _isLoading
              ? const Center(child: CircularProgressIndicator(
                color: Colors.blue,
              )) // Näytetään spinneri, kun tietoja haetaan
              : _games.isEmpty
                  ? const Center(child: Text('No games found'))
                  : GamesList(
                      games: _games,
                      showScoresMap: _showScoresMap,
                      toggleScoreVisibility: _toggleScoreVisibility,
                      playShortVideo: (gameId) => _gamesService.playVideo(gameId, 'threeMinRecap'),
                      playLongVideo: (gameId) => _gamesService.playVideo(gameId, 'condensedGame'),
                      videoAvailabilityMap: _videoAvailabilityMap,
                    ),
        ],
      ),
    );
  }
}
