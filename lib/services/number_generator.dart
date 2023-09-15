import 'dart:math';

import 'package:it_figures/models/operand_model.dart';

class NumberGenerator {
  static const int NUM_INITIAL_OPERANDS = 6;
  static const List<int> MAX_OPERANDS = [25, 100, 100, 100, 100];
  static const List<int> MIN_TOTALS = [25, 100, 150, 250, 350];
  static const List<int> MAX_TOTALS = [100, 200, 400, 500, 500];
  static const List<int> SMALL_ROUND_NUMBERS = [10, 25, 50];
  static const List<int> LARGE_ROUND_NUMBERS = [25, 50, 100];
  final Random random;
  final int seed;

  NumberGenerator(this.seed, this.random);

  static NumberGenerator createRandom() {
    int randomSeed = getRandomSeed();
    return NumberGenerator(randomSeed, Random(randomSeed));
  }

  static NumberGenerator createSeeded(int seed) {
    return NumberGenerator(seed, Random(seed));
  }

  static int getRandomSeed() {
    return Random().nextInt(1000000);
  }

  int getRandomNumber(int max, {int min = 1}) {
    return random.nextInt(max - min) + min; // chosen by fair dice roll.
  }

  List<Operand> getRandomNumberOperands(int level) {
    List<int> existingOperands = [];

    return List.generate(NUM_INITIAL_OPERANDS, (index) {
      bool isAdded = false;
      Operand operand = Operand(index, getRandomNumber(MAX_OPERANDS[level]));
      while (!isAdded) {
        if (!existingOperands.contains(operand.value)) {
          existingOperands.add(operand.value);
          isAdded = true;
        } else {
          operand = Operand(index, getRandomNumber(MAX_OPERANDS[level]));
        }
      }
      return operand;
    });
  }

  int getRandomTotalTarget(int level) {
    return getRandomNumber(MAX_TOTALS[level], min: MIN_TOTALS[level]);
  }

  T getRandomItem<T>(List<T> items) {
    return items[getRandomNumber(items.length)];
  }

  int getSmallRoundNumber() {
    return getRandomItem(SMALL_ROUND_NUMBERS);
  }

  int getLargeRoundNumber() {
    return getRandomItem(LARGE_ROUND_NUMBERS);
  }
}
