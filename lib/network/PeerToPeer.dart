import 'dart:async';
import 'dart:developer';
import 'package:flutter_p2p_minigames/network/P2PConnection.dart';
import 'package:flutter_p2p_minigames/utils/GameParty.dart';
import 'package:flutter_p2p_plus/flutter_p2p_plus.dart';
import 'package:flutter_p2p_plus/protos/protos.pb.dart';
import 'package:permission_handler/permission_handler.dart';

class PeerToPeer {

  static final PeerToPeer _instance = PeerToPeer._internal();
  List<StreamSubscription> _subscriptions = [];
  List<WifiP2pDevice> _peers = [];
  bool isConnected = false;
  bool isHost = false;
  String deviceAdress = "";
  List<Function(ConnectionChange)> connectionListeners = [];
  List<Function(List<WifiP2pDevice>)> peersListeners = [];
  List<Function()> serverConnectedListeners = [];
  List<String> connectedDevices = [];

  List<WifiP2pDevice> get peers => _peers;

  PeerToPeer._internal();

  factory PeerToPeer() {
    return _instance;
  }

  Future<bool> checkPermission() async {
    var status = await Permission.location.status;
    if (status.isGranted) {
      return true;
    } else {
      var result = await Permission.location.request();
      return result.isGranted;
    }
  }

  void addP2PConnectionListener(Function(ConnectionChange) listener){
    connectionListeners.add(listener);
  }

  void clearP2PConnectionListener(){
    connectionListeners.clear();
  }

  void addP2PPeersChangeListener(Function(List<WifiP2pDevice>) listener){
    peersListeners.add(listener);
  }

  void clearP2PPeersChangeListener(){
    peersListeners.clear();
  }

  void register() async {
    if (!await checkPermission()) {
      return;
    }

    _subscriptions.add(FlutterP2pPlus.wifiEvents.stateChange!.listen((change) {
      log("Wifi state changed: $change");
    }));

    _subscriptions.add(FlutterP2pPlus.wifiEvents.connectionChange!.listen((change) {
      log("Wifi connection changed: $change");
      isConnected = change.networkInfo.isConnected;
      deviceAdress = change.wifiP2pInfo.groupOwnerAddress;
      isHost = change.wifiP2pInfo.isGroupOwner;
      log("isConnected: $isConnected");
      log("deviceAdress: $deviceAdress");
      log("isHost: $isHost");
      connectionListeners.forEach((listener) => listener(change));
      if(isConnected && !isHost) onConnectedAsClient(deviceAdress);
    }));

    _subscriptions.add(FlutterP2pPlus.wifiEvents.thisDeviceChange!.listen((change) {
      log("Wifi this device changed: $change");
    }));

    _subscriptions.add(FlutterP2pPlus.wifiEvents.peersChange!.listen((change) {
      log("Wifi peers changed: $change");
      _peers = change.devices;
      peersListeners.forEach((listener) {
        List<WifiP2pDevice> devices = [];
        change.devices.forEach((element) {
          if(!connectedDevices.contains(element.deviceAddress)){
            devices.add(element);
          }
        });
        listener(devices);
      });
    }));

    _subscriptions.add(FlutterP2pPlus.wifiEvents.discoveryChange!.listen((change) {
      log("Wifi discovery changed: $change");
    }));

    try{
      FlutterP2pPlus.register();
    } catch (e) {
      log("Error while registering: $e");
    }
  }

  void onConnectedAsClient(String deviceAdress){
    GameParty().setConnection(P2PConnection.connectToServer(deviceAdress));
  }

  void onConnectedAsServer(){
    GameParty().setConnection(P2PConnection.createServer());
    serverConnectedListeners.forEach((listener) => listener());
  }

  void addOnServerConnectedEventListener(Function() listener){
    serverConnectedListeners.add(listener);
  }

  void clearOnServerConnectedEventListener(){
    serverConnectedListeners.clear();
  }

  void unregister() {
    log("Unreigster from P2P");
    try {
      _subscriptions.forEach((subscription) => subscription.cancel());
      _subscriptions.clear();
      FlutterP2pPlus.unregister();  // Unregister from the native events
    } catch (e) {
      log("Error while unregistering: $e");
    }
  }

  void startDiscovery() async {
    log("Start discovery p2p");
    await FlutterP2pPlus.discoverDevices();
  }

  Future<bool?> disconnect() async {
    log("Disconnect from p2p");
    try {
      unregister();
      if(GameParty().connection != null) GameParty().connection!.close();
      GameParty().stopGame();
      //connectedDevices = [];
      //isConnected = false;
      bool? result = await FlutterP2pPlus.removeGroup();
      return result;
    } catch (e) {
      log("Error while disconnecting: $e");
    }
    return false;
  }

  Future<bool> connect(WifiP2pDevice device) async {
    log("Connect to device: $device");
    if(!isConnected){
      bool result = await FlutterP2pPlus.connect(device) ?? false;
      isConnected = result;
      if(isConnected){
        connectedDevices.add(device.deviceAddress);
        onConnectedAsServer();
      }
      return result;
    }
    return true;
  }

}