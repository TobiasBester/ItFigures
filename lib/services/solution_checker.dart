import 'dart:developer';

import 'package:it_figures/models/operand_model.dart';
import 'package:it_figures/models/operation_solution.dart';
import 'package:it_figures/models/possible_solution.dart';
import "package:trotter/trotter.dart";

class SolutionChecker {
  static GameSolution? trySolve(List<Operand> operands, int target) {
    final gameSolution = _trySolve(operands, target);
    return gameSolution;
  }

  static GameSolution? _trySolve(List<Operand> operands, int target) {
    for (int i = 2; i < operands.length + 1; i++) {
      final possibleSolution = _trySolveWithNOperands(i, operands, target);

      if (possibleSolution != null) {
        return possibleSolution;
      }
    }

    return null;
  }

  static GameSolution? _trySolveWithNOperands(int n, List<Operand> operands, int target) {
    final operandCombinations = Combinations(n, operands);
    for (final operandCombination in operandCombinations()) {
      final possibleSolution = PossibleSolution(operandCombination, target).evaluateAllPossibilities();
      if (possibleSolution != null) {
        return GameSolution(target, operandCombination, possibleSolution);
      }
    }
    return null;
  }
}
