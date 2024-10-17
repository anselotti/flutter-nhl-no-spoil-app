import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'nhl_service.dart';

class GamesService {
  final NHLService _nhlService = NHLService();

  Future<List<dynamic>> fetchSchedule(DateTime date) async {
    final scheduleData = await _nhlService.fetchSchedule(date);

    return scheduleData['games'];
  }

  Future<Map<String, bool>> fetchVideoAvailability(String gameId) async {
    final videoAvailability = {
      'shortVideo': false,
      'longVideo': false,
    };
    try {
      final gameDetails = await _nhlService.fetchGameDetails(gameId);
      if (gameDetails['gameVideo'] != null) {
        videoAvailability['shortVideo'] = gameDetails['gameVideo']?['threeMinRecap'] != null;
        videoAvailability['longVideo'] = gameDetails['gameVideo']?['condensedGame'] != null;
      }
    } catch (e) {
      throw Exception('Error fetching game: $e');
    }
    return videoAvailability;
  }

  Future<void> playVideo(String gameId, String videoType) async {
    try {
      final gameDetails = await _nhlService.fetchGameDetails(gameId);
      String videoId = gameDetails['gameVideo'][videoType].toString();
      String brightcoveLink =
          'https://players.brightcove.net/6415718365001/D3UCGynRWU_default/index.html?videoId=$videoId';
      _launchUrl(Uri.parse(brightcoveLink));
    } catch (e) {
      throw Exception('Error fetching game: $e');
    }
  }

  Future<void> _launchUrl(Uri url) async {
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }
}