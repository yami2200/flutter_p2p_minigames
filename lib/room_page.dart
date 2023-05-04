import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_p2p_minigames/utils/GameParty.dart';
import 'package:flutter_p2p_minigames/utils/PlayerInfo.dart';
import 'package:flutter_p2p_minigames/widgets/PlayerInfoRow.dart';
import 'package:go_router/go_router.dart';

import 'main.dart';
import 'network/EventData.dart';
import 'network/EventType.dart';
import 'network/PeerToPeer.dart';
import 'utils/Storage.dart';

class RoomPage extends StatefulWidget {
  @override
  _RoomPageState createState() => _RoomPageState();
}

class _RoomPageState extends State<RoomPage> {
  final Future<PlayerInfo> _playerInfo = Storage().getPlayerInfo();
  final Completer<PlayerInfo> _myOpponentCompleter = Completer<PlayerInfo>();
  Future<PlayerInfo> get _opponentInfo => _myOpponentCompleter.future;

  @override
  void initState() {
    super.initState();
    PeerToPeer().clearP2PConnectionListener();
    PeerToPeer().clearP2PPeersChangeListener();
    GameParty().connection!.addClientMessageListener((message) {
      log("Received message: $message");
      if(message.type == EventType.PLAYER_JOINED.text){
        PlayerInfo newPlayer = PlayerInfo.fromJson(jsonDecode(message.data));
        _myOpponentCompleter.complete(newPlayer);
      } else if(message.type == EventType.START_GAME.text){
        startGame();
      }
    });
    sendPlayerInfoToHost();
  }

  void startGame() async {
    final futures = [
      _playerInfo,
      _opponentInfo,
    ];
    final results = await Future.wait(futures);
    List<PlayerInfo> playerList = results;
    GameParty().startGame(playerList);
    openHub();
  }

  void openHub(){
    BuildContext? ctx = MyApp.router.routerDelegate.navigatorKey.currentContext;
    ctx!.go("/hub");
  }

  void sendPlayerInfoToHost() async {
    PlayerInfo player = await Storage().getPlayerInfo();
    GameParty().connection!.sendMessageToServer(jsonEncode(EventData(EventType.PLAYER_JOINED.text, jsonEncode(player))));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Waiting room',
            style: TextStyle(
              fontFamily: 'SuperBubble',
              fontSize: 24,
            )),
        backgroundColor: const Color.fromRGBO(68, 71, 50, 1.0),
      ),
      body: Container(
        decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/ui/background_create.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child:Padding(
      padding: const EdgeInsets.all(16.0),
      child:Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
              child: Card(
                color: const Color.fromRGBO(254, 223, 176, 0.8),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child:Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Player list :',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'SuperBubble',
                          ),
                        ),
                        const SizedBox(height: 16),
                        PlayerInfoRow(playerInfo: _playerInfo),
                        PlayerInfoRow(playerInfo: _opponentInfo),
                      ]),
                ),
              ),
            ),
          const Spacer(),
          const Center(
              child: Text(
                'Waiting for host to launch the game...',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 25,
                    fontFamily: 'SuperBubble',
                    color: Colors.black),
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