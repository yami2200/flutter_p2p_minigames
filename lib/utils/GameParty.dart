import 'package:flutter_p2p_minigames/network/P2PConnection.dart';

import '../network/Connection.dart';

class GameParty {

  static final GameParty _instance = GameParty._internal();
  Connection? _connection;

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



}