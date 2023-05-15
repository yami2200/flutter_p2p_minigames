import 'package:flutter/material.dart';
import 'package:flutter_p2p_minigames/widgets/PlayerInGameInfo.dart';

import '../utils/PlayerInfo.dart';
import '../utils/Storage.dart';

class TwoPlayerInfo extends StatelessWidget {
  final String player1Text;
  final Future<PlayerInfo>? player2;
  final String? player2Text;
  final Color? cardColor;

  const TwoPlayerInfo({
    Key? key,
    required this.player1Text,
    this.player2,
    this.player2Text,
    this.cardColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future<PlayerInfo> playerInfo = Storage().getPlayerInfo();

    return Card(
      color: cardColor ?? const Color.fromRGBO(176, 176, 176, 0.8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
              padding: const EdgeInsets.fromLTRB(32.0, 16.0, 32.0, 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  PlayerInGameInfo(playerInfo: playerInfo, playerText: player1Text),
                  player2 != null
                      ? PlayerInGameInfo(playerInfo: player2!, playerText: player2Text!)
                      : const Text("Training",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: "SuperBubble",
                            fontSize: 22,
                          ),
                    ),
                ],
              )
          ),
        ],
      ),
    );
  }
}