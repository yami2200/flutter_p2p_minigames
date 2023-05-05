import 'dart:convert';
import 'dart:developer';

import 'package:flutter_p2p_minigames/network/Connection.dart';
import 'package:flutter_p2p_minigames/network/EventData.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../utils/Config.dart';

class WebSocketConnection implements Connection {
  @override
  bool isHost = false;
  @override
  List<Function(EventData message)> listeners = [];
  var socket;

  @override
  WebSocketConnection.createServer() {
    log("Create Server ...");
    isHost = true;
    createServerP2P();
  }

  @override
  WebSocketConnection.connectToServer(String host){
    log("Create Client connection ...");
    isHost = false;
    connectServer();
  }

  void createServerP2P() async {
    final channel = WebSocketChannel.connect(Uri.parse(Config.WS_URL));
    socket = channel;
    socket.sink.add("host");
    channel.stream.listen((data) {
      log("WS Connection : received : "+data+" for listeners : "+listeners.length.toString());
      EventData eventData = EventData.fromJson(jsonDecode(data));
      listeners.forEach((listener) => listener(eventData));
      },
      onError: (error) => log(error),
    );
  }

  void connectServer() async {
    final channel = WebSocketChannel.connect(Uri.parse(Config.WS_URL));
    socket = channel;
    socket.sink.add("client");
    channel.stream.listen((data) {
        log("WS Connection : received : "+data+" for listeners : "+listeners.length.toString());
        EventData eventData = EventData.fromJson(jsonDecode(data));
        listeners.forEach((listener) => listener(eventData));
      },
      onError: (error) => log(error),
    );
  }

  @override
  void addClientMessageListener(Function(EventData p1) listener) {
    if(!isHost) {
      log("add listener as client");
      listeners.add(listener);
    }
  }

  @override
  void addServerMessageListener(Function(EventData p1) listener) {
    if(isHost) {
      log("add listener as server");
      listeners.add(listener);
    }
  }

  @override
  void clearMessageListener() {
    log("clear listeners");
    listeners.clear();
  }

  @override
  void close() {
    socket.sink.close();
  }

  @override
  void sendMessageToClient(String message) {
    if(isHost) socket.sink.add("fromHost"+message);
  }

  @override
  void sendMessageToServer(String message) {
    if(!isHost) socket.sink.add("fromClient"+message);
  }

}