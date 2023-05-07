enum EventType {
  PLAYER_JOINED(text: "PLAYER_JOINED"),
  START_GAME(text: "START_GAME"),
  PLAYER_PROGESS_TEXT(text: "PLAYER_PROGESS_TEXT"),
  READY(text: "READY"),
  NEXT_GAME(text: "NEXT_GAME"),
  ADD_PLAYER_SCORE(text: "ADD_PLAYER_SCORE"),
  RECEIVED_SCORE(text: "RECEIVED_SCORE"),
  END_GAME(text: "END_GAME"),
  SAFE_LANDING(text: "SAFE_LANDING"),
  FRUITS_SLASH_END(text: "FRUITS_SLASH_END"),
  FACE_PART_GUESS(text: "FACE_PART_GUESS"),
  FACE_ANSWER(text: "FACE_ANSWER"),
  TILT_MAZE_END(text: "TILT_MAZE_END");

  const EventType({required this.text});

  final String text;
}