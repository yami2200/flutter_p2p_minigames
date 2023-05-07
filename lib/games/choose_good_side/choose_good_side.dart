import 'package:flutter/material.dart';

import '../../widgets/FlameGamePage.dart';
import '../../widgets/GamePage.dart';
import 'choose_good_side_instance.dart';

class ChooseGoodSidePage extends FlameGamePage {

  ChooseGoodSidePage({super.key, required bool training})
      : super(bannerColor: const Color.fromRGBO(40, 63, 140, 0.8),
      training: training,
      gameInstance: ChooseGoodSideGameInstance());

  @override
  GamePageState createState() => FlameGamePageState();
}