import 'package:flutter/material.dart';
import 'package:flutter_p2p_minigames/main.dart';
import 'package:flutter_p2p_minigames/network/PeerToPeer.dart';
import 'package:flutter_p2p_minigames/network/WebSocketConnection.dart';
import 'package:flutter_p2p_minigames/utils/GameParty.dart';
import 'package:flutter_p2p_minigames/widgets/FancyButton.dart';
import 'package:go_router/go_router.dart';

class JoinRoomPage extends StatefulWidget {
  final bool isDev;

  const JoinRoomPage({Key? key, required this.isDev}) : super(key: key);

  @override
  _JoinRoomPageState createState() => _JoinRoomPageState();
}

class _JoinRoomPageState extends State<JoinRoomPage> {
  List<String> buttonLabels = [];
  bool isConnected = false;

  @override
  void initState() {
    super.initState();
    if (widget.isDev) {
      GameParty().setConnection(WebSocketConnection.connectToServer(""));
      Future.delayed(const Duration(milliseconds: 2000), () {
        BuildContext? ctx = MyApp.router.routerDelegate.navigatorKey
            .currentContext;
        ctx!.go("/room");
      });
      return;
    }
    refreshDevices();
    PeerToPeer().addP2PConnectionListener((change) =>
        setState(() {
          //isConnected = change.networkInfo.isConnected;
          if (change.networkInfo.isConnected) {
            BuildContext? ctx = MyApp.router.routerDelegate.navigatorKey
                .currentContext;
            ctx!.go("/room");
          }
        }));
  }

  void refreshDevices(){
    PeerToPeer().startDiscovery();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(254, 221, 170, 1.0),
        title: const Text('Join a Room'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
          image: AssetImage('assets/ui/background_join.jpg'),
          fit: BoxFit.cover,
          ),
        ),
        child:Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [const Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(top: 25.0),
                      child: Text('Waiting for invites...',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'SuperBubble',
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
            const SizedBox(height: 16.0),
            FancyButton(
                size: 30,
                color: const Color(0xFF172E93),
                onPressed: () {
                  refreshDevices();
                },
                child: const Text(
                  "Refresh",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontFamily: 'SuperBubble',
                  ),
                )
            ),
            const SizedBox(height: 16.0),
          ],
        ),
      ),
      ),
    );
  }
}