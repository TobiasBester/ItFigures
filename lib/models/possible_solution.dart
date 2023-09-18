import 'package:it_figures/models/operand_model.dart';
import 'package:it_figures/models/operator_model.dart';
import "package:trotter/trotter.dart";

class PossibleSolution {
  final List<Operand> operands;
  final int target;
  static int MAX_CHECKS = 100000;

  PossibleSolution(this.operands, this.target);

  TokenizedSolution? evaluateAllPossibilities() {
    int numChecks = 0;
    final combinations = Permutations(operands.length, operands);
    final operatorCombinations = Amalgams(operands.length - 1, Operator.values);
    for (final combination in combinations()) {
      for (final operatorCombination in operatorCombinations()) {
        if (numChecks == MAX_CHECKS) {
          return null;
        }

        numChecks++;
        final elements = <String>[];
        for (int i = 0; i < combination.length; i++) {
          elements.add(combination[i].value.toString());
          if (i < operatorCombination.length) {
            elements.add(operatorCombination[i].standaloneText);
          }
        }

        final tokenizedSolution = TokenizedSolution(elements);
        final result = tokenizedSolution.evaluate();
        if (result != null && result == target) {
          return tokenizedSolution;
        }
      }
    }
    return null;
  }
}

class TokenizedSolution {
  final List<String> elements;

  TokenizedSolution(this.elements);

  int? evaluate() {
    List<String> elementList = elements.toList();
    int runningTotal = int.parse(elementList[0]);
    while (elementList.length > 1) {
      try {
        int operand1 = runningTotal;
        int operand2 = int.parse(elementList[2]);
        Operator operator = Operator.fromString(elementList[1]);
        runningTotal = operator.operate(operand1, operand2);
        elementList.removeRange(0, 2);
      } catch (e) {
        return null;
      }
    }
    return runningTotal;
  }

  TokenizedSolution.fromJson(Map<String, dynamic> json)
      : elements = (json['elements'] as List<dynamic>).map((e) => e.toString()).toList();

  Map<String, dynamic> toJson() => {
        'elements': elements,
      };

  @override
  String toString() {
    return elements.join(' ');
  }
}
