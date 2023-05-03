import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_p2p_minigames/widgets/FancyButton.dart';
import 'package:url_launcher/url_launcher.dart';

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

  Future<void> _launchUrlGithub() async {
    if (!await launchUrl(Uri.parse("https://github.com/yami2200/flutter_p2p_minigames"))) {
      throw Exception('Could not launch Github');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
      backgroundColor: const Color.fromRGBO(17, 0, 52, 1.0),
      title: const Text('Credits',
        style: TextStyle(
          color: Colors.white,
          fontFamily: 'SuperBubble',
        ),),
    ),
    body: SafeArea(
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/ui/background_credits.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              ListView(
                shrinkWrap: true,
                children: [
                  Text(
                    _creditsText,
                    style: const TextStyle(
                        fontSize: 18.0,
                        color: Colors.white,
                        fontFamily: 'SuperBubble'
                    ),
                  ),
                ],
              ),
              const Spacer(),
              FancyButton(
                  size: 30,
                  color: Color(0xFF1068D3),
                  onPressed: () {
                    _launchUrlGithub();
                  },
                  child: const Text(
                    "Github Page",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontFamily: 'SuperBubble',
                    ),
                  )
              ),
            ]
          ),
        ),
      ),
    ),
  );
  }
}