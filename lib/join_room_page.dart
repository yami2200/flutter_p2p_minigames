import 'package:flutter/material.dart';
import 'package:flutter_p2p_minigames/network/PeerToPeer.dart';
import 'package:go_router/go_router.dart';

class JoinRoomPage extends StatefulWidget {
  const JoinRoomPage({Key? key}) : super(key: key);

  @override
  _JoinRoomPageState createState() => _JoinRoomPageState();
}

class _JoinRoomPageState extends State<JoinRoomPage> {
  List<String> buttonLabels = [];
  bool isConnected = false;

  @override
  void initState() {
    super.initState();
    refreshDevices();
    PeerToPeer().addP2PPeersChangeListener((peers) {
      setState(() {
        buttonLabels = peers.map((e) => e.deviceName).toList();
      });
    });
    PeerToPeer().addP2PConnectionListener((change) => setState(() {
      isConnected = change.networkInfo.isConnected;
    }));
  }

  void refreshDevices(){
    PeerToPeer().startDiscovery();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Join a Room'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(top: 25.0),
                      child: isConnected ? ElevatedButton(
                        onPressed: () {
                          PeerToPeer().clearP2PConnectionListener();
                          PeerToPeer().clearP2PPeersChangeListener();
                          GoRouter.of(context).go('/room');
                        },
                        child: Text('Join the game'),
                      ) : Text('Waiting for invites...',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),),
                    ),
                  ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                refreshDevices();
              },
              child: Text('Refresh'),
            ),
            SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }
}