import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_p2p_minigames/utils/GameParty.dart';
import 'package:flutter_p2p_minigames/utils/PlayerInfo.dart';
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
  List<PlayerInfo> playerList = [];

  @override
  void initState() {
    super.initState();
    addPlayerInfo();
    PeerToPeer().clearP2PConnectionListener();
    PeerToPeer().clearP2PPeersChangeListener();
    GameParty().connection!.addClientMessageListener((message) {
      log("Received message: $message");
      if(message.type == EventType.PLAYER_JOINED.text){
        PlayerInfo newPlayer = PlayerInfo.fromJson(jsonDecode(message.data));
        setState(() {
          playerList.add(newPlayer);
        });
      } else if(message.type == EventType.START_GAME.text){
        GameParty().startGame(playerList);
        BuildContext? ctx = MyApp.router.routerDelegate.navigatorKey.currentContext;
        ctx!.go("/hub");
      }
    });
    sendPlayerInfoToHost();
  }

  void sendPlayerInfoToHost() async {
    PlayerInfo player = await Storage().getPlayerInfo();
    GameParty().connection!.sendMessageToServer(jsonEncode(EventData(EventType.PLAYER_JOINED.text, jsonEncode(player))));
  }

  void addPlayerInfo() async {
    PlayerInfo player = await Storage().getPlayerInfo();
    setState(() {
      playerList.add(player);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Player List'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child: ListView.builder(
                itemCount: playerList.length,
                itemBuilder: (BuildContext context, int index) {
                  final player = playerList[index];
                  final username = player.username;
                  final tag = player.tag;
                  final avatar = player.avatar;

                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          backgroundImage: AssetImage('assets/avatars/$avatar'),
                          backgroundColor: Colors.transparent,
                        ),
                        SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tag,
                              style: TextStyle(fontSize: 20),
                            ),
                            Text(
                              username,
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          Text(
            'Waiting for host to launch the game...',
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }
}