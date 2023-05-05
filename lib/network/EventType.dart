enum EventType {
  PLAYER_JOINED(text: "PLAYER_JOINED"),
  START_GAME(text: "START_GAME"),
  PLAYER_PROGESS_TEXT(text: "PLAYER_PROGESS_TEXT"),
  READY(text: "READY"),
  NEXT_GAME(text: "NEXT_GAME"),
  ADD_PLAYER_SCORE(text: "ADD_PLAYER_SCORE"),
  RECEIVED_SCORE(text: "RECEIVED_SCORE"),
  END_GAME(text: "END_GAME");

  const EventType({required this.text});

  final String text;
}