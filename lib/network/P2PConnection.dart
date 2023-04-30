import 'dart:convert';
import 'dart:developer';

import 'package:flutter_p2p_minigames/network/EventData.dart';
import 'package:flutter_p2p_plus/flutter_p2p_plus.dart';

import '../utils/PlayerInfo.dart';
import '../utils/Storage.dart';
import 'EventType.dart';
import 'EventData.dart';
import 'Connection.dart';

class P2PConnection implements Connection {
  @override
  bool isHost = false;
  @override
  List<Function(String p1)> listeners = [];

  var socket;
  bool isOpen = false;


  @override
  void addMessageListener(Function(String p1) listener) {
    listeners.add(listener);
  }

  @override
  P2PConnection.connectToServer(String host){
    isHost = false;
    connectServer(host);
  }

  void connectServer(String host) async{
    socket = await FlutterP2pPlus.connectToHost(host, 8000, timeout: 100000);
    socket?.inputStream.listen((data) {
      var msg = utf8.decode(data.data);
      log("Received from ${isHost ? "Client" : "Host"} $msg");
      listeners.forEach((listener) => listener(msg));
    });
  }

  @override
  P2PConnection.createServer() {
    isHost = true;
    createServerP2P();
  }

  void createServerP2P() async {
    log("Creating Server ...");
    socket = await FlutterP2pPlus.openHostPort(8000);
    var buffer = "";
    log("Starting Listening as Server ...");
    socket?.inputStream.listen((data) {
      var msg = String.fromCharCodes(data.data);
      buffer += msg;
      if (data.dataAvailable == 0) {
        log("Data Received from ${isHost ? "Client" : "Host"}: $buffer");
        listeners.forEach((listener) => listener(buffer));
        buffer = "";
      }
    });
    acceptClients();
  }

  void acceptClients() async {
      isOpen = await FlutterP2pPlus.acceptPort(8000) ?? false;
      if(isOpen){
        log("Client Connected");
      }
  }

  @override
  void sendMessageToClient(String message) {
    if(isHost){
      socket?.writeString(message);
    }
  }

  @override
  void sendMessageToServer(String message) {
    if(!isHost){
      socket?.writeString(message);
    }
  }
  
}