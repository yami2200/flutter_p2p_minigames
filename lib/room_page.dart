import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_p2p_minigames/utils/GameParty.dart';
import 'package:flutter_p2p_minigames/utils/PlayerInfo.dart';

import 'network/EventData.dart';
import 'network/EventType.dart';
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
    GameParty().connection!.addMessageListener((message) {
      Map<String, dynamic> event = jsonDecode(message);
      EventData eventMessage = EventData.fromJson(event);
      log("Received message: $message");
      if(eventMessage.type == EventType.PLAYER_JOINED){
        Map<String, dynamic> eventData = jsonDecode(eventMessage.data);
        PlayerInfo newPlayer = PlayerInfo.fromJson(eventData);
        setState(() {
          playerList.add(newPlayer);
        });
      }
    });
    sendPlayerInfoToHost();
  }

  void sendPlayerInfoToHost() async {
    PlayerInfo player = await Storage().getPlayerInfo();
    GameParty().connection!.sendMessageToServer(jsonEncode(EventData(EventType.PLAYER_JOINED, jsonEncode(player))));
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