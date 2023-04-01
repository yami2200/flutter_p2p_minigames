import 'package:flutter/material.dart';
import 'package:flutter_p2p_minigames/training_page.dart';
import 'package:go_router/go_router.dart';

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
          ]),
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