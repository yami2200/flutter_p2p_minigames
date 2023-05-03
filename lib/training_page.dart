import 'package:flutter/material.dart';
import 'package:flutter_p2p_minigames/widgets/FancyButton.dart';
import 'package:go_router/go_router.dart';

class TrainingPage extends StatefulWidget {
  const TrainingPage({super.key});

  @override
  State<StatefulWidget> createState() => _TrainingPage();
}

class _TrainingPage extends State<TrainingPage> {
  final List<Map<String, String>> buttons = [
    {"text": "Face Guess", "path": ""},
    {"text": "Speed run", "path": ""},
    {"text": "Jungle Jump", "path": ""},
    {"text": "Capy-Quiz", "path": "/quiz/training"},
    {"text": "Choose the good side", "path": ""},
    {"text": "Mael #1", "path": ""},
    {"text": "Mael #2", "path": ""},
    {"text": "Mael #3", "path": ""},
    {"text": "Mael #4", "path": ""},
    {"text": "safe_landing", "path": "/safe_landing"}
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(13, 2, 71, 1.0),
        title: const Text("Training Hub"),
      ),
      body: Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
        image: AssetImage('assets/ui/background_menu.jpg'),
        fit: BoxFit.cover,
        ),
      ),
      child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),
                ...buttons.map(
                      (button) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: FancyButton(
                      size: 30,
                      color: const Color(0xFFCA3034),
                      onPressed: () => GoRouter.of(context).push(button['path']!),
                      child: Text(
                        button['text']!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontFamily: 'SuperBubble',
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}