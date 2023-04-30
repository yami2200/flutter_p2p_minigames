import 'dart:convert';
import 'dart:math';
import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter_p2p_plus/flutter_p2p_plus.dart';
import 'package:flutter_p2p_plus/protos/protos.pb.dart';
import 'package:permission_handler/permission_handler.dart';

class P2PExample extends StatefulWidget {
  @override
  _P2PExampleState createState() => _P2PExampleState();
}

class _P2PExampleState extends State<P2PExample> with WidgetsBindingObserver {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var _deviceAddress = "";
  var _isConnected = false;
  var _isHost = false;
  var _isOpen = false;

  P2pSocket? _socket;
  List<WifiP2pDevice> devices = [];
  final List<StreamSubscription> _subscriptions = [];

  @override
  void initState() {
    super.initState();
    _register();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    FlutterP2pPlus.removeGroup();
    for (var element in _subscriptions) {
      element.cancel();
    }
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _register();
    } else if (state == AppLifecycleState.paused) {
      _unregister();
    }
  }

  void _register() async {
    await Permission.location.request();

    if (!await _checkPermission()) {
      return;
    }
    _subscriptions.add(FlutterP2pPlus.wifiEvents.stateChange!.listen((change) {
      developer.log("stateChange: ${change.isEnabled}");
    }));

    _subscriptions.add(FlutterP2pPlus.wifiEvents.connectionChange!.listen((change) {
      developer.log("connectionChange: ${change.wifiP2pInfo.isGroupOwner} Connected: ${change.networkInfo.isConnected}");
      setState(() {
        _isConnected = change.networkInfo.isConnected;
        _isHost = change.wifiP2pInfo.isGroupOwner;
        _deviceAddress = change.wifiP2pInfo.groupOwnerAddress;
      });
    }));

    _subscriptions.add(FlutterP2pPlus.wifiEvents.thisDeviceChange!.listen((change) {
      developer.log(
          "deviceChange: ${change.deviceName} / ${change.deviceAddress} / ${change.primaryDeviceType} / ${change.secondaryDeviceType} ${change.isGroupOwner ? 'GO' : '-GO'}");
    }));

    _subscriptions.add(FlutterP2pPlus.wifiEvents.discoveryChange!.listen((change) {
      developer.log("discoveryStateChange: ${change.isDiscovering}");
    }));

    _subscriptions.add(FlutterP2pPlus.wifiEvents.peersChange!.listen((change) {
      developer.log("peersChange: ${change.devices.length}");
      for (var device in change.devices) {
        developer.log("device: ${device.deviceName} / ${device.deviceAddress}");
      }

      setState(() {
        devices = change.devices;
      });
    }));

    FlutterP2pPlus.register();
  }

  void _unregister() {
    for (var subscription in _subscriptions) {
      subscription.cancel();
    }
    FlutterP2pPlus.unregister();
  }

  void _openPortAndAccept(int port) async {
    if (!_isOpen) {
      var socket = await FlutterP2pPlus.openHostPort(port);
      setState(() {
        _socket = socket;
      });

      var buffer = "";
      socket?.inputStream.listen((data) {
        var msg = String.fromCharCodes(data.data);
        buffer += msg;
        if (data.dataAvailable == 0) {
          snackBar("Data Received from ${_isHost ? "Client" : "Host"}: $buffer");
          socket.writeString("Successfully received: $buffer");
          buffer = "";
        }
      });

      debugPrint("_openPort done");
      _isOpen = await FlutterP2pPlus.acceptPort(port) ?? false;
      debugPrint("_accept done: $_isOpen");
    }
  }

  _connectToPort(int port) async {
    var socket = await FlutterP2pPlus.connectToHost(
      _deviceAddress,
      port,
      timeout: 100000,
    );

    setState(() {
      _socket = socket;
    });

    _socket?.inputStream.listen((data) {
      var msg = utf8.decode(data.data);
      snackBar("Received from ${_isHost ? "Host" : "Client"} $msg");
    });

    debugPrint("_connectToPort done");
  }

  Future<bool> _checkPermission() async {
    // if (!await FlutterP2pPlus?.isLocationPermissionGranted()) {
    //   await FlutterP2pPlus.requestLocationPermission();
    //   return false;
    // }
    if (await Permission.location.status.isDenied) {
      return false;
    }
    return true;
  }

  Future<bool?> _disconnect() async {
    bool? result = await FlutterP2pPlus.removeGroup();
    _unregister();
    _socket = null;
    if ((result ?? false)) _isOpen = false;
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: const Text('Plugin example app 2'),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ListTile(
              title: const Text("Registration"),
              subtitle: Text("P2P Registration"),
              onTap: () async {
                await FlutterP2pPlus.register();
              },
            ),
            ListTile(
              title: const Text("Connection State"),
              subtitle: Text(_isConnected ? "Connected: ${_isHost ? "Host" : "Client"}" : "Disconnected"),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Controller",
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
            IntrinsicHeight(
              child: Row(
                children: [
                  Expanded(
                    child: ListTile(
                      title: const Text("Discover Devices"),
                      onTap: () async {
                        if (!_isConnected) {
                          try {
                            await FlutterP2pPlus.discoverDevices();
                          } catch(e) {
                            snackBar(e.toString());
                          }
                        } else {
                          return;
                        }
                      },
                    ),
                  ),
                  VerticalDivider(
                    color: Colors.grey,
                  ),
                  Expanded(
                    child: ListTile(
                      title: const Text("Stop Discover Devices"),
                      onTap: () async {
                        FlutterP2pPlus.stopDiscoverDevices();
                      },
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
            ListTile(
              title: const Text("Open and accept data from port 8000"),
              subtitle: _isConnected ? const Text("Active") : const Text("Disable"),
              onTap: _isConnected && _isHost ? () => _openPortAndAccept(8000) : null,
            ),
            const Divider(),
            ListTile(
              title: const Text("Connect to port 8000"),
              subtitle: const Text("This is able to only Client"),
              onTap: _isConnected && !_isHost ? () => _connectToPort(8000) : null,
            ),
            const Divider(),
            ListTile(
              title: const Text("Send hello world"),
              onTap: _isConnected ? () async => await _socket?.writeString("Hello World") : null,
            ),
            const Divider(),
            ListTile(
              title: const Text("Disconnect"),
              onTap: _isConnected ? () async => await _disconnect() : null,
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Device List",
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
            Expanded(
              child: ListView(
                children: devices.map((d) {
                  return ListTile(
                    title: Text(d.deviceName),
                    subtitle: Text(d.deviceAddress),
                    onTap: () async {
                      debugPrint("${_isConnected ? "Disconnect" : "Connect"} to device: $_deviceAddress");
                      if (_isConnected) {
                        await FlutterP2pPlus.cancelConnect(d);
                      } else {
                        var result = (await FlutterP2pPlus.connect(d) ?? false);
                        print("[connect] reault: $result");
                        if (result) {
                          _isConnected = true;
                        }
                        setState(() {});
                      }
                    },
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  snackBar(String text) {
    ScaffoldMessenger.of(_scaffoldKey.currentContext!).showSnackBar(
      SnackBar(
        content: Text(text),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}