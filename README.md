<h1 align="center">Frenzy Camp</h1>
<h4 align="center">1v1 Multiplayer mini games party</h4>
<p align="center">
   <img src="https://img.shields.io/badge/-Mini_Games-orange" alt="Mini_Games">
   <img src="https://img.shields.io/badge/-Peer_to_Peer-red" alt="Peer_to_Peer">
   <img src="https://img.shields.io/badge/-Flutter-blue" alt="Flutter">
    <img src="https://img.shields.io/badge/-Multiplayer-green" alt="Multiplayer">
</p>

---

Frenzy Camp is a Flutter project that enables peer-to-peer connectivity for an 1v1 multiplayer gaming experience. 
This repository contains a collection of eight distinct mini-games, where players can connect with each other and engage in thrilling battles across a series of five randomly selected mini-games.

### Quick Reminder

This project was created as a school project for Mobile programming.

## Games

### 1. Face Guess
**Description :** Face Guess is a mini-game that puts your observation and timing skills to the test. 
Players are presented with a random face consisting of eyes, nose, mouth, and face shape. 
The face is displayed for a brief 8-second period before disappearing. 
After the countdown, players must click on each face element at the right moment as they appear in a loop.

**Input :** tap on the screen

**Feature :** 
- Tap event detection
- Real-time face element animation replication

**Screenshots & gif :**

![qsd](/docs/faceguess.gif)

## Technical information :

### 1. Testing
The connectivity have been designed to implements a specific interface. This design allowed us to develop a peer-to-peer connectivity and a websocket connectivity without changing the code of the games.

To test the games, go in lib/utils/Config and enable devMode.
Then, go in dev_ws_server and run the server with the command : 
```
node server.js
```
Finally, run the app on two web browsers (chrome and edge have been used for the development).

### 2. Message exchange
The message exchange is based on a JSON format. The message is composed of a type and a data. The type is used to know what to do with the data. The data is a JSON object that contains all the information needed to execute the action.

We use auto generated code to serialize and deserialize the JSON object. To generate the json code, we use the command : 
```
flutter pub run build_runner build --delete-conflicting-outputs
```

### 3. Game Engine
In order to be able to develop performant games, we have used the Flame game engine. 
This engine is based on the Flutter engine and allows us to develop games with a good performance.
Our usage of this game engine has been mainly focus on SpriteComponents (used to display images) and on the update method (used to update the game state at each tick).
We used a bit of gesture event handler to detect movement and tap event on the screen. Some of the games also use collision detection.

### 4. Assets
All the assets used in the games are stored in the assets folder. 
All the images have been generated by AI with Bing Creator, then, we upscaled them with AI on [upscale.media](https://www.upscale.media/). For some of them, we did a bit of compositing.
Sounds and musics are not copyrights free and all credits goes to :