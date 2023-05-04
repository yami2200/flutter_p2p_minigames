import 'package:flutter/material.dart';

import '../../widgets/FancyButton.dart';
import '../../widgets/GamePage.dart';

class QuizPage extends GamePage {

  const QuizPage({Key? key, required bool training})
      : super(bannerColor: const Color.fromRGBO(154, 216, 224, 0.8),
      training: training,
      background: "assets/ui/background_capyquiz.jpg");

  @override
  GamePageState createState() => _QuizPageState();
}

class _QuizPageState extends GamePageState {
  int _currentIndex = 0;
  bool _showAnswer = false;
  final List<Map<String, dynamic>> _total_questions = [
    {
      'question': 'What is the scientific name for capybaras?',
      'choices': ['Hydrochoerus hydrochaeris', 'Cricetinae', 'Octodon degus', 'Chinchilla lanigera'],
      'answer': 'Hydrochoerus hydrochaeris',
    },
    {
      'question': 'What continent are capybaras native to?',
      'choices': ['South America', 'Africa', 'North America', 'Australia'],
      'answer': 'South America',
    },
    {
      'question': 'What is the average weight of a capybara?',
      'choices': ['10-15 kg', '15-30 kg', '40-60 kg', '60-80 kg'],
      'answer': '40-60 kg',
    },
    {
      'question': 'What is a group of capybaras called?',
      'choices': ['A herd', 'A flock', 'A swarm', 'A pack'],
      'answer': 'A herd',
    },
    {
      'question': 'What do capybaras eat?',
      'choices': ['Meat', 'Plants', 'Fish', 'Insects'],
      'answer': 'Plants',
    },
    {
      'question': 'What is the gestation period of a capybara?',
      'choices': ['50-70 days', '100-120 days', '130-150 days', '150-180 days'],
      'answer': '130-150 days',
    },
    {
      'question': 'What is the lifespan of a capybara in the wild?',
      'choices': ['10-12 years', '12-14 years', '14-16 years', '16-18 years'],
      'answer': '10-12 years',
    },
    {
      'question': 'What is the scientific name for the family that capybaras belong to?',
      'choices': ['Caviidae', 'Hippopotamidae', 'Suidae', 'Bovidae'],
      'answer': 'Caviidae',
    },
    {
      'question': 'What is the average length of a capybara?',
      'choices': ['70-80 cm', '80-100 cm', '100-130 cm', '120-150 cm'],
      'answer': '100-130 cm',
    },
    {
      'question': 'What is the main predator of capybaras?',
      'choices': ['Jaguars', 'Caimans', 'Eagles', 'Snakes'],
      'answer': 'Caimans',
    },
    {
      'question': 'What is the main habitat of capybaras?',
      'choices': ['Forests', 'Deserts', 'Swamp & Rivers', 'Mountains'],
      'answer': 'Swamp & Rivers',
    },
    {
      'question': 'What is the peak mating season for capybaras?',
      'choices': ['Spring', 'Summer', 'Fall', 'Winter'],
      'answer': 'Spring',
    },
    {
      'question': 'What sound do capybaras commonly make?',
      'choices': ['Roar', 'Hiss', 'Squeak', 'Howl'],
      'answer': 'Squeak',
    },
    {
      'question': 'What type of animal are capybaras classified as?',
      'choices': ['Rodents', 'Primates', 'Carnivores', 'Reptiles'],
      'answer': 'Rodents',
    }
  ];
  List<Map<String, dynamic>> _questions = [];

  @override
  void initState() {
    super.initState();
    _total_questions.shuffle();
    _questions = _total_questions.sublist(0, 5);
  }

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
  List<StatelessWidget> buildWidget(BuildContext context) {
    final currentQuestion = _questions[_currentIndex];
    return [
          const Spacer(),
          Card(
            color: const Color.fromRGBO(117, 197, 164, 0.6),
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Question ${_currentIndex + 1} of ${_questions.length}',
                    style: const TextStyle(
                        fontSize: 30,
                        fontFamily: "SuperBubble",
                        color: Colors.black
                    ),
                  ),
                  const SizedBox(height: 25),
                  Text(
                    currentQuestion['question'],
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 20,
                        fontFamily: "SuperBubble",
                        color: Colors.black
                    ),
                  ),
                  const SizedBox(height: 25),
                  if (!_showAnswer)
                    ...currentQuestion['choices']
                        .map((choice) =>
                        FancyButton(
                            size: 25,
                            color: const Color(0xFA18912F),
                            onPressed: () {
                              final bool correct =
                                  choice == currentQuestion['answer'];
                              _showResult(correct);
                            },
                            child: Text(
                              "$choice",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                fontFamily: 'SuperBubble',
                              ),
                            )
                        )
                    ).toList(),
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
          ),
          const Spacer(),
        ];
  }

  /*@override
  Widget build(BuildContext context) {
    final currentQuestion = _questions[_currentIndex];
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/ui/background_capyquiz.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child:Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TwoPlayerInfo(
              player2: widget.training ? null : null,
              player1Text: "Question 1\nScore: 0/5",
              player2Text: widget.training ? null : "0/5",
              cardColor: const Color.fromRGBO(154, 216, 224, 0.8),
            ),
          ),
          const Spacer(),
          Card(
              color: const Color.fromRGBO(117, 197, 164, 0.6),
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Question ${_currentIndex + 1} of ${_questions.length}',
                      style: const TextStyle(
                          fontSize: 30,
                          fontFamily: "SuperBubble",
                          color: Colors.black
                      ),
                    ),
                    const SizedBox(height: 25),
                    Text(
                      currentQuestion['question'],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 20,
                          fontFamily: "SuperBubble",
                          color: Colors.black
                      ),
                    ),
                    const SizedBox(height: 25),
                    if (!_showAnswer)
                      ...currentQuestion['choices']
                          .map((choice) =>
                          FancyButton(
                              size: 25,
                              color: const Color(0xFA18912F),
                              onPressed: () {
                                final bool correct =
                                    choice == currentQuestion['answer'];
                                _showResult(correct);
                              },
                              child: Text(
                                "$choice",
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 25,
                                  fontFamily: 'SuperBubble',
                                ),
                              )
                          )
                      ).toList(),
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
          ),
          const Spacer(),
        ],
      ),
      ),
    );
  }*/
}