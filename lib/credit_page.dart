import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class CreditsPage extends StatefulWidget {
  @override
  _CreditsPageState createState() => _CreditsPageState();
}

class _CreditsPageState extends State<CreditsPage> {
  String _creditsText = '';

  @override
  void initState() {
    super.initState();
    _loadCreditsText();
  }

  Future<void> _loadCreditsText() async {
    final creditsText =
    await rootBundle.loadString('assets/credits.txt');
    setState(() {
      _creditsText = creditsText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Credits'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Text(
          _creditsText,
          style: TextStyle(fontSize: 18.0),
        ),
      ),
    );
  }
}