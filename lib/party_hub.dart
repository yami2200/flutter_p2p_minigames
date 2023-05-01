import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_p2p_minigames/utils/GameParty.dart';
import 'package:flutter_p2p_minigames/utils/PlayerInGame.dart';

class GameHubPage extends StatefulWidget {
  const GameHubPage({Key? key}) : super(key: key);

  @override
  _GameHubPageState createState() => _GameHubPageState();
}

class _GameHubPageState extends State<GameHubPage> {
  int _gamesPlayed = GameParty().gamesPlayed.length;
  int _totalGames = GameParty().maxGames;
  List<PlayerInGame> _players = GameParty().playerList;
  int _countdown = GameParty().timeBetweenGames;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Game Hub'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          Text(
            'games played $_gamesPlayed/$_totalGames',
            style: const TextStyle(fontSize: 24),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: _players.length,
              itemBuilder: (context, index) {
                final player = _players[index];
                return ListTile(
                  leading: Image.asset(
                    "assets/avatars/"+player.playerInfo.avatar,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  title: Text(player.playerInfo.username),
                  subtitle: Text('Score: ${player.score}'),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Countdown: $_countdown',
            style: const TextStyle(fontSize: 24),
          ),
          const SizedBox(height: 16),
        ],
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
}