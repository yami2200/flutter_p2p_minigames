import "dart:math";

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
  final int timeBetweenGames = 20;
  Map<String, GameInfo> gameList = {};
  Set<String> playedGames = {};
  int gamesPlayed = 0;

  Connection? get connection => _connection;

  GameParty._internal() {
    //gameList.putIfAbsent("CapyQuiz", () => GameInfo("CapyQuiz", "Participate to a quiz about Capybaras. Be the first with the most good answers.", "/quiz/c"));
    gameList.putIfAbsent("FaceGuess", () => GameInfo("FaceGuess", "Remember the face on the screen. Try to recreate it before your opponent !", "/faceguess/c"));
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

  void startGame(List<PlayerInfo> players) async{
    player = await Storage().getPlayerInfo();
    playerList = players.map((p) => PlayerInGame(p, 0)).toList();
    opponent = playerList.firstWhere((p) => p.playerInfo.username != player!.username || p.playerInfo.avatar != player!.avatar).playerInfo;
    gameStarted = true;
    playedGames = {};
    gamesPlayed = 0;
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

}