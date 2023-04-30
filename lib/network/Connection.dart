abstract class Connection {

  bool get isHost => _isHost;

  set isHost(bool value) {
    _isHost = value;
  }

  bool _isHost = false;

  List<Function(String)> _listeners = [];

  Connection.createServer();

  Connection.connectToServer(String host);

  void addMessageListener(Function(String) listener);

  void sendMessageToClient(String message);

  void sendMessageToServer(String message);
}