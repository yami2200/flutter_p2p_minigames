// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_p2p_minigames/network/PeerToPeer.dart';
import 'package:flutter_p2p_plus/flutter_p2p_plus.dart';
import 'package:go_router/go_router.dart';

import 'utils/Storage.dart';

class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({super.key});

  @override
  State<StatefulWidget> createState() => _MainMenuScreenState();

  /// Prevents the game from showing game-services-related menu items
  /// until we're sure the player is signed in.
  ///
  /// This normally happens immediately after game start, so players will not
  /// see any flash. The exception is folks who decline to use Game Center
  /// or Google Play Game Services, or who haven't yet set it up.
  Widget _hideUntilReady({required Widget child, required Future<bool> ready}) {
    return FutureBuilder<bool>(
      future: ready,
      builder: (context, snapshot) {
        // Use Visibility here so that we have the space for the buttons
        // ready.
        return Visibility(
          visible: snapshot.data ?? false,
          maintainState: true,
          maintainSize: true,
          maintainAnimation: true,
          child: child,
        );
      },
    );
  }

  static const _gap = SizedBox(height: 10);
}

class _MainMenuScreenState extends State<MainMenuScreen> with WidgetsBindingObserver {

  Future<String?> _username = Storage().getUsername();
  Future<String?> _avatar = Storage().getAvatar();

  @override
  void initState() {
    super.initState();
    PeerToPeer peerToPeer = PeerToPeer();
    peerToPeer.checkPermission().then((value) {
      log("Location permission granted? : $value");
      if (!value) {
        showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: Text('Location Permission Required'),
            content: Text('Please grant location permission to use this app.'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                  SystemNavigator.pop();
                },
              ),
            ],
          ),
        );
      } else {
        WidgetsBinding.instance.addObserver(this);
        peerToPeer.register();
      }
    });

    Storage storage = Storage();
    storage.getUsername().then((value) {
      if (value == null) {
        GoRouter.of(context).push('/login');
      }
    });
    _refreshUserData();
  }

  @override
  void dispose() {
    log("dispose called");
    WidgetsBinding.instance.removeObserver(this);
    PeerToPeer().unregister();
    PeerToPeer().disconnect();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    PeerToPeer peerToPeer = PeerToPeer();

    if (state == AppLifecycleState.resumed) {
      peerToPeer.register();
    } else if (state == AppLifecycleState.paused) {
      peerToPeer.unregister();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _refreshUserData();
  }

  Future<void> _refreshUserData() async {
    final storage = Storage();
    _username = storage.getUsername();
    _avatar = storage.getAvatar();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Festival Frenzy"),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () => GoRouter.of(context).push('/login'),
          ),
        ],
      ),
      body: Center(
        child:Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 20),
          FutureBuilder<String?>(
            future: _avatar,
            builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
              if (snapshot.hasData) {
                return Column(
                  children: [
                    CircleAvatar(
                      backgroundImage: AssetImage("assets/avatars/"+snapshot.data!),
                      radius: 50,
                    ),
                    SizedBox(height: 10),
                    FutureBuilder<String?>(
                      future: _username,
                      builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
                        if (snapshot.hasData) {
                          return Text(snapshot.data!);
                        } else {
                          return CircularProgressIndicator();
                        }
                      },
                    ),
                  ],
                );
              } else {
                return CircularProgressIndicator();
              }
            },
          ),
          SizedBox(height: 50),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => GoRouter.of(context).push('/create'),
                  child: Text("Create Room"),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () => GoRouter.of(context).push('/join'),
                  child: Text("Join Room"),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () => GoRouter.of(context).push('/training'),
                  child: Text("Camp Training"),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () => GoRouter.of(context).push('/p2pexample'),
                  child: Text("Test p2p"),
                ),
              ],
            ),
          ),
          SizedBox(height: 50),
          ElevatedButton(
            onPressed: () => GoRouter.of(context).push('/credits'),
            child: Text("Credits"),
          ),
        ],
      ),
      ),
    );
  }
}