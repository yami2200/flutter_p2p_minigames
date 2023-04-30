enum EventType {
  PLAYER_JOINED(text: "PLAYER_JOINED");

  const EventType({required this.text});

  final String text;
}