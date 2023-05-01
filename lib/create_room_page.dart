import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_p2p_minigames/network/EventType.dart';
import 'package:flutter_p2p_minigames/network/PeerToPeer.dart';
import 'package:flutter_p2p_minigames/utils/GameParty.dart';
import 'package:flutter_p2p_minigames/utils/PlayerInfo.dart';
import 'package:flutter_p2p_minigames/utils/Storage.dart';
import 'package:flutter_p2p_plus/protos/protos.pb.dart';
import 'package:go_router/go_router.dart';

import 'main.dart';
import 'network/EventData.dart';

class CreateRoomPage extends StatefulWidget {
  const CreateRoomPage({Key? key}) : super(key: key);

  @override
  _CreateRoomPageState createState() => _CreateRoomPageState();
}

class _CreateRoomPageState extends State<CreateRoomPage> {
  List<PlayerInfo> playerList = [];
  PeerToPeer peerToPeer = PeerToPeer();
  List<WifiP2pDevice> devices = [];

  @override
  void initState() {
    super.initState();
    addPlayerInfo();
    peerToPeer.addP2PPeersChangeListener((peers) {
      setState(() {
        devices = peers;
      });
    });
    peerToPeer.addOnServerConnectedEventListener(() {
      GameParty().connection!.addServerMessageListener((message) {
        log("Received message: $message");
        if(message.type == EventType.PLAYER_JOINED.text){
          PlayerInfo newPlayer = PlayerInfo.fromJson(jsonDecode(message.data));
          setState(() {
            playerList.add(newPlayer);
          });
          GameParty().connection!.sendMessageToClient(jsonEncode(EventData(EventType.PLAYER_JOINED.text, jsonEncode(playerList[0]))));
        }
      });
    });
    peerToPeer.startDiscovery();
  }

  void addPlayerInfo() async {
    PlayerInfo player = await Storage().getPlayerInfo();
    setState(() {
      playerList.add(player);
    });
  }

  void startGame() {
    if(playerList.length > 1){
      GameParty().connection!.sendMessageToClient(jsonEncode(EventData(EventType.START_GAME.text, "gogo")));
      GameParty().startGame(playerList);
      BuildContext? ctx = MyApp.router.routerDelegate.navigatorKey.currentContext;
      ctx!.go("/hub");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Room hub'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 16),
          Text(
            'Player list:',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
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
                          backgroundImage:
                          AssetImage('assets/avatars/$avatar'),
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
          SizedBox(height: 16),
          Text(
            'Available Player Devices:',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    children: devices.map((d) {
                      return ListTile(
                        title: Text(d.deviceName),
                        subtitle: Text(d.deviceAddress),
                        onTap: () async {
                          if(playerList.length > 1) return;
                          PeerToPeer().connect(d).then((value) {
                            if(value){
                              setState(() {
                                devices.remove(d);
                              });
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    PeerToPeer().startDiscovery();
                  },
                  child: Text('Refresh'),
                ),
                SizedBox(height: 16),
              ],
            ),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              startGame();
            },
            child: Text('Start game'),
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }
}