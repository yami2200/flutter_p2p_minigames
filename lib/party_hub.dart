import 'dart:async';
import 'dart:convert';
import 'dart:math';
import "dart:developer" as dev;

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_p2p_minigames/utils/GameInfo.dart';
import 'package:flutter_p2p_minigames/utils/GameParty.dart';
import 'package:flutter_p2p_minigames/utils/PlayerInGame.dart';
import 'package:flutter_p2p_minigames/widgets/FancyButton.dart';
import 'package:flutter_p2p_minigames/widgets/PlayerScoresRow.dart';
import 'package:go_router/go_router.dart';

import 'main.dart';
import 'network/EventData.dart';
import 'network/EventType.dart';

class GameHubPage extends StatefulWidget {
  const GameHubPage({Key? key}) : super(key: key);

  @override
  _GameHubPageState createState() => _GameHubPageState();
}

class _GameHubPageState extends State<GameHubPage> {
  final player = AudioPlayer();
  final int _gamesPlayed = GameParty().gamesPlayed;
  final int _totalGames = GameParty().maxGames;
  final List<PlayerInGame> _players = GameParty().playerList;
  int _countdown = GameParty().timeBetweenGames;
  GameInfo? nextGame = null;
  Timer? _timer;
  bool end = false;
  String winner = "";

  @override
  void initState() {
    super.initState();
    if(_gamesPlayed == _totalGames){
      GameParty().connection!.sendMessageToServer(jsonEncode(EventData(EventType.READY.text, "ready")));
      onPartyEnd();
      return;
    }
    GameParty().connection!.clearMessageListener();
    if(GameParty().isServer()) {
      nextGame = GameParty().getNextGame();
      GameParty().connection!.sendMessageToClient(jsonEncode(EventData(EventType.NEXT_GAME.text, jsonEncode(nextGame))));
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          _countdown -= 1;
        });
        if (_countdown == 0) {
          timer.cancel();
        }
      });
    }
    GameParty().connection!.addClientMessageListener((message) {
      if(message.type == EventType.NEXT_GAME.text){
        setState(() {
          nextGame = GameInfo.fromJson(jsonDecode(message.data));
        });
        _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
          setState(() {
            _countdown -= 1;
          });
          if (_countdown == 0) {
            timer.cancel();
            if(!GameParty().isServer()){
              BuildContext? ctx = MyApp.router.routerDelegate.navigatorKey.currentContext;
              ctx!.go(nextGame!.path);
            }
          }
        });
      }
    });
    GameParty().connection!.addServerMessageListener((message) {
      if(message.type == EventType.READY.text){
        BuildContext? ctx = MyApp.router.routerDelegate.navigatorKey.currentContext;
        ctx!.go(nextGame!.path);
      }
    });
    dev.log("Listener Setup");
    GameParty().connection!.sendMessageToServer(jsonEncode(EventData(EventType.READY.text, "ready")));
  }

  void onPartyEnd() {
    String ww = "";
    int maxScore = -1;
    for (var p in GameParty().playerList) {
      if(p.score > maxScore){
        maxScore = p.score;
        ww = p.playerInfo.username;
      }
    }
    setState(() {
      winner = ww;
      end = true;
    });
    playEndMusic(winner == GameParty().player!.username);
  }

  void playEndMusic(bool winner) async {
    if(winner) await player.setSource(AssetSource('audios/win.wav'));
    else await player.setSource(AssetSource('audios/lose.wav'));
    await player.resume();
  }

  @override
  void dispose() {
    if(_timer != null){
      _timer!.cancel();
    }
    super.dispose();
  }

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
              child: !end ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Next game',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontFamily: 'SuperBubble',
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      (nextGame == null ? '' : '${nextGame!.name}: ${nextGame!.description}'),
                      style: const TextStyle(
                        fontSize: 22,
                        fontFamily: 'SuperBubble',
                      ),
                    ),
                  ]) : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                    const Text(
                    'FINISHED',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontFamily: 'SuperBubble',
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '$winner won the game !',
                    style: const TextStyle(
                      fontSize: 22,
                      fontFamily: 'SuperBubble',
                    ),
                  ),
                  const SizedBox(height: 16),
                  FancyButton(
                    size: 30,
                    color: const Color(0xFFCA3034),
                    onPressed: () {
                      if(player != null) {
                        player.stop();
                        player.dispose();
                      }
                      BuildContext? ctx = MyApp.router.routerDelegate.navigatorKey.currentContext;
                      ctx!.go("/");
                    },
                    child: const Text(
                      "Quit",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontFamily: 'SuperBubble',
                      ),
                    ),
                  ),
                ]
              ),
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
}