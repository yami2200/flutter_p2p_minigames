import 'package:flutter/material.dart';
import 'package:flutter_p2p_minigames/create_room_page.dart';
import 'package:flutter_p2p_minigames/join_room_page.dart';
import 'package:flutter_p2p_minigames/credit_page.dart';
import 'package:flutter_p2p_minigames/login_page.dart';
import 'package:flutter_p2p_minigames/p2p_example.dart';
import 'package:flutter_p2p_minigames/room_page.dart';
import 'package:flutter_p2p_minigames/training_page.dart';
import 'package:go_router/go_router.dart';

import 'games/safe_landing/game.dart';
import 'main_menu_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  static final _router = GoRouter(
    routes: [
      GoRoute(
          path: '/',
          builder: (context, state) =>
          const MainMenuScreen(key: Key('main menu')),
          routes: [
            GoRoute(
                path: 'training',
                builder: (context, state) =>
                const TrainingPage(key: Key('training page'))),
            GoRoute(
                path: 'safe_landing',
                builder: (context, state) =>
                    SafeLandingsGameWidget()),
            GoRoute(
                path: 'login',
                builder: (context, state) =>
                const LoginPage(key: Key('login page'))),
            GoRoute(
                path: 'credits',
                builder: (context, state) =>
                    CreditsPage()),
            GoRoute(
                path: 'join',
                builder: (context, state) =>
                    JoinRoomPage()),
            GoRoute(
                path: 'create',
                builder: (context, state) =>
                    CreateRoomPage()),
            GoRoute(
                path: 'p2pexample',
                builder: (context, state) =>
                    P2PExample()),
            GoRoute(
                path: 'room',
                builder: (context, state) =>
                    RoomPage()),
          ],
      ),
    ],
  );

  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      routeInformationProvider: _router.routeInformationProvider,
      routeInformationParser: _router.routeInformationParser,
      routerDelegate: _router.routerDelegate,
    );
  }
}