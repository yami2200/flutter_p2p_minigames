import 'package:flutter/material.dart';

import '../utils/PlayerInfo.dart';

class PlayerInGameInfo extends StatelessWidget {
  final Future<PlayerInfo> _playerInfo;
  final String playerText;

  const PlayerInGameInfo({Key? key, required Future<PlayerInfo> playerInfo, required this.playerText})
      : _playerInfo = playerInfo,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PlayerInfo>(
      future: _playerInfo,
      builder: (BuildContext context, AsyncSnapshot<PlayerInfo> snapshot) {
        if (snapshot.hasData) {
          final playerInfo = snapshot.data!;
          return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage("assets/avatars/${playerInfo.avatar}"),
                    backgroundColor: Colors.transparent,
                    radius: 26,
                  ),
                  const SizedBox(width: 10),
                  Container(
                    width: 50,
                    height: 30,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(0, 0, 0, 1.0),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      playerInfo.tag.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: "SuperBubble",
                        fontSize: 17,
                      ),
                    ),
                  ),
                ],
              ),
              Text(
                playerText,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: "SuperBubble",
                  fontSize: 22,
                ),
              ),
              ]
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(const Color.fromRGBO(68, 71, 50, 1.0)),
          );
        }
      },
    );
  }
}