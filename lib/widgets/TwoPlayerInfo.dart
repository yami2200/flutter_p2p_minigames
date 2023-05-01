import 'package:flutter/material.dart';

import '../utils/PlayerInfo.dart';
import '../utils/Storage.dart';

class TwoPlayerInfo extends StatelessWidget {
  final String player1Text;
  final PlayerInfo player2;
  final String player2Text;

  const TwoPlayerInfo({
    Key? key,
    required this.player1Text,
    required this.player2,
    required this.player2Text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future<String?> _tag = Storage().getTAG();
    Future<String?> _avatar = Storage().getAvatar();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            FutureBuilder<String?>(
                future: _avatar,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return const Text('???');
                  }
                  final String? avatar = snapshot.data;
                  return CircleAvatar(
                    backgroundImage: AssetImage("assets/avatars/${avatar}"),
                    child: FutureBuilder<String?>(
                        future: _tag,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          }
                          if (snapshot.hasError) {
                            return const Text('???');
                          }
                          final String? tag = snapshot.data;
                          return Text(tag!);
                        }
                    ),
                  );
                }
            ),
            Text(player1Text),
          ],
        ),
        player2Text != "none" ? Column(
          children: [
            CircleAvatar(
              child: Text(player2.tag),
              backgroundImage: AssetImage("assets/avatars/${player2.avatar}"),
            ),
            Text(player2Text),
          ],
        ) : const SizedBox.shrink(),
      ],
    );
  }
}