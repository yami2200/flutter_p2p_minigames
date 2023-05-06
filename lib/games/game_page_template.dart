import 'package:flutter/material.dart';

import '../../widgets/GamePage.dart';
import '../network/EventData.dart';

// Edit the class name here
class GamePageTemplate extends GamePage {

  // Edit the constructor here (bannerColor and background)
  GamePageTemplate({super.key, required bool training})
      : super(bannerColor: const Color.fromRGBO(154, 216, 224, 0.8),
      training: training,
      background: "assets/ui/background_capyquiz.jpg");

  @override
  GamePageState createState() => _GamePageTemplateState();
}

// Edit the state class name here (it should always extends GamePageState)
class _GamePageTemplateState extends GamePageState {

  @override
  void onMessageFromServer(EventData message) {
    // triggered when a message is received from the server
    /*
    if(message.type == EventType.YOUR_TYPE.text){
      // do something
    }
    if(message.type == EventType.YOUR_TYPE.text){
      YourDataType yourData = YourDataType.fromJson(jsonDecode(message.data));
      // do something with data received
    }
    */
  }

  @override
  void onMessageFromClient(EventData message) {
    // triggered when a message is received from the client
    /*
    if(message.type == EventType.YOUR_TYPE.text){
      // do something
    }
    if(message.type == EventType.YOUR_TYPE.text){
      YourDataType yourData = YourDataType.fromJson(jsonDecode(message.data));
      // do something with data received
    }
    */
  }

  @override
  void onStartGame(){
    // triggered when the game starts for both players (triggered once we are sure both player are on the game page)
  }

  // HOW TO SET CURRENT PLAYER TEXT PROGRESSION (also broadcast to the opponent)
  // setMainPlayerText("your text"); // this will update the text progression for the current player and send it to the opponent

  // HOW TO SET BACKGROUND IMAGE (only for the current player)
  // setBackgroundImage("assets/ui/background.jpg"); // this will update the background image for the current player

  // HOW TO SEND A MESSAGE TO THE SERVER (if you are the client)
  // GameParty().connection!.sendMessageToServer(jsonEncode(EventData(EventType.YOUR_TYPE.text, jsonEncode(data)))); // this will send a message to the server

  // HOW TO SEND A MESSAGE TO THE CLIENT (if you are the server)
  // GameParty().connection!.sendMessageToClient(jsonEncode(EventData(EventType.YOUR_TYPE.text, jsonEncode(data)))); // this will send a message to the client

  // HOW TO GET THE OPPONENT PLAYER INFO
  // GameParty().opponent!; // this will return the opponent player (care : null if in training mode)

  // HOW TO GET THE CURRENT PLAYER INFO
  // GameParty().player!; // this will return the current player

  // HOW TO KNOW IF WE ARE IN TRAINING MODE
  // widget.training; // this will return true if we are in training mode

  // HOW TO GET THE OPPONENT PLAYER TEXT PROGRESSION
  // opponentPlayerText;

  // HOW TO GET THE CURRENT PLAYER TEXT PROGRESSION
  // mainPlayerText;

  // HOW TO KNOW IF WE ARE THE SERVER
  // GameParty().isServer(); // this will return true if we are the server

  // HOW TO QUIT TRAINING
  // quitTraining(); // this will quit the training mode and go back to game list

  // HOW TO HANDLE END OF A MULTIPLAYER GAME
  // setCurrentPlayerScore(scoreGainFromTheGame); // this will update the current player score and send it to the opponent
  // once score have been sent and received by both player. The game will automatically go to the hub

  // HOW TO KNOW IF THE OTHER PLAYER HAS FINISHED
  // receivedScore; // this variable will be set to true once the opponent player has sent you his score (it means he has finished the game)

  // Override buildWidget to add widgets to the page
  @override
  Widget buildWidget(BuildContext context) {
    return const Text("Template");
    //return GameWidget(game: GameInstance());
  }
}