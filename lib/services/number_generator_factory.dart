import 'number_generator.dart';

class NumberGeneratorFactory {
  static NumberGenerator createRandom() {
    return NumberGenerator.createRandom();
  }

  static NumberGenerator createWithSeed(int seed) {
    return NumberGenerator.createSeeded(seed);
  }
}
