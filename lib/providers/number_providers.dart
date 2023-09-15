import 'dart:developer';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:it_figures/models/operand_model.dart';
import 'package:it_figures/models/operation_selection.dart';
import 'package:it_figures/models/operator_model.dart';
import 'package:it_figures/services/number_generator.dart';
import 'package:it_figures/services/number_generator_factory.dart';

// OPERAND NUMBERS
class OperandNumbersNotifier extends StateNotifier<List<Operand>> {
  OperandNumbersNotifier(int level, NumberGenerator numberGenerator)
      : super(numberGenerator.getRandomNumberOperands(level));

  void regenerate(int level, NumberGenerator numberGenerator) {
    state = numberGenerator.getRandomNumberOperands(level);
  }

  void undoOperation(int operand1Id, int operand2Id) {
    final operands = state;
    final operand1 = operands.firstWhere((element) => element.id == operand1Id);
    final operand1Idx = operands.indexOf(operand1);
    final operand2 = operands.firstWhere((element) => element.id == operand2Id);
    final operand2Idx = operands.indexOf(operand2);
    operand1.unhide();
    operand2.undo();
    operands[operand1Idx] = operand1;
    operands[operand2Idx] = operand2;
    state = [...operands];
  }

  void reset() {
    state = state.map((e) {
      e.reset();
      return e;
    }).toList();
  }
}

final operandNumbersProvider = StateNotifierProvider<OperandNumbersNotifier, List<Operand>>((ref) {
  final level = ref.watch(difficultyLevelProvider);
  final numberGenerator = ref.watch(numberGeneratorProvider);
  return OperandNumbersNotifier(level, numberGenerator);
});

// TOTAL TARGET
class TotalTargetNotifier extends StateNotifier<int> {
  TotalTargetNotifier(int level, NumberGenerator numberGenerator) : super(numberGenerator.getRandomTotalTarget(level));

  void regenerate(int level, NumberGenerator numberGenerator) {
    state = numberGenerator.getRandomTotalTarget(level);
  }
}

final totalTargetProvider = StateNotifierProvider<TotalTargetNotifier, int>((ref) {
  final level = ref.watch(difficultyLevelProvider);
  final numberGenerator = ref.watch(numberGeneratorProvider);
  return TotalTargetNotifier(level, numberGenerator);
});

// LEVEL
class DifficultyLevelNotifier extends StateNotifier<int> {
  DifficultyLevelNotifier() : super(0);

  void update(int newLevel) {
    state = newLevel;
  }
}

final difficultyLevelProvider = StateNotifierProvider<DifficultyLevelNotifier, int>((ref) => DifficultyLevelNotifier());

// NUMBER GENERATOR
class NumberGeneratorNotifier extends StateNotifier<NumberGenerator> {
  NumberGeneratorNotifier() : super(NumberGeneratorFactory.createRandom());

  void update(int seed) {
    state = NumberGeneratorFactory.createWithSeed(seed);
  }
}

final numberGeneratorProvider =
    StateNotifierProvider<NumberGeneratorNotifier, NumberGenerator>((ref) => NumberGeneratorNotifier());

// OPERATION SELECTION
class OperationSelectionNotifier extends StateNotifier<OperationSelection> {
  OperationSelectionNotifier() : super(OperationSelection());

  void setNextOperand(Operand operand) {
    if (state.operand1 == null) {
      state = state.setOperand1(operand);
      return;
    }

    if (state.operand1 == operand) {
      state = state.setOperand1(null);
      return;
    }

    if (state.operator == null) {
      state = state.setOperand1(operand);
      return;
    }

    state = state.setOperand2(operand);
    _attemptOperation();
  }

  void setOperator(Operator operator) {
    if (state.operand1 == null) {
      return;
    }

    if (state.operator == operator) {
      state = state.setOperator(null);
      return;
    }

    state = state.setOperator(operator);
  }

  void _attemptOperation() {
    if (state.operand1 == null || state.operand2 == null || state.operator == null) {
      return;
    }

    try {
      final result = state.operand1!.operate(state.operator!, state.operand2!);
      state = state.setResult(result);
    } catch (e) {
      state = state.setError(e.toString());
    }
  }

  void reset() {
    state = OperationSelection();
  }
}

final operationSelectionProvider =
    StateNotifierProvider<OperationSelectionNotifier, OperationSelection>((ref) => OperationSelectionNotifier());

class OperationResultsNotifier extends StateNotifier<List<OperationResult>> {
  OperationResultsNotifier() : super([]);

  void addResult(OperationResult result) {
    state = [...state, result];
  }

  void removeLastResult() {
    state = state.sublist(0, state.length - 1);
  }

  void reset() {
    state = [];
  }
}

final operationResultsProvider =
    StateNotifierProvider<OperationResultsNotifier, List<OperationResult>>((ref) => OperationResultsNotifier());

// TODO: Implement generic solution checker which can work with any number of values
// TODO: Implement difficulty selector
