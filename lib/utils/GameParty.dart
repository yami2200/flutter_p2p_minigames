import '../network/Connection.dart';
import 'PlayerInGame.dart';
import 'PlayerInfo.dart';
import 'Storage.dart';

class GameParty {

  static final GameParty _instance = GameParty._internal();
  Connection? _connection;
  List<PlayerInGame> playerList = [];
  PlayerInfo? player;
  List<String> gamesPlayed = [];
  final int maxGames = 5;
  bool gameStarted = false;
  final int timeBetweenGames = 15;

  Connection? get connection => _connection;

  GameParty._internal();

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
    gameStarted = true;
    gamesPlayed = [];
  }



}