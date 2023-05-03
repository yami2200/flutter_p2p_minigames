import 'package:flutter/material.dart';
import 'package:flutter_p2p_minigames/widgets/FancyButton.dart';
import 'package:go_router/go_router.dart';

import 'utils/Storage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  int _avatarIndex = 0; // initial avatar index
  bool _editMode = false;

  final _usernameController = TextEditingController();
  String _tag = ''; // initial tag value

  @override
  void initState() {
    super.initState();
    Storage storage = Storage();
    storage.getUsername().then((value) {
      if (value != null) {
        _editMode = true;
        _usernameController.text = value;
        _updateTag();
      }
    });
    storage.getAvatar().then((value) {
      if (value != null) {
        _avatarIndex = int.parse(value.substring(6, value.length - 4));
      }
    });
  }

  void _updateTag() {
    String username = _usernameController.text;
    if (username.length >= 3) {
      setState(() {
        _tag = username.substring(0, 3).toUpperCase();
      });
    } else {
      setState(() {
        _tag = username.toUpperCase();
      });
    }
  }

  void _save() {
    Storage storage = Storage();
    storage.setUsername(_usernameController.text);
    storage.setTAG(_tag);
    storage.setAvatar('avatar$_avatarIndex.png');
    GoRouter.of(context).go('/');
  }

  @override
  Widget build(BuildContext context) {
    bool _isSaveButtonDisabled = _usernameController.text.length == 0;

    return WillPopScope(
        onWillPop: () async => false,
        child:Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromRGBO(254, 223, 176, 1.0),
        title: Text('${_editMode ? 'Edit ' : 'Create '}Profile',
          style: const TextStyle(
            color: Colors.black,
            fontFamily: 'SuperBubble',
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/ui/background_profile.jpg'),
          fit: BoxFit.cover,
          ),
        ),
      child:Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              color: const Color.fromRGBO(254, 223, 176, 0.8),
              child: Padding(
              padding: const EdgeInsets.all(16.0),
                child:Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_left),
                        onPressed: () {
                          setState(() {
                            _avatarIndex = (_avatarIndex - 1) % 10;
                          });
                        },
                      ),
                      CircleAvatar(
                        backgroundImage: AssetImage('assets/avatars/avatar$_avatarIndex.png'),
                        backgroundColor: Colors.transparent,
                        radius: 75,
                      ),
                      IconButton(
                        icon: const Icon(Icons.arrow_right),
                        onPressed: () {
                          setState(() {
                            _avatarIndex = (_avatarIndex + 1) % 10;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  TextField(
                    controller: _usernameController,
                    cursorColor: const Color.fromRGBO(134, 80, 2, 0.8),
                    style: const TextStyle(
                      fontFamily: 'SuperBubble',
                    ),
                    decoration: InputDecoration(
                      labelText: 'Username',
                      labelStyle: const TextStyle(color: Color.fromRGBO(134, 80, 2, 0.8)),
                      suffixText: 'TAG: $_tag',
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color:
                        Color.fromRGBO(134, 80, 2, 0.8)),
                      ),
                    ),
                    onChanged: (value) {
                      _updateTag();
                    },
                  ),
                ],
              ),
              ),
            ),
            const Spacer(),
            FancyButton(
                size: 30,
                color: Color(0xFF6B3000),
                onPressed: () {
                  if(_usernameController.text.isNotEmpty) _save();
                  },
                  child: const Text(
                  "Save Profile",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontFamily: 'SuperBubble',
                  ),
                )
            ),
          ],
        ),
      ),
    ),
        ),
    );
  }
}