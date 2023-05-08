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
    {"text": "Face Guess", "path": "/faceguess/training"},
    {"text": "Train Tally", "path": "/traintally/training"},
    {"text": "Capy-Quiz", "path": "/quiz/training"},
    {"text": "Choose the good side", "path": "/choosegoodside/training"},
    {"text": "Eat That Cheese", "path": "/eat_that_cheese/training"},
    {"text": "Fruits Slash", "path": "/fruits_slash/training"},
    {"text": "Safe Landing", "path": "/safe_landing/training"},
    {"text": "Arrow Swiping", "path": "/arrow_swiping/training"},

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(13, 2, 71, 1.0),
        title: const Text("Training Hub",
          style: TextStyle(
            fontFamily: 'SuperBubble',
          ),),
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