import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_p2p_minigames/create_room_page.dart';
import 'package:flutter_p2p_minigames/games/arrow_swiping/game.dart';
import 'package:flutter_p2p_minigames/games/choose_good_side/choose_good_side.dart';
import 'package:flutter_p2p_minigames/games/eat_that_cheese/game.dart';
import 'package:flutter_p2p_minigames/games/face_guess/face_guess.dart';
import 'package:flutter_p2p_minigames/games/fruits_slash/game.dart';
import 'package:flutter_p2p_minigames/games/quiz/QuizPage.dart';
import 'package:flutter_p2p_minigames/games/train_tally/train_tally.dart';
import 'package:flutter_p2p_minigames/join_room_page.dart';
import 'package:flutter_p2p_minigames/credit_page.dart';
import 'package:flutter_p2p_minigames/login_page.dart';
import 'package:flutter_p2p_minigames/p2p_example.dart';
import 'package:flutter_p2p_minigames/party_hub.dart';
import 'package:flutter_p2p_minigames/room_page.dart';
import 'package:flutter_p2p_minigames/training_page.dart';
import 'package:flutter_p2p_minigames/widgets/FlameGamePage.dart';
import 'package:go_router/go_router.dart';

import 'games/safe_landing/game.dart';
import 'main_menu_screen.dart';
import 'network/PeerToPeer.dart';

void main() {
  runApp(MyApp());
}

final keyFlameGamePage = GlobalKey<FlameGamePageState>();

class MyApp extends StatefulWidget {
  static final router = GoRouter(
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
              path: 'safe_landing/:mode',
              builder: (context, state) =>
                  SafeLandingsGameWidget(key: keyFlameGamePage, training: state.params['mode'] == 'training')),
          GoRoute(
              path: 'fruits_slash/:mode',
              builder: (context, state) =>
                  FruitsSlashPage(key: keyFlameGamePage, training: state.params['mode'] == 'training')),
          GoRoute(
              path: 'arrow_swiping/:mode',
              builder: (context, state) =>
                  ArrowSwipingPage(key: keyFlameGamePage, training: state.params['mode'] == 'training')),
          GoRoute(
              path: 'eat_that_cheese/:mode',
              builder: (context, state) =>
                  EatThatCheesePage(key: keyFlameGamePage, training: state.params['mode'] == 'training')),
          GoRoute(
              path: 'login',
              builder: (context, state) =>
              const LoginPage(key: Key('login page'))),
          GoRoute(
              path: 'credits',
              builder: (context, state) =>
                  CreditsPage()),
          GoRoute(
              path: 'p2pexample',
              builder: (context, state) =>
                  P2PExample()),
          GoRoute(
              path: 'room',
              builder: (context, state) =>
                  RoomPage()),
          GoRoute(
              path: 'hub',
              builder: (context, state) =>
                  GameHubPage()),
          GoRoute(
              path: 'join/:opt',
              builder: (context, state) =>
                  JoinRoomPage(isDev: state.params['opt'] == 'dev')),
          GoRoute(
              path: 'create/:opt',
              builder: (context, state) =>
                  CreateRoomPage(isDev: state.params['opt'] == 'dev')),
          GoRoute(
              path: 'quiz/:mode',
              builder: (context, state) =>
                  QuizPage(training: state.params['mode'] == 'training')),
          GoRoute(
              path: 'faceguess/:mode',
              builder: (context, state) =>
                  FaceGuessPage(key: keyFlameGamePage, training: state.params['mode'] == 'training')),
          GoRoute(
              path: 'choosegoodside/:mode',
              builder: (context, state) =>
                  ChooseGoodSidePage(key: keyFlameGamePage, training: state.params['mode'] == 'training')),
          GoRoute(
              path: 'traintally/:mode',
              builder: (context, state) =>
                  TrainTallyPage(key: keyFlameGamePage, training: state.params['mode'] == 'training')),
        ],
      ),
    ],
  );

  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
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
        peerToPeer.register();
      }
    });
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
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Festival Frenzy',
      routeInformationProvider: MyApp.router.routeInformationProvider,
      routeInformationParser: MyApp.router.routeInformationParser,
      routerDelegate: MyApp.router.routerDelegate,
    );
  }
}