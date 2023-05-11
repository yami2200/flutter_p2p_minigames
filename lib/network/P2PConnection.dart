import 'dart:convert';
import 'dart:developer';

import 'package:flutter_p2p_plus/flutter_p2p_plus.dart';
import 'Connection.dart';
import 'EventData.dart';

class P2PConnection implements Connection {
  @override
  bool isHost = false;
  @override
  List<Function(EventData message)> listeners = [];
  var socket;
  bool isOpen = false;


  @override
  void addServerMessageListener(Function(EventData message) listener) {
    if(isHost) listeners.add(listener);
  }

  @override
  void addClientMessageListener(Function(EventData p1) listener) {
    if(!isHost) listeners.add(listener);
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
      String separatedMessage = msg.replaceAll("}{", "}||{");
      List<String> jsonObjects = separatedMessage.split("||");
      jsonObjects.forEach((element) {
        try {
          EventData eventData = EventData.fromJson(jsonDecode(element));
          listeners.forEach((listener) => listener(eventData));
        } catch (e) {
          log("Error: $e");
        }
      });
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
        String separatedMessage = buffer.replaceAll("}{", "}||{");
        List<String> jsonObjects = separatedMessage.split("||");
        jsonObjects.forEach((element) {
          try {
            EventData eventData = EventData.fromJson(jsonDecode(element));
            listeners.forEach((listener) => listener(eventData));
          } catch (e) {
            log("Error: $e");
          }
        });
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
      log("Sending message to client: $message");
      socket?.writeString(message);
    }
  }

  @override
  void sendMessageToServer(String message) {
    if(!isHost){
      log("Sending message to server: $message");
      socket?.writeString(message);
    }
  }

  @override
  void clearMessageListener() {
    listeners.clear();
  }

  @override
  void close() {
    log("Close socket connection");
    if(isHost) FlutterP2pPlus.closeHostPort(8000);
    else FlutterP2pPlus.disconnectFromHost(8000);
    isOpen = false;
    isHost = false;
  }
  
}