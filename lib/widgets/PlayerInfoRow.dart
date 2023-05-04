import 'package:flutter/material.dart';

import '../utils/PlayerInfo.dart';

class PlayerInfoRow extends StatelessWidget {
  final Future<PlayerInfo> _playerInfo;

  const PlayerInfoRow({Key? key, required Future<PlayerInfo> playerInfo})
      : _playerInfo = playerInfo,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PlayerInfo>(
      future: _playerInfo,
      builder: (BuildContext context, AsyncSnapshot<PlayerInfo> snapshot) {
        if (snapshot.hasData) {
          final playerInfo = snapshot.data!;
          return Row(
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
                  color: const Color.fromRGBO(68, 71, 50, 1.0),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  playerInfo.tag.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: "SuperBubble",
                    fontSize: 17,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                playerInfo.username,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: "SuperBubble",
                  fontSize: 15,
                ),
              ),
            ],
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