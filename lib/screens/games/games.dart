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
  DateTime _selectedDate = DateTime.now().subtract(const Duration(days: 1));
  final GamesService _gamesService = GamesService();

  final List<Map<String, dynamic>> _games = [];
  final Map<String, bool> _showScoresMap = {};
  final Map<String, Map<String, bool>> _videoAvailabilityMap = {};
  bool _isLoading = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchScheduleAndVideoAvailability(_selectedDate);
  }

  void _fetchScheduleAndVideoAvailability(DateTime date) async {
    setState(() {
      _isLoading = true;
      _games.clear(); // Tyhjennetään aiemmat pelit
      _showScoresMap.clear();
    });

    try {
      final scheduleData = await _gamesService.fetchSchedule(date);

      for (var game in scheduleData) {
        await _loadGameData(game);
      }
      
      setState(() {
        _isLoading = false; // Kaikki pelit ladattu
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error fetching data: $e';
      });
    }
  }

  Future<void> _loadGameData(Map<String, dynamic> game) async {
    final gameId = game['id'].toString();
    final availability = await _gamesService.fetchVideoAvailability(gameId);
    
    setState(() {
      _games.add(game);
      _showScoresMap[gameId] = false;
      _videoAvailabilityMap[gameId] = availability;
    });
  }

  void _onDateSelected(DateTime selectedDate) {
    setState(() {
      _selectedDate = selectedDate;
    });
    _fetchScheduleAndVideoAvailability(selectedDate);
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
          const SizedBox(height: 16),
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
                      videoAvailabilityMap: _videoAvailabilityMap,
                    ),
        ],
      ),
    );
  }
}
