import 'package:flame/components.dart';

class CustomTimerComponent extends TimerComponent {
  CustomTimerComponent({
    required double period,
    bool repeat = false,
    bool autoStart = true,
    bool removeOnFinish = false,
    void Function()? onTick,
  }) : super(
    period: period,
    repeat: repeat,
    autoStart: autoStart,
    removeOnFinish: removeOnFinish,
    onTick: onTick,
  );

  double get remainingTime => timer.current;

  void reset() {
    timer.start();
  }
}