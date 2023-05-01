import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_p2p_minigames/utils/GameParty.dart';
import 'package:flutter_p2p_minigames/utils/PlayerInfo.dart';

import '../../widgets/TwoPlayerInfo.dart';

class QuizPage extends StatefulWidget {
  final bool training;

  const QuizPage({Key? key, required this.training}) : super(key: key);

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {

  @override
  void initState() {
    super.initState();
    log("Training Mode : ${widget.training}");
  }

  int _currentIndex = 0;
  bool _showAnswer = false;
  List<Map<String, dynamic>> _questions = [
    {
      'question': 'What is the capital of France?',
      'choices': ['New York', 'London', 'Paris', 'Berlin'],
      'answer': 'Paris',
    },
    {
      'question': 'What is the currency of Japan?',
      'choices': ['Dollar', 'Yen', 'Euro', 'Won'],
      'answer': 'Yen',
    },
    {
      'question': 'What is the largest country in the world?',
      'choices': ['Canada', 'Russia', 'China', 'Australia'],
      'answer': 'Russia',
    },
  ];
  final player1 = PlayerInfo("", "", "avatar1.png");
  final player2 = GameParty().opponent;

  void _showResult(bool correct) {
    setState(() {
      _showAnswer = true;
    });
  }

  void _nextQuestion() {
    setState(() {
      _currentIndex++;
      _showAnswer = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = _questions[_currentIndex];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Page'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          TwoPlayerInfo(
            player2: widget.training ? PlayerInfo("", "", "") : player2!,
            player1Text: "0/5",
            player2Text: widget.training ? "none" : "0/5",
          ),
          const SizedBox(height: 16),
          Text(
            'Question ${_currentIndex + 1} of ${_questions.length}',
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  currentQuestion['question'],
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 16),
                if (!_showAnswer)
                  ...currentQuestion['choices']
                      .map((choice) =>
                      ElevatedButton(
                        onPressed: () {
                          final bool correct =
                              choice == currentQuestion['answer'];
                          _showResult(correct);
                        },
                        child: Text(choice),
                      ))
                      .toList(),
                if (_showAnswer)
                  Text(
                    'Your answer is ${currentQuestion['answer'] ==
                        currentQuestion['choices'][0] ? 'correct' : 'wrong'}',
                    style: const TextStyle(fontSize: 24),
                  ),
                const SizedBox(height: 16),
                if (_showAnswer)
                  ElevatedButton(
                    onPressed: _currentIndex == _questions.length - 1
                        ? () {
                      showDialog(
                        context: context,
                        builder: (context) =>
                            AlertDialog(
                              title: const Text('Quiz finished'),
                              content: const Text('Congratulations!'),
                              actions: [
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  },
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
                      );
                    }
                        : _nextQuestion,
                    child: Text(
                      _currentIndex == _questions.length - 1
                          ? 'Finish'
                          : 'Next',
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}