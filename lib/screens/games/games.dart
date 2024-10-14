import 'package:flutter/material.dart';
import '../../services/games_service.dart';
import 'games_list.dart';
import '../../widgets/date_picker.dart';

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
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchSchedule(_selectedDate);
  }

  void _fetchSchedule(DateTime date) async {
    try {
      final scheduleData = await _gamesService.fetchSchedule(date);
      setState(() {
        _games = scheduleData;
        _showScoresMap = {for (var game in _games) game['id'].toString(): false};
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error fetching data: $e';
      });
    }
  }

  void _onDateSelected(DateTime selectedDate) {
    setState(() {
      _selectedDate = selectedDate; // Update selected date
    });
    _fetchSchedule(selectedDate); // Update games
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
          // Show date
          DatePicker(onDateSelected: _onDateSelected),
          _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _games.isEmpty
              ? const Center(child: Text('No games found'))
              : GamesList(
                  games: _games,
                  showScoresMap: _showScoresMap,
                  toggleScoreVisibility: _toggleScoreVisibility,
                  playShortVideo: (gameId) => _gamesService.playVideo(gameId, 'threeMinRecap'),
                  playLongVideo: (gameId) => _gamesService.playVideo(gameId, 'condensedGame'),
                ),
        ],
      ),
    );
  }
}