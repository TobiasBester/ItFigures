import 'number_generator.dart';

class NumberGeneratorFactory {
  static NumberGenerator createRandom() {
    return NumberGenerator.createRandom();
  }

  static NumberGenerator createWithSeed(int seed) {
    return NumberGenerator.createSeeded(seed);
  }

  static NumberGenerator createForToday() {
    final now = DateTime.now();
    final lastMidnight = DateTime(now.year, now.month, now.day);
    return NumberGenerator.createSeeded(lastMidnight.millisecondsSinceEpoch);
  }
}
