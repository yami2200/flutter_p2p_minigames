import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({ super.key });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  int _avatarIndex = 0; // initial avatar index

  final _usernameController = TextEditingController();
  String _tag = ''; // initial tag value

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
    // TODO: implement save functionality
  }

  @override
  Widget build(BuildContext context) {
    bool _isSaveButtonDisabled = _usernameController.text.length == 0;

    return WillPopScope(
        onWillPop: () async => false,
        child:Scaffold(
      appBar: AppBar(
        title: Text('Create Profile'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_left),
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
                  icon: Icon(Icons.arrow_right),
                  onPressed: () {
                    setState(() {
                      _avatarIndex = (_avatarIndex + 1) % 10;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 32),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
                suffixText: 'TAG: $_tag',
              ),
              onChanged: (value) {
                _updateTag();
              },
            ),
            Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSaveButtonDisabled ? null : _save,
                child: Text('Save'),
              ),
            ),
          ],
        ),
      ),
    ),
    );
  }
}