import 'number_generator.dart';

class NumberGeneratorFactory {
  static NumberGenerator createRandom() {
    return NumberGenerator.createRandom();
  }

  static NumberGenerator createWithSeed(int seed) {
    return NumberGenerator.createSeeded(seed);
  }

  static NumberGenerator createForToday({int diff = 0}) {
    final now = DateTime.now();
    final lastMidnight = DateTime(now.year, now.month, now.day);
    final seed = (lastMidnight.millisecondsSinceEpoch / 1000).floor() + diff;
    return NumberGenerator.createSeeded(seed);
  }
}
