import 'package:flutter/material.dart';

class TrainingPage extends StatefulWidget {
  const TrainingPage({super.key});

  @override
  State<StatefulWidget> createState() => _TrainingPage();
}

class _TrainingPage extends State<TrainingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Training Hub"),
      ),
      body: Center(
        child: CustomScrollView(
          primary: false,
          slivers: <Widget>[
            SliverPadding(
              padding: const EdgeInsets.all(20),
              sliver: SliverGrid.count(
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                crossAxisCount: 2,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(8),
                    color: Colors.green[100],
                    child: ElevatedButton(
                      onPressed: () {},
                      child: const Text('Face Guess'),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    color: Colors.green[200],
                    child: ElevatedButton(
                      onPressed: () {},
                      child: const Text('Speed run'),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    color: Colors.green[300],
                    child: ElevatedButton(
                      onPressed: () {},
                      child: const Text('Jungle Jump'),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    color: Colors.green[400],
                    child: ElevatedButton(
                      onPressed: () {},
                      child: const Text('Capy-Quiz'),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    color: Colors.green[500],
                    child: ElevatedButton(
                      onPressed: () {},
                      child: const Text('Choose the good side'),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    color: Colors.green[600],
                    child: ElevatedButton(
                      onPressed: () {},
                      child: const Text('Mael #1'),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    color: Colors.green[600],
                    child: ElevatedButton(
                      onPressed: () {},
                      child: const Text('Mael #2'),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    color: Colors.green[600],
                    child: ElevatedButton(
                      onPressed: () {},
                      child: const Text('Mael #3'),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    color: Colors.green[600],
                    child: ElevatedButton(
                      onPressed: () {},
                      child: const Text('Mael #4'),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    color: Colors.green[600],
                    child: ElevatedButton(
                      onPressed: () {},
                      child: const Text('Mael #5'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      )// This trailing comma makes auto-formatting nicer for build methods.
    );
  }

}