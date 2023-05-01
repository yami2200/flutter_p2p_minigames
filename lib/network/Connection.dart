import 'EventData.dart';

abstract class Connection {

  bool get isHost => _isHost;

  set isHost(bool value) {
    _isHost = value;
  }

  bool _isHost = false;

  List<Function(EventData)> _listeners = [];

  Connection.createServer();

  Connection.connectToServer(String host);

  void addServerMessageListener(Function(EventData) listener);

  void addClientMessageListener(Function(EventData) listener);

  void clearMessageListener();

  void sendMessageToClient(String message);

  void sendMessageToServer(String message);

  void close();
}