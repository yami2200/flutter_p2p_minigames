enum EventType {
  PLAYER_JOINED(text: "PLAYER_JOINED"),
  START_GAME(text: "START_GAME");

  const EventType({required this.text});

  final String text;
}