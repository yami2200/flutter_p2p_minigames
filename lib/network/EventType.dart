enum EventType {
  PLAYER_JOINED(text: "PLAYER_JOINED"),
  START_GAME(text: "START_GAME"),
  PLAYER_PROGESS_TEXT(text: "PLAYER_PROGESS_TEXT");

  const EventType({required this.text});

  final String text;
}