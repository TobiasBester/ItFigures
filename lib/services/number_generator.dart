import 'dart:math';

import 'package:it_figures/models/operand_model.dart';

class NumberGenerator {
  static const int NUM_INITIAL_OPERANDS = 6;
  static const int MAX_OPERAND_LIST_GENERATIONS = 10;
  static const List<int> HALF_MAX_OPERANDS = [10, 10, 25, 50, 50];
  static const List<int> MAX_OPERANDS = [25, 50, 50, 100, 100];
  static const List<int> MIN_TOTALS = [25, 100, 150, 250, 350];
  static const List<int> MAX_TOTALS = [100, 200, 400, 500, 500];
  static const List<int> SMALL_ROUND_NUMBERS = [5, 10, 20];
  static const List<int> LARGE_ROUND_NUMBERS = [25, 50, 100];
  Random random;
  int seed;

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
    final levelConfig = levelIntToConfig(level);
    int numSmallRoundNumbersGenerated = 0;
    int numLargeRoundNumbersGenerated = 0;

    final operands = List.generate(NUM_INITIAL_OPERANDS, (index) {
      bool isAdded = false;
      int maxAttempts = 100;
      bool reachedSmallQuota = numSmallRoundNumbersGenerated == levelConfig.numSmallRoundNumbers;
      bool reachedLargeQuota = numLargeRoundNumbersGenerated == levelConfig.numLargeRoundNumbers;
      Operand operand = Operand(index, getQuotaAwareRandomNumber(level, reachedSmallQuota, reachedLargeQuota, maxAttempts));
      while (!isAdded && maxAttempts > 0) {
        maxAttempts--;
        if (!existingOperands.contains(operand.value)) {
          existingOperands.add(operand.value);
          isAdded = true;
          if (SMALL_ROUND_NUMBERS.contains(operand.value) && !reachedSmallQuota) {
            numSmallRoundNumbersGenerated++;
          }
          if (LARGE_ROUND_NUMBERS.contains(operand.value) && !reachedLargeQuota) {
            numLargeRoundNumbersGenerated++;
          }
        } else {
          bool reachedSmallQuotaInner = numSmallRoundNumbersGenerated == levelConfig.numSmallRoundNumbers;
          bool reachedLargeQuotaInner = numLargeRoundNumbersGenerated == levelConfig.numLargeRoundNumbers;
          reseedRandom();
          operand = Operand(index, getQuotaAwareRandomNumber(level, reachedSmallQuotaInner, reachedLargeQuotaInner, maxAttempts));
        }
      }
      return operand;
    });
    operands.shuffle();
    return operands;
  }

  void reseedRandom() {
    seed += 1;
    random = Random(seed);
  }

  int getQuotaAwareRandomNumber(int level, bool reachedSmallQuota, bool reachedLargeQuota, int seedVariance) {
    if (!reachedSmallQuota) {
      return getSmallRoundNumber();
    }
    if (!reachedLargeQuota) {
      return getLargeRoundNumber();
    }
    return getNextBool(seedVariance)
        ? getRandomNumber(HALF_MAX_OPERANDS[level])
        : getRandomNumber(MAX_OPERANDS[level]);
  }

  bool getNextBool(int seedVariance) {
    random = Random(seed + (seedVariance * 5));
    bool result = random.nextBool();
    random = Random(seed - (seedVariance * 5));
    return result;
  }

  int getRandomTotalTarget(int level) {
    final result = getRandomNumber(MAX_TOTALS[level], min: MIN_TOTALS[level]);
    return result;
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

enum LevelConfig {
  levelOne(1, 0),
  levelTwo(2, 0),
  levelThree(1, 1),
  levelFour(1, 1),
  levelFive(1, 0);

  final int numSmallRoundNumbers;
  final int numLargeRoundNumbers;

  const LevelConfig(this.numSmallRoundNumbers, this.numLargeRoundNumbers);
}

LevelConfig levelIntToConfig(int level) {
  switch (level) {
    case 0:
      return LevelConfig.levelOne;
    case 1:
      return LevelConfig.levelTwo;
    case 2:
      return LevelConfig.levelThree;
    case 3:
      return LevelConfig.levelFour;
    case 4:
      return LevelConfig.levelFive;
    default:
      throw Exception('Invalid level $level');
  }
}
