import 'package:flutter/material.dart';

import '../utils/PlayerInfo.dart';

class PlayerScoresRow extends StatelessWidget {
  final PlayerInfo playerInfo;
  final int score;

  const PlayerScoresRow({required this.playerInfo, required this.score});

  @override
  Widget build(BuildContext context) {
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
        Expanded(
          child: Text(
            playerInfo.username,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: "SuperBubble",
              fontSize: 15,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Text(
          '$score pts',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: "SuperBubble",
            fontSize: 15,
          ),
        ),
      ],
    );
  }
}