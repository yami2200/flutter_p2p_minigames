import 'package:flutter_p2p_minigames/utils/PlayerInfo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Storage {

  static final Storage _instance = Storage._internal();

  Storage._internal();

  factory Storage() {
    return _instance;
  }

  Future<String?> _getStorageValueString(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  _setStorageValueString(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  _removeStorageKey(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }

  /* ##################### USER INFORMATION GETTERS & SETTERS ##################### */

  Future<String?> getUsername() async {
    return _getStorageValueString("username");
  }

  setUsername(String username) async {
    await _setStorageValueString("username", username);
  }

  Future<String?> getTAG() async {
    return _getStorageValueString("tag");
  }

  setTAG(String tag) async {
    await _setStorageValueString("tag", tag);
  }

  Future<String?> getAvatar() async {
    return _getStorageValueString("avatar");
  }

  setAvatar(String avatar) async {
    await _setStorageValueString("avatar", avatar);
  }

  Future<PlayerInfo> getPlayerInfo() async {
    final List<Future<String?>> futures = [
      getUsername(),
      getTAG(),
      getAvatar(),
    ];

    final List<String?> results = await Future.wait(futures);
    return PlayerInfo(results[0]!, results[1]!, results[2]!);
  }
}