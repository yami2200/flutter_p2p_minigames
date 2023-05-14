// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
import 'package:flutter/material.dart';
import 'package:flutter_p2p_minigames/utils/Config.dart';
import 'package:flutter_p2p_minigames/utils/SoloChallenge.dart';
import 'package:flutter_p2p_minigames/widgets/FancyButton.dart';
import 'package:go_router/go_router.dart';

import 'network/PeerToPeer.dart';
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

class _MainMenuScreenState extends State<MainMenuScreen> {

  Future<String?> _username = Storage().getUsername();
  Future<String?> _avatar = Storage().getAvatar();

  @override
  void initState() {
    super.initState();
    Storage storage = Storage();
    storage.getUsername().then((value) {
      if (value == null) {
        GoRouter.of(context).push('/login');
      }
    });
    _refreshUserData();
    //refreshP2P();
  }

  void refreshP2P() async {
    await PeerToPeer().disconnect();
    PeerToPeer().register();
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
    bool isDev = Config.devMode;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/ui/background_menu.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              Image.asset(
                'assets/ui/title.png',
                height: 250,
              ),
              const SizedBox(height: 50),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    isDev
                        ? FancyButton(
                        size: 30,
                        color: const Color(0xFFCA3034),
                        onPressed: () => GoRouter.of(context).push('/create/dev'),
                        child: const Text(
                          "Create Room (Dev)",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontFamily: 'SuperBubble',
                          ),
                        )
                    ) : FancyButton(
                        size: 30,
                        color: const Color(0xFFCA3034),
                        onPressed: () => GoRouter.of(context).push('/create/c'),
                        child: const Text(
                          "Create Room",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontFamily: 'SuperBubble',
                          ),
                        )
                    ),
                    const SizedBox(height: 15),
                    isDev
                        ? FancyButton(
                      size: 30,
                      color: const Color(0xFFDE6912),
                        onPressed: () => GoRouter.of(context).push('/join/dev'),
                      child: const Text(
                        "Join Room (Dev)",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontFamily: 'SuperBubble',
                        ),
                      )
                    ) : FancyButton(
                        size: 30,
                        color: const Color(0xFFDE6912),
                        onPressed: () => GoRouter.of(context).push('/join/c'),
                        child: const Text(
                          "Join Room",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontFamily: 'SuperBubble',
                          ),
                        )
                    ),
                    const SizedBox(height: 15),
                    FancyButton(
                        size: 30,
                        color: const Color(0xFF40CC20),
                        onPressed: () => GoRouter.of(context).push('/training'),
                        child: const Text(
                          "Camp Training",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontFamily: 'SuperBubble',
                          ),
                        )
                    ),
                    const SizedBox(height: 15),
                    FancyButton(
                        size: 30,
                        color: const Color(0xFF206BCC),
                        onPressed: () => SoloChallenge.startChallenge(),
                        child: const Text(
                          "Solo Challenge",
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
              const SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FancyButton(
                    size: 25,
                    color: const Color(0xFF2439BE),
                    onPressed: () => GoRouter.of(context).push('/login'),
                    child: const Text(
                      "Edit Profile",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontFamily: 'SuperBubble',
                      ),
                    )
                ),
                FancyButton(
                    size: 25,
                    color: const Color(0xFF2439BE),
                    onPressed: () => GoRouter.of(context).push('/credits'),
                    child: const Text(
                      "Credits",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontFamily: 'SuperBubble',
                      ),
                    )
                ),
              ]
            ),
          ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}