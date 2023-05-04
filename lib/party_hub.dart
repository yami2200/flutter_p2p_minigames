import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_p2p_minigames/utils/GameParty.dart';
import 'package:flutter_p2p_minigames/utils/PlayerInGame.dart';
import 'package:flutter_p2p_minigames/widgets/PlayerScoresRow.dart';

class GameHubPage extends StatefulWidget {
  const GameHubPage({Key? key}) : super(key: key);

  @override
  _GameHubPageState createState() => _GameHubPageState();
}

class _GameHubPageState extends State<GameHubPage> {
  int _gamesPlayed = GameParty().gamesPlayed.length;
  final int _totalGames = GameParty().maxGames;
  final List<PlayerInGame> _players = GameParty().playerList;
  int _countdown = GameParty().timeBetweenGames;
  Timer? _timer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
          image: AssetImage('assets/ui/background_hub.jpg'),
          fit: BoxFit.cover,
          ),
        ),
        child:Padding(
        padding: const EdgeInsets.all(16.0),
        child:Column(
        children: [
          const SizedBox(height: 16),
        Card(
          color: const Color.fromRGBO(254, 223, 176, 0.8),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child:Text(
                'Games played $_gamesPlayed/$_totalGames',
                style: const TextStyle(fontSize: 24,
                fontFamily: 'SuperBubble'
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            color: const Color.fromRGBO(254, 223, 176, 0.8),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child:Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Player list : ',
                      style: TextStyle(
                        fontSize: 24,
                        fontFamily: 'SuperBubble',
                      ),
                    ),
                    const SizedBox(height: 16),
                    for (var player in _players) ...[
                      const SizedBox(height: 8),
                      PlayerScoresRow(playerInfo: player.playerInfo, score: player.score),
                    ],
                  ]),
              ),
            ),
          const SizedBox(height: 16),
          Card(
            color: const Color.fromRGBO(32, 52, 133, 0.8),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child:Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      'Next game',
                      style: TextStyle(
                        fontSize: 24,
                        fontFamily: 'SuperBubble',
                      ),
                    ),
                    SizedBox(height: 16),
                  ]),
            ),
          ),
          const Spacer(),
          Card(
            color: const Color.fromRGBO(254, 223, 176, 0.8),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child:Text(
                'Countdown: $_countdown',
                style: const TextStyle(fontSize: 24,
                fontFamily: 'SuperBubble'),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // Simulate changing data
    Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _countdown -= 1;
      });
      if (_countdown == 0) {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    if(_timer != null){
      _timer!.cancel();
    }
    super.dispose();
  }
}