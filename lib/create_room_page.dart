import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_p2p_minigames/network/EventType.dart';
import 'package:flutter_p2p_minigames/network/PeerToPeer.dart';
import 'package:flutter_p2p_minigames/utils/GameParty.dart';
import 'package:flutter_p2p_minigames/utils/PlayerInfo.dart';
import 'package:flutter_p2p_minigames/utils/Storage.dart';
import 'package:flutter_p2p_minigames/widgets/FancyButton.dart';
import 'package:flutter_p2p_minigames/widgets/PlayerInfoRow.dart';
import 'package:flutter_p2p_plus/protos/protos.pb.dart';
import 'package:go_router/go_router.dart';

import 'main.dart';
import 'network/EventData.dart';
import 'network/WebSocketConnection.dart';

class CreateRoomPage extends StatefulWidget {
  final bool isDev;

  const CreateRoomPage({Key? key, required this.isDev}) : super(key: key);

  @override
  _CreateRoomPageState createState() => _CreateRoomPageState();
}

class _CreateRoomPageState extends State<CreateRoomPage> {
  ScrollController _scrollController = ScrollController();
  PeerToPeer peerToPeer = PeerToPeer();
  List<WifiP2pDevice> devices = [];

  final Future<PlayerInfo> _playerInfo = Storage().getPlayerInfo();
  final Completer<PlayerInfo> _myOpponentCompleter = Completer<PlayerInfo>();
  Future<PlayerInfo> get _opponentInfo => _myOpponentCompleter.future;

  @override
  void initState() {
    super.initState();
    if(widget.isDev){
      GameParty().setConnection(WebSocketConnection.createServer());
      GameParty().connection!.addServerMessageListener(serverMessageHandler);
      return;
    }
    peerToPeer.addP2PPeersChangeListener((peers) {
      setState(() {
        devices = peers;
      });
    });
    peerToPeer.addOnServerConnectedEventListener(() {
      GameParty().connection!.addServerMessageListener(serverMessageHandler);
    });
    peerToPeer.startDiscovery();
  }

  void serverMessageHandler(EventData message){
    if(message.type == EventType.PLAYER_JOINED.text){
      PlayerInfo newPlayer = PlayerInfo.fromJson(jsonDecode(message.data));
      _myOpponentCompleter.complete(newPlayer);
      _playerInfo.then((value) {
        GameParty().connection!.sendMessageToClient(jsonEncode(EventData(EventType.PLAYER_JOINED.text, jsonEncode(value))));
      });
    } else if(message.type == EventType.READY.text){
      openHub();
    }
  }

  void startGame() async{
    if(_myOpponentCompleter.isCompleted){
      GameParty().connection!.sendMessageToClient(jsonEncode(EventData(EventType.START_GAME.text, "gogo")));
      final futures = [
        _playerInfo,
        _opponentInfo,
      ];
      final results = await Future.wait(futures);
      List<PlayerInfo> playerList = results;
      GameParty().startGame(playerList);
    }
  }

  void openHub() {
    BuildContext? ctx = MyApp.router.routerDelegate.navigatorKey.currentContext;
    ctx!.go("/hub");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Room hub',
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
            Card(
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
            const SizedBox(height: 16),
            Card(
              color: const Color.fromRGBO(254, 223, 176, 0.8),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child:Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Available Device :',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'SuperBubble',
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 200, // set a fixed height for the list
                      child: Scrollbar(
                        controller: _scrollController,
                        thumbVisibility: true,
                        child:ListView.builder(
                          controller: _scrollController,
                          itemCount: devices.length, // replace with actual count of devices
                          itemBuilder: (BuildContext context, int index) {
                          final device = devices[index];
                          return Padding(
                              padding: const EdgeInsets.fromLTRB(0.0, 8.0, 14.0, 8.0),
                              child:Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      device.deviceName, // replace with actual device name
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontFamily: 'SuperBubble'
                                      ),
                                    ),
                                  ),
                                  FancyButton(
                                      size: 16,
                                      color: const Color(0xFF914712),
                                      onPressed: () {
                                        if(_myOpponentCompleter.isCompleted) return;
                                        PeerToPeer().connect(device);
                                      },
                                      child: const Text(
                                        "Connect",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 25,
                                          fontFamily: 'SuperBubble',
                                        ),
                                      )
                                  ),
                                ],
                              ),
                          );
                        },
                      ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    FancyButton(
                        size: 16,
                        color: const Color(0xFF914712),
                        onPressed: () {
                          PeerToPeer().startDiscovery();
                        },
                        child: const Text(
                          "Discover",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontFamily: 'SuperBubble',
                          ),
                        )
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            FancyButton(
                size: 25,
                color: const Color(0xFF914712),
                onPressed: () {
                  startGame();
                },
                child: const Text(
                  "Start game",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontFamily: 'SuperBubble',
                  ),
                )
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
      ),
    );

    /*Expanded(
                      child: Column(
                        children: [
                          Expanded(
                            child: ListView(
                              children: devices.map((d) {
                                return ListTile(
                                  title: Text(d.deviceName),
                                  subtitle: Text(d.deviceAddress),
                                  onTap: () async {
                                    if(_myOpponentCompleter.isCompleted) return;
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
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              PeerToPeer().startDiscovery();
                            },
                            child: const Text('Refresh'),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),*/

  }
}