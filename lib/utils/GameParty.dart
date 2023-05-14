import "dart:math";

import 'package:flutter_p2p_minigames/utils/Config.dart';

import '../network/Connection.dart';
import 'GameInfo.dart';
import 'PlayerInGame.dart';
import 'PlayerInfo.dart';
import 'Storage.dart';

class GameParty {
  static final GameParty _instance = GameParty._internal();
  Connection? _connection;
  List<PlayerInGame> playerList = [];
  PlayerInfo? player;
  PlayerInfo? opponent;
  final int maxGames = 5;
  bool gameStarted = false;
  final int timeBetweenGames = Config.devMode ? 3 : 10;
  Map<String, GameInfo> gameList = {};
  Set<String> playedGames = {};
  int gamesPlayed = 0;

  Connection? get connection => _connection;

  GameParty._internal() {
    gameList.putIfAbsent("CapyQuiz", () => GameInfo("CapyQuiz", "Participate to a quiz about Capybaras. Be the first with the most good answers.", "/quiz/c"));
    gameList.putIfAbsent("FaceGuess", () => GameInfo("FaceGuess", "Remember the face on the screen. Try to recreate it before your opponent !", "/faceguess/c"));
    gameList.putIfAbsent("Safe Landing", () => GameInfo("Safe Landing", "Try to land when the counter hit 0 seconds.", "/safe_landing/c"));
    gameList.putIfAbsent("Fruits Slash", () => GameInfo("Fruits Slash", "Slash these fruits!", "/fruits_slash/c"));
    gameList.putIfAbsent("Choose the good side", () => GameInfo("Choose the good side", "Choose one side of the platform. Pray to not die before your opponent!", "/choosegoodside/c"));
    gameList.putIfAbsent("Eat That Cheese", () => GameInfo("Eat That Cheese", "Eat all that cheese.", "/eat_that_cheese/c"));
    gameList.putIfAbsent("Train Tally", () => GameInfo("Train Tally", "Count the passengers of the train passing by!", "/traintally/c"));
    gameList.putIfAbsent("Arrow Swiping", () => GameInfo("Arrow Swiping", "Swipe in the direction of the arrow!", "/arrow_swiping/c"));

    loadPlayer();
  }

  void loadPlayer() async {
    player = await Storage().getPlayerInfo();
  }

  factory GameParty() {
    return _instance;
  }

  void setConnection(Connection connection){
    _connection = connection;
  }

  void sendMessageToClient(String message){
    _connection?.sendMessageToClient(message);
  }

  void sendMessageToServer(String message){
    _connection?.sendMessageToServer(message);
  }

  void sendToOpponent(String message){
    if(isServer()){
      sendMessageToClient(message);
    } else {
      sendMessageToServer(message);
    }
  }

  void startGame(List<PlayerInfo> players) async{
    playerList = players.map((p) => PlayerInGame(p, 0)).toList();
    opponent = playerList.firstWhere((p) => p.playerInfo.username != player!.username || p.playerInfo.avatar != player!.avatar).playerInfo;
    gameStarted = true;
    playedGames = {};
    gamesPlayed = 0;
  }

  void stopGame(){
    gameStarted = false;
    _connection = null;

  }

  bool isServer(){
    if(connection == null){
      return true;
    }
    return connection!.isHost;
  }

  GameInfo getNextGame(){
    if(gameList.length == playedGames.length){
      playedGames.clear();
    }
    var available = gameList.keys.where((g) => !playedGames.contains(g)).toList();
    // get random game
    var game = gameList[available[Random().nextInt(available.length)]];
    playedGames.add(game!.name);
    return game;
  }

  void resetFromChallenge(){
    playedGames = {};
  }

}